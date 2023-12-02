#include <cassert>
#include "cfg.h"
#include "cfg_transform.h"
#include <map>
#include "highlevel_defuse.h"

ControlFlowGraphTransform::ControlFlowGraphTransform(const std::shared_ptr<ControlFlowGraph> &cfg)
    : m_cfg(cfg)
{
}

ControlFlowGraphTransform::~ControlFlowGraphTransform()
{
}

std::shared_ptr<ControlFlowGraph> ControlFlowGraphTransform::get_orig_cfg()
{
  return m_cfg;
}

bool match_opcode(int opcode, HighLevelOpcode hlcode)
{
  if (hlcode == HINS_sconv_bw || hlcode == HINS_uconv_bw)
  {
    if (opcode >= hlcode && opcode <= hlcode + 5)
      return true;
  }
  else if (opcode >= hlcode && opcode <= hlcode + 3)
  {
    return true;
  }
  return false;
}

std::shared_ptr<ControlFlowGraph> ControlFlowGraphTransform::transform_cfg()
{
  std::shared_ptr<ControlFlowGraph> result(new ControlFlowGraph());

  // map of basic blocks of original CFG to basic blocks in transformed CFG
  std::map<BasicBlock *, BasicBlock *> block_map;

  // iterate over all basic blocks, transforming each one
  for (auto i = m_cfg->bb_begin(); i != m_cfg->bb_end(); i++)
  {
    BasicBlock *orig = *i;

    // Transform the instructions
    std::shared_ptr<InstructionSequence> transformed_bb = transform_basic_block(orig);

    // Create transformed basic block; note that we set its
    // code order to be the same as the code order of the original
    // block (with the hope of eventually reconstructing an InstructionSequence
    // with the transformed blocks in an order that matches the original
    // block order)
    BasicBlock *result_bb = result->create_basic_block(orig->get_kind(), orig->get_code_order(), orig->get_label());
    for (auto j = transformed_bb->cbegin(); j != transformed_bb->cend(); ++j)
      result_bb->append((*j)->duplicate());

    block_map[orig] = result_bb;
  }

  // add edges to transformed CFG
  for (auto i = m_cfg->bb_begin(); i != m_cfg->bb_end(); i++)
  {
    BasicBlock *orig = *i;
    const ControlFlowGraph::EdgeList &outgoing_edges = m_cfg->get_outgoing_edges(orig);
    for (auto j = outgoing_edges.cbegin(); j != outgoing_edges.cend(); j++)
    {
      Edge *orig_edge = *j;

      BasicBlock *transformed_source = block_map[orig_edge->get_source()];
      BasicBlock *transformed_target = block_map[orig_edge->get_target()];

      result->create_edge(transformed_source, transformed_target, orig_edge->get_kind());
    }
  }

  return result;
}

////////////////////////////////////////////////////////////////////////
// Local Value Numbering implementation                                                //
////////////////////////////////////////////////////////////////////////
LVNOptimizationHighLevel::LVNOptimizationHighLevel(const std::shared_ptr<ControlFlowGraph> &cfg)
    : ControlFlowGraphTransform(cfg)
{
}

LVNOptimizationHighLevel::~LVNOptimizationHighLevel()
{
}

