#ifndef CFG_TRANSFORM_H
#define CFG_TRANSFORM_H

#include <memory>
#include "cfg.h"
#include <set>
#include "exceptions.h"
#include "highlevel.h"
#include "lowlevel.h"
#include "live_vregs.h"
#include <list>
#include <stack>
#include "node.h"
#include "ast_visitor.h"

class ControlFlowGraphTransform
{
private:
  std::shared_ptr<ControlFlowGraph> m_cfg;

public:
  ControlFlowGraphTransform(const std::shared_ptr<ControlFlowGraph> &cfg);
  virtual ~ControlFlowGraphTransform();

  std::shared_ptr<ControlFlowGraph> get_orig_cfg();

  virtual std::shared_ptr<ControlFlowGraph> transform_cfg();

  // Create a transformed version of the instructions in a basic block.
  // Note that an InstructionSequence "owns" the Instruction objects it contains,
  // and is responsible for deleting them. Therefore, be careful to avoid
  // having two InstructionSequences contain pointers to the same Instruction.
  // If you need to make an exact copy of an Instruction object, you can
  // do so using the duplicate() member function, as follows:
  //
  //    Instruction *orig_ins = /* an Instruction object */
  //    Instruction *dup_ins = orig_ins->duplicate();
  virtual std::shared_ptr<InstructionSequence> transform_basic_block(const InstructionSequence *orig_bb) = 0;
};

// Local Value Numbering
typedef int ValueNumber;
typedef long ConstantValue;
typedef int Vreg;

struct LVNKey
{
  int opcode;
  ValueNumber left_vn, right_vn;
  bool is_const;

  // ...member functions...
  LVNKey(int op, int left, int right) : opcode(op), left_vn(left), right_vn(right) {}

  bool operator<(const LVNKey &other) const
  {
    if (opcode != other.opcode)
      return opcode < other.opcode;
    if (left_vn != other.left_vn)
      return left_vn < other.left_vn;
    return right_vn < other.right_vn;
  }
};

class LVNOptimizationHighLevel : public ControlFlowGraphTransform
{
private:
  std::map<ConstantValue, ValueNumber> m_const_to_vn;
  std::map<ValueNumber, ConstantValue> m_vn_to_const;
  std::map<Vreg, ValueNumber> m_vreg_to_vn;
  // std::map<ValueNumber, std::set<Vreg>> m_vn_to_vregs;
  std::map<ValueNumber, std::list<Vreg>> m_vn_to_vregs;

  std::map<LVNKey, ValueNumber> m_key_to_vn;
  int m_next_vn = 0;
  // optimization enable or disable
  bool CONSTANT_FOLDING_MODE = true;
  bool CONSTANT_COPY_PROPAGATION_MODE = true;

  void reset_local_state()
  {
    m_const_to_vn.clear();
    m_vn_to_const.clear();
    m_vreg_to_vn.clear();
    m_vn_to_vregs.clear();
    m_key_to_vn.clear();
    m_next_vn = 0;
  };
  bool is_two_constant_computation(const Instruction *ins);
  ConstantValue lookup_const_by_opd(const Operand &opd);
  bool is_const_by_opd(const Operand &opd);
  bool is_const_by_vn(const ValueNumber &vn);
  long constant_folding_computation(const Instruction *ins);

public:
  LVNOptimizationHighLevel(const std::shared_ptr<ControlFlowGraph> &cfg);
  ~LVNOptimizationHighLevel();

  virtual std::shared_ptr<InstructionSequence>
  transform_basic_block(const InstructionSequence *orig_bb);

