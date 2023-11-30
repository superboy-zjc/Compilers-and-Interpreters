#include <cassert>
#include "cfg.h"
#include "cfg_transform.h"
#include <map>
#include "highlevel.h"

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
  // LiveVregs needs a pointer to a BasicBlock object to get a dataflow
  // fact for that basic block
  // const BasicBlock *orig_bb_as_basic_block =
  //     static_cast<const BasicBlock *>(orig_bb);

  std::shared_ptr<InstructionSequence> result_iseq(new InstructionSequence());

  for (auto i = orig_bb->cbegin(); i != orig_bb->cend(); ++i)
  {
    Instruction *orig_ins = *i;
    ValueNumber dst;
    //  bool preserve_instruction = true;
    if (orig_ins->get_num_operands() == 2)
    {
      load_value_numbers(orig_ins);
      // if mov , don't need to eliminate computation
      if (orig_ins->get_opcode() >= HighLevelOpcode::HINS_mov_b && orig_ins->get_opcode() <= HighLevelOpcode::HINS_mov_q)
      {
        result_iseq->append(orig_ins->duplicate());
        continue;
      }
      dst = lookup_vn_by_operand(orig_ins->get_operand(0));
      struct LVNKey key = get_LVN_key(orig_ins);
      // value number has been recorded, but the destructive assignment clear the registers
      Vreg vreg = lookup_vreg_by_LVNKey(key);
      if (vreg != -1)
      {
        assign_vn_by_LVNKey(key, dst);
        result_iseq->append(orig_ins->duplicate());
        continue;
      }
      // eliminate the computation
      Instruction *optimized_ins = new Instruction(get_mov_opcode(orig_ins->get_opcode()), orig_ins->get_operand(0), vreg);
      result_iseq->append(optimized_ins);
    }
    else
    {
      result_iseq->append(orig_ins->duplicate());
    }

    // if (HighLevel::is_def(orig_ins))
    // {
    //   Operand dest = orig_ins->get_operand(0);

    //   LiveVregs::FactType live_after =
    //       m_live_vregs.get_fact_after_instruction(orig_bb_as_basic_block, orig_ins);

    //   if (!live_after.test(dest.get_base_reg()))
    //     // destination register is dead immediately after this instruction,
    //     // so it can be eliminated
    //     preserve_instruction = false;
    // }

    // if (preserve_instruction)
    //   result_iseq->append(orig_ins->duplicate());
  }

  return result_iseq;
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
  else
  {
    RuntimeError::raise("Unprocessed Operand!");
  }
}
void LVNOptimizationHighLevel::assign_vn_by_vreg(Vreg vreg, ValueNumber vn)
{

  ValueNumber old_vn = lookup_vn_by_vreg(vreg);
  // consider destructive assignment
  if (old_vn != -1)
  {
    m_vn_to_vregs[old_vn].erase(vreg);
    // still need a step, when a LVNkey is matched to a value number which
    //  no longer virtual registers have, then set the value number of destination
    // operand to the value of that key
  }

  m_vreg_to_vn[vreg] = vn;
  m_vn_to_vregs[vn].insert(vreg);
}

void LVNOptimizationHighLevel::assign_vn_by_operand(Operand opd, ValueNumber vn)
{
  Operand::Kind opd_kind = opd.get_kind();
  if (opd_kind == Operand::VREG)
  {
    // Here, consider destructive assignment
    assign_vn_by_vreg(opd.get_base_reg(), vn);
  }
  else
  {
    RuntimeError::raise("Unprocessed Operand!");
  }
}

void LVNOptimizationHighLevel::load_value_numbers(const Instruction *ins)
{
  int opd_num = ins->get_num_operands();
  if (opd_num == 2)
  {
    Operand src = ins->get_operand(1);
    ValueNumber src_vn = lookup_vn_by_operand(src);
    // there no value number related to the operand
    // assign a value number for the operand
    if (src_vn == -1)
    {
      src_vn = emit_vn_by_operand(src);
    }
    Operand dst = ins->get_operand(0);
    // if mov opcode
    if (ins->get_opcode() >= HighLevelOpcode::HINS_mov_b && ins->get_opcode() <= HighLevelOpcode::HINS_mov_q)
    {
      assign_vn_by_operand(dst, src_vn);
    }
    else
    {
      if (lookup_vn_by_operand(dst) == -1)
      {
        emit_vn_by_operand(dst);
      }
    }
  }
  else if (opd_num == 3)
  {
    // ValueNumber vn1 = get_value_number(ins->get_operand(1));
    // ValueNumber vn2 = get_value_number(ins->get_operand(2));
    // ValueNumber vn3 = get_value_number(ins->get_operand(0));
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
  }
}