std::shared_ptr<InstructionSequence>
LVNOptimizationHighLevel::transform_basic_block(const InstructionSequence *orig_bb)
{
  std::shared_ptr<InstructionSequence> result_iseq(new InstructionSequence());

  for (auto i = orig_bb->cbegin(); i != orig_bb->cend(); ++i)
  {
    Instruction *orig_ins = *i;
    int opcode = orig_ins->get_opcode();
    int opd_nums = orig_ins->get_num_operands();

    // if not a def operation, we don't have to optimize it.
    if ((opd_nums == 2 || opd_nums == 3))
    {
      // if (orig_ins->get_operand(1).get_kind() == Operand::VREG && orig_ins->get_operand(1).get_base_reg() == 16 && orig_ins->get_operand(0).get_kind() == Operand::VREG_MEM)
      if (orig_ins->get_operand(1).get_kind() == Operand::IMM_IVAL && orig_ins->get_operand(0).get_kind() == Operand::VREG && orig_ins->get_operand(0).get_base_reg() == 1)
      {
        // printf("debug here\n");
      }
      // load value number for each operand
      load_value_numbers(orig_ins);
      // if spill
      if (match_opcode(opcode, HighLevelOpcode::HINS_spill_b))
      {
        result_iseq->append(orig_ins->duplicate());
        continue;
      }
      // if mov , don't need to eliminate computation
      else if (match_opcode(opcode, HighLevelOpcode::HINS_mov_b))
      {
        Operand dst = orig_ins->get_operand(0);
        Operand src = orig_ins->get_operand(1);
        assign_vn_by_operand(dst, lookup_vn_by_operand(src));
      }
      /*
        Eliminate redundancy computation, and maintain LVN list
      */
      if (!match_opcode(opcode, HighLevelOpcode::HINS_mov_b))
      {
        struct LVNKey key = get_LVN_key(orig_ins);
        // value number has been recorded, but the destructive assignment clear the registers
        Vreg vreg = lookup_vreg_by_LVNKey(key);
        // LVNKey matched to certain value number
        if (vreg != -1)
        {
          //  eliminate the computation
          Instruction *optimized_ins = new Instruction(get_mov_opcode(orig_ins->get_opcode()), orig_ins->get_operand(0), Operand(Operand::VREG, vreg));
          result_iseq->append(optimized_ins);
          continue;
        }
        // if not match, add a mapping record
        // bypass memory reference, we are not sure the exact value in the memory
        if (HighLevel::is_def(orig_ins))
        {
          ValueNumber dst_vn = lookup_vn_by_operand(orig_ins->get_operand(0));
          set_vn_by_LVNKey(key, dst_vn);
        }

        // printf("/* key: %d %d %d */\n", key.opcode, key.left_vn, key.right_vn);
      }
    }
    if (opd_nums == 2 || opd_nums == 3)
    {
      // constant folding
      if (CONSTANT_FOLDING_MODE)
      {
        if (is_two_constant_computation(orig_ins))
        {
          // compute constants in runtime
          long res = constant_folding_computation(orig_ins);
          // constant folding
          Instruction *optimized_ins = new Instruction(get_mov_opcode(orig_ins->get_opcode()), orig_ins->get_operand(0), Operand(Operand::IMM_IVAL, res));
          result_iseq->append(optimized_ins);
          continue;
        }
        else if (match_opcode(opcode, HINS_sconv_bw) && is_const_by_opd(orig_ins->get_operand(1)))
        {
          Operand dst = orig_ins->get_operand(0);
          Operand src = orig_ins->get_operand(1);
          assign_vn_by_operand(dst, lookup_vn_by_operand(src));
        }
        else if (match_opcode(opcode, HINS_neg_b))
        {
          // compute constants in runtime
          long res = constant_folding_computation(orig_ins);
          // constant folding
          Instruction *optimized_ins = new Instruction(get_mov_opcode(orig_ins->get_opcode()), orig_ins->get_operand(0), Operand(Operand::IMM_IVAL, res));
          result_iseq->append(optimized_ins);
          continue;
        }
      }
      // constant propagation
      if (CONSTANT_COPY_PROPAGATION_MODE)
      {
        Instruction *optimized_ins;
        std::vector<Operand> opd_list;
        // not to propagation dest operand
        for (int i = 0; i < opd_nums; i++)
        {
          Operand cur_opd = orig_ins->get_operand(i);
          opd_list.push_back(cur_opd);
          // for constant
          if (i >= 1 && is_const_by_opd(cur_opd))
          {
            opd_list[i] = Operand(Operand::IMM_IVAL, lookup_const_by_opd(cur_opd));
          }
          // for virtual register or memory reference
          else if (i >= 1 && (cur_opd.get_kind() == Operand::VREG || cur_opd.get_kind() == Operand::VREG_MEM))
          {
            // search value number based on virtual register
            // if (cur_opd.get_kind() == Operand::VREG_MEM)
            // {
            //   printf("debug\n");
            // }
            Vreg best_vreg = lookup_min_vreg_by_vn(lookup_vn_by_vreg(cur_opd.get_base_reg()));
            if (best_vreg == -1)
            {
              RuntimeError::raise("err!\n");
            }
            // update the current operand
            if (cur_opd.get_kind() == Operand::VREG)
              opd_list[i] = Operand(Operand::VREG, best_vreg);
            else
              opd_list[i] = Operand(Operand::VREG_MEM, best_vreg);
          }
        }
        if (opd_nums == 2)
        {
          optimized_ins = new Instruction(opcode, opd_list[0], opd_list[1]);
        }
        else if (opd_nums == 3)
        {
          optimized_ins = new Instruction(opcode, opd_list[0], opd_list[1], opd_list[2]);
        }
        else
        {
          RuntimeError::raise("err!\n");
        }
        result_iseq->append(optimized_ins);
        continue;
      }
      result_iseq->append(orig_ins->duplicate());
    }
    else
    {
      result_iseq->append(orig_ins->duplicate());
    }
  }
  reset_local_state();
  return result_iseq;
}

