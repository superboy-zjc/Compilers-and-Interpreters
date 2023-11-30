#ifndef CFG_TRANSFORM_H
#define CFG_TRANSFORM_H

#include <memory>
#include "cfg.h"
#include <set>
#include "exceptions.h"

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
typedef int ConstantValue;
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
  std::map<ValueNumber, std::set<Vreg>> m_vn_to_vregs;

  std::map<LVNKey, ValueNumber> m_key_to_vn;
  int m_next_vn = 0;

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
  ValueNumber emit_vn_by_vreg(Vreg vreg)
  {
    ValueNumber vn = emit_value_number();
    m_vreg_to_vn[vreg] = vn;
    auto res = m_vn_to_vregs[vn].insert(vreg);
    if (!res.second)
    {
      RuntimeError::raise("Virtual register already exist!");
    }
    return vn;
  };
  ValueNumber emit_vn_by_const(ConstantValue const_v)
  {
    ValueNumber vn = emit_value_number();
    m_const_to_vn[const_v] = vn;
    m_vn_to_const[vn] = const_v;

    return vn;
  };
  ValueNumber emit_value_number() { return m_next_vn++; };
  void load_value_numbers(const Instruction *ins);
  struct LVNKey get_LVN_key(const Instruction *ins);
  ValueNumber lookup_vn_by_operand(const Operand &opd);
  ValueNumber emit_vn_by_operand(const Operand &opd);
  void assign_vn_by_operand(Operand opd, ValueNumber vn);
  void assign_vn_by_vreg(Vreg vreg, ValueNumber vn);
};

#endif // CFG_TRANSFORM_H