  ValueNumber lookup_vn_by_vreg(const Vreg &vreg)
  {
    auto it = m_vreg_to_vn.find(vreg);

    if (it != m_vreg_to_vn.end())
    {
      return it->second;
    }
    else
    {
      return -1;
    }
  };
  ValueNumber lookup_vn_by_const(const ConstantValue &const_v)
  {
    auto it = m_const_to_vn.find(const_v);

    if (it != m_const_to_vn.end())
    {
      return it->second;
    }
    else
    {
      return -1;
    }
  };
  ConstantValue lookup_const_by_vn(const ValueNumber &vn)
  {
    auto it = m_vn_to_const.find(vn);

    if (it != m_vn_to_const.end())
    {
      return it->second;
    }
    else
    {
      return -1;
    }
  };
  ValueNumber lookup_vn_by_LVNKey(const struct LVNKey &key)
  {
    auto it = m_key_to_vn.find(key);

    if (it != m_key_to_vn.end())
    {
      return it->second;
    }
    else
    {
      return -1;
    }
  };
  Vreg lookup_min_vreg_by_vn(const ValueNumber &vn)
  {
    if (m_vn_to_vregs[vn].empty())
    {
      return -1;
    }
    // return *m_vn_to_vregs[vn].begin();
    return m_vn_to_vregs[vn].front();
  }
  ValueNumber emit_vn_by_vreg(Vreg vreg)
  {
    // if (vreg == 0)
    // {
    //   printf("debug!\n");
    // }
    ValueNumber vn = emit_value_number();
    m_vreg_to_vn[vreg] = vn;
    // auto res = m_vn_to_vregs[vn].insert(vreg);
    // if (!res.second)
    // {
    //   RuntimeError::raise("Virtual register already exist!");
    // }
    auto it = std::find(m_vn_to_vregs[vn].begin(), m_vn_to_vregs[vn].end(), vreg);
    if (it != m_vn_to_vregs[vn].end())
    {
      RuntimeError::raise("Virtual register already exist!");
    }
    m_vn_to_vregs[vn].push_back(vreg);

    return vn;
  };
  ValueNumber emit_vn_by_const(ConstantValue const_v)
  {
    ValueNumber vn = emit_value_number();
    m_const_to_vn[const_v] = vn;
    m_vn_to_const[vn] = const_v;

    return vn;
  };
  void set_vn_by_LVNKey(struct LVNKey key, ValueNumber vn)
  {
    m_key_to_vn[key] = vn;
  }
  void add_vreg_by_vn(ValueNumber vn, Vreg vreg)
  {
    // m_vn_to_vregs[vn].insert(vreg);
    auto it = std::find(m_vn_to_vregs[vn].begin(), m_vn_to_vregs[vn].end(), vreg);
    if (it != m_vn_to_vregs[vn].end())
    {
      RuntimeError::raise("Virtual register already exist!");
    }
    m_vn_to_vregs[vn].push_back(vreg);
  }

  ValueNumber emit_value_number() { return m_next_vn++; };
  void load_value_numbers(const Instruction *ins);
  struct LVNKey get_LVN_key(const Instruction *ins);
  ValueNumber lookup_vn_by_operand(const Operand &opd);
  Vreg lookup_vreg_by_LVNKey(const struct LVNKey &key);
  ValueNumber emit_vn_by_operand(const Operand &opd);
  void assign_vn_by_operand(Operand opd, ValueNumber vn);
  void assign_vn_by_vreg(Vreg vreg, ValueNumber vn);
  void assign_vn_by_LVNKey(struct LVNKey key, ValueNumber vn);
  HighLevelOpcode get_mov_opcode(int opcode);
};

class DeadStoreElimination : public ControlFlowGraphTransform
{
private:
  LiveVregs m_live_vregs;

public:
  DeadStoreElimination(const std::shared_ptr<ControlFlowGraph> &cfg);
  ~DeadStoreElimination();

  virtual std::shared_ptr<InstructionSequence>
  transform_basic_block(const InstructionSequence *orig_bb);
};

// LocalRegisterAllocation
typedef int VirtualReg;
typedef int Rank;
// typedef int Location;
// typedef int MachineReg;
struct SpillLocation
{
  int loc;
  bool is_used;
  SpillLocation() : loc(-1), is_used(false) {}
  SpillLocation(int loc, bool is_used) : loc(loc), is_used(is_used) {}
};