Vreg LVNOptimizationHighLevel::lookup_vreg_by_LVNKey(const struct LVNKey &key)
{
  ValueNumber vn = lookup_vn_by_LVNKey(key);
  if (vn == -1)
  {
    return -1;
  }
  Vreg vreg = lookup_min_vreg_by_vn(vn);
  if (vn == -1)
  {
    return -1;
  }
  return vreg;
}
/*
   Lookup virtual register by value number, if found return the Value number object,
   Else, return -1
*/
ValueNumber LVNOptimizationHighLevel::lookup_vn_by_operand(const Operand &opd)
{
  Operand::Kind opd_kind = opd.get_kind();
  if (opd_kind == Operand::VREG)
  {
    return lookup_vn_by_vreg(opd.get_base_reg());
  }
  else if (opd_kind == Operand::IMM_IVAL)
  {
    return lookup_vn_by_const(opd.get_imm_ival());
  }
  else if (opd_kind == Operand::VREG_MEM)
  {
    return -1;
  }
  else if (opd_kind == Operand::IMM_LABEL)
  {
    return -1;
  }
  else if (opd_kind == Operand::LABEL)
  {
    return -1;
  }
  else
  {
    RuntimeError::raise("Unprocessed Operand!");
  }
}
ValueNumber LVNOptimizationHighLevel::emit_vn_by_operand(const Operand &opd)
{
  Operand::Kind opd_kind = opd.get_kind();
  if (opd_kind == Operand::VREG)
  {
    return emit_vn_by_vreg(opd.get_base_reg());
  }
  else if (opd_kind == Operand::IMM_IVAL)
  {
    return emit_vn_by_const(opd.get_imm_ival());
  }
  else if (opd_kind == Operand::VREG_MEM)
  {
    return emit_value_number();
  }
  else if (opd_kind == Operand::IMM_LABEL)
  {
    return emit_value_number();
  }
  else if (opd_kind == Operand::LABEL)
  {
    return emit_value_number();
  }
  else
  {
    RuntimeError::raise("Unprocessed Operand!");
  }
}
void LVNOptimizationHighLevel::assign_vn_by_vreg(Vreg vreg, ValueNumber vn)
{
  // insert order is important!!!!!
  ValueNumber old_vn = lookup_vn_by_vreg(vreg);
  // if destructive assignment
  if (old_vn != -1 && old_vn != vn)
  {
    m_vn_to_vregs[old_vn].remove(vreg);
    // still need a step, when a LVNkey is matched to a value number which
    //  no longer virtual registers have, then set the value number of destination
    // operand to the value of that key
  }
  m_vreg_to_vn[vreg] = vn;
  auto it = std::find(m_vn_to_vregs[vn].begin(), m_vn_to_vregs[vn].end(), vreg);
  if (it == m_vn_to_vregs[vn].end())
  {
    m_vn_to_vregs[vn].push_back(vreg);
  }
}

void LVNOptimizationHighLevel::assign_vn_by_operand(Operand opd, ValueNumber vn)
{
  Operand::Kind opd_kind = opd.get_kind();
  if (opd_kind == Operand::VREG)
  {
    // Here, consider destructive assignment
    assign_vn_by_vreg(opd.get_base_reg(), vn);
  }
  else if (opd_kind == Operand::VREG_MEM)
  {
    // for move operation applied on a memory reference, just ignore it
    // cause we can not keep track of the value in the memory
    ;
  }
  else
  {
    RuntimeError::raise("Unprocessed Operand!");
  }
}

void LVNOptimizationHighLevel::load_value_numbers(const Instruction *ins)
{
  int opd_num = ins->get_num_operands();
  for (int i = 1; i < opd_num; i++)
  {
    Operand opd = ins->get_operand(i);
    ValueNumber vn = lookup_vn_by_operand(opd);
    if (vn == -1)
    {
      vn = emit_vn_by_operand(opd);
    }
  }
  Operand opd = ins->get_operand(0);
  ValueNumber vn = lookup_vn_by_operand(opd);
  if (vn == -1)
  {
    vn = emit_vn_by_operand(opd);
  }
}

struct LVNKey LVNOptimizationHighLevel::get_LVN_key(const Instruction *ins)
{
  int opcode = ins->get_opcode();
  int opd_num = ins->get_num_operands();
  if (opd_num == 2)
  {
    ValueNumber src_vn = lookup_vn_by_operand(ins->get_operand(1));
    return LVNKey(opcode, src_vn, -2);
  }
  else if (opd_num == 3)
  {
    ValueNumber src_vn1 = lookup_vn_by_operand(ins->get_operand(1));
    ValueNumber src_vn2 = lookup_vn_by_operand(ins->get_operand(2));
    if (src_vn1 > src_vn2)
    {
      return LVNKey(opcode, src_vn2, src_vn1);
    }
    else
    {
      return LVNKey(opcode, src_vn1, src_vn2);
    }
  }
}

HighLevelOpcode LVNOptimizationHighLevel::get_mov_opcode(int opcode)
{
  HighLevelOpcode hl_opcode = HighLevelOpcode(opcode);
  int size = highlevel_opcode_get_dest_operand_size(hl_opcode);
  switch (size)
  {
  case 1:
    return HighLevelOpcode::HINS_mov_b;
  case 2:
    return HighLevelOpcode::HINS_mov_w;
  case 4:
    return HighLevelOpcode::HINS_mov_l;
  case 8:
    return HighLevelOpcode::HINS_mov_q;
  default:
    RuntimeError::raise("Erorr!!!!");
  }
}

bool LVNOptimizationHighLevel::is_two_constant_computation(const Instruction *ins)
{
  if (ins->get_num_operands() != 3)
  {
    return false;
  }
  return is_const_by_opd(ins->get_operand(1)) && is_const_by_opd(ins->get_operand(2));
}

bool LVNOptimizationHighLevel::is_const_by_opd(const Operand &opd)
{
  Operand::Kind opd_kind = opd.get_kind();
  if (opd_kind == Operand::VREG)
  {
    return is_const_by_vn(lookup_vn_by_vreg(opd.get_base_reg()));
  }
  else if (opd_kind == Operand::IMM_IVAL)
  {
    return true;
  }
  else if (opd_kind == Operand::VREG_MEM)
  {
    return false;
  }
  else if (opd_kind == Operand::IMM_LABEL)
  {
    return false;
  }
  else if (opd_kind == Operand::LABEL)
  {
    return false;
  }
  else
  {
    RuntimeError::raise("Unprocessed Operand!");
  }
}
bool LVNOptimizationHighLevel::is_const_by_vn(const ValueNumber &vn)
{
  auto it = m_vn_to_const.find(vn);

  if (it != m_vn_to_const.end())
  {
    return true;
  }
  else
  {
    return false;
  }
}
ConstantValue LVNOptimizationHighLevel::lookup_const_by_opd(const Operand &opd)
{
  Operand::Kind opd_kind = opd.get_kind();
  if (opd_kind == Operand::VREG)
  {
    return lookup_const_by_vn(lookup_vn_by_vreg(opd.get_base_reg()));
  }
  else if (opd_kind == Operand::IMM_IVAL)
  {
    return opd.get_imm_ival();
  }
  else if (opd_kind == Operand::VREG_MEM)
  {
    return -1;
  }
  else if (opd_kind == Operand::IMM_LABEL)
  {
    return -1;
  }
  else
  {
    RuntimeError::raise("Unprocessed Operand!");
  }
}