struct UseDepth
{
  unsigned depth = 0;
  bool alive = true;

  UseDepth() : depth(0), alive(true) {}
};

class LocalRegisterAllocation : public ControlFlowGraphTransform, public ASTVisitor
{
private:
  LiveVregs m_live_vregs;
  Node *m_func_ast;
  std::vector<std::pair<VirtualReg, Rank>> m_local_rank;
  unsigned long m_cur_rank = 1;

  std::stack<MachineReg> m_register_pool;
  std::map<VirtualReg, MachineReg> m_vreg_to_mreg;
  std::vector<SpillLocation> m_spill_location_pool;
  std::map<VirtualReg, SpillLocation> m_vreg_to_spill_loc;

  void reset_local_state()
  {
    std::stack<MachineReg>().swap(m_register_pool);
    m_vreg_to_mreg.clear();
    // m_spill_location_pool.clear();
    m_vreg_to_spill_loc.clear();
  };

  void prepare_register_pool(const InstructionSequence *orig_bb);
  // void prepare_un_assignable_vreg_pool(const InstructionSequence *orig_bb);
  bool is_assignable_vreg(const Operand &opd, const InstructionSequence *orig_bb);
  bool is_eager_to_be_assigned(const Operand &opd, const InstructionSequence *orig_bb);
  bool is_eager_to_be_allocated(const Operand &opd, const InstructionSequence *orig_bb);
  bool is_local_variable_vreg(const Operand &opd);
  Operand assign_machine_reg(Operand opd, const InstructionSequence *orig_bb);
  Operand assign_mreg_by_rank(Operand opd);
  void allocate_machine_reg(Operand opd, const InstructionSequence *orig_bb, Instruction *ins, std::shared_ptr<InstructionSequence> &main_seq);
  void refresh_mreg_pool(Operand opd, const InstructionSequence *orig_bb, Instruction *ins);
  MachineReg sacrifice_a_temp_vreg(const InstructionSequence *orig_bb, Instruction *ins, std::shared_ptr<InstructionSequence> &main_seq);
  MachineReg emit_machine_reg_from_pool();
  int emit_spill_offset(const VirtualReg &pathetic_vreg);

  bool is_vreg_allocated(VirtualReg vreg)
  {
    if (m_vreg_to_mreg.find(vreg) == m_vreg_to_mreg.end())
      return false;
    return true;
  }

  MachineReg find_mreg_by_vreg(int vreg_n)
  {
    // if already allocated
    auto it = m_vreg_to_mreg.find(vreg_n);
    if (it != m_vreg_to_mreg.end())
      return it->second;
    // if not found
    return MREG_END;
  }

public:
  LocalRegisterAllocation(const std::shared_ptr<ControlFlowGraph> &cfg, Node *func_ast);
  ~LocalRegisterAllocation();

  virtual std::shared_ptr<InstructionSequence>
  transform_basic_block(const InstructionSequence *orig_bb);

  // virtual void visit_function_definition(Node *n);
  // virtual void visit_statement_list(Node *n);
  // virtual void visit_expression_statement(Node *n);
  // virtual void visit_return_statement(Node *n);
  // virtual void visit_return_expression_statement(Node *n);
  // virtual void visit_while_statement(Node *n);
  // virtual void visit_do_while_statement(Node *n);
  // virtual void visit_for_statement(Node *n);
  // virtual void visit_if_statement(Node *n);
  // virtual void visit_if_else_statement(Node *n);
  // virtual void visit_binary_expression(Node *n);
  // virtual void visit_unary_expression(Node *n);
  // virtual void visit_function_call_expression(Node *n);
  // virtual void visit_field_ref_expression(Node *n);
  // virtual void visit_indirect_field_ref_expression(Node *n);
  // virtual void visit_array_element_ref_expression(Node *n);
  virtual void visit_variable_ref(Node *n);
  // virtual void visit_literal_value(Node *n);
  // virtual void visit_implicit_conversion(Node *n);
};

#endif // CFG_TRANSFORM_H