long LVNOptimizationHighLevel::constant_folding_computation(const Instruction *ins)
{
  if (ins->get_num_operands() == 3)
  {
    long val1 = lookup_const_by_opd(ins->get_operand(1));
    long val2 = lookup_const_by_opd(ins->get_operand(2));
    int opcode = ins->get_opcode();
    if (match_opcode(opcode, HINS_add_b))
    {
      return val1 + val2;
    }
    else if (match_opcode(opcode, HINS_sub_b))
    {
      return val1 - val2;
    }
    else if (match_opcode(opcode, HINS_div_b))
    {
      return val1 / val2;
    }
    else if (match_opcode(opcode, HINS_mul_b))
    {
      return val1 * val2;
    }
    else if (match_opcode(opcode, HINS_and_b))
    {
      return val1 && val2;
    }
    else if (match_opcode(opcode, HINS_mod_b))
    {
      return val1 % val2;
    }
    else if (match_opcode(opcode, HINS_or_b))
    {
      return val1 || val2;
    }
    else if (match_opcode(opcode, HINS_cmpeq_b))
    {
      return val1 == val2;
    }
    else if (match_opcode(opcode, HINS_cmpgt_b))
    {
      return val1 > val2;
    }
    else if (match_opcode(opcode, HINS_cmpgte_b))
    {
      return val1 >= val2;
    }
    else if (match_opcode(opcode, HINS_cmplt_b))
    {
      return val1 < val2;
    }
    else if (match_opcode(opcode, HINS_cmplte_b))
    {
      return val1 <= val2;
    }
    else if (match_opcode(opcode, HINS_cmpneq_b))
    {
      return val1 != val2;
    }
    else
    {
      RuntimeError::raise("Ignored computation type: %d!\n", opcode);
    }
  }
  else if (ins->get_num_operands() == 2)
  {
    long val1 = lookup_const_by_opd(ins->get_operand(1));
    int opcode = ins->get_opcode();
    if (match_opcode(opcode, HINS_neg_b))
    {
      return val1 * -1;
    }
    else
    {
      RuntimeError::raise("Ignored computation type: %d!\n", opcode);
    }
  }
}

////////////////////////////////////////////////////////////////////////
// Dead Store Elimination implementation                              //
////////////////////////////////////////////////////////////////////////
DeadStoreElimination::DeadStoreElimination(const std::shared_ptr<ControlFlowGraph> &cfg)
    : ControlFlowGraphTransform(cfg), m_live_vregs(cfg)
{
  m_live_vregs.execute();
}

DeadStoreElimination::~DeadStoreElimination()
{
}

std::shared_ptr<InstructionSequence>
DeadStoreElimination::transform_basic_block(const InstructionSequence *orig_bb)
{
  // LiveVregs needs a pointer to a BasicBlock object to get a dataflow
  // fact for that basic block
  const BasicBlock *orig_bb_as_basic_block =
      static_cast<const BasicBlock *>(orig_bb);

  std::shared_ptr<InstructionSequence> result_iseq(new InstructionSequence());

  for (auto i = orig_bb->cbegin(); i != orig_bb->cend(); ++i)
  {
    Instruction *orig_ins = *i;
    bool preserve_instruction = true;

    if (HighLevel::is_def(orig_ins))
    {
      Operand dest = orig_ins->get_operand(0);

      LiveVregs::FactType live_after =
          m_live_vregs.get_fact_after_instruction(orig_bb_as_basic_block, orig_ins);

      // after the vr0-vr9
      if (!live_after.test(dest.get_base_reg()) && dest.get_base_reg() > 9)
        // destination register is dead immediately after this instruction,
        // so it can be eliminated
        preserve_instruction = false;

      // tease duplicated mov out
      if (match_opcode(orig_ins->get_opcode(), HINS_mov_b))
      {
        Operand src = orig_ins->get_operand(1);
        if (dest.get_kind() == Operand::VREG && src.get_kind() == Operand::VREG)
        {
          if (dest.get_base_reg() == src.get_base_reg())
            // preserve_instruction = false;
            ;
        }
      }
    }

    if (preserve_instruction)
      result_iseq->append(orig_ins->duplicate());
  }

  return result_iseq;
}