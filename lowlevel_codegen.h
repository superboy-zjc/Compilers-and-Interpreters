#ifndef LOWLEVEL_CODEGEN_H
#define LOWLEVEL_CODEGEN_H

#include <memory>
#include "operand.h"
#include "instruction.h"
#include "instruction_seq.h"

// A LowLevelCodeGen object transforms an InstructionSequence containing
// high-level instructions into an InstructionSequence containing
// low-level (x86-64) instructions.
struct storage_info
{
  unsigned allocated_memory;
  unsigned tlast_allocated_vr;
  unsigned total_memory;
};

class LowLevelCodeGen
{
private:
  int m_total_memory_storage;
  bool m_optimize;
  struct storage_info m_storage_base;
  unsigned lst_ins_size;

public:
  LowLevelCodeGen(bool optimize);
  virtual ~LowLevelCodeGen();

  std::shared_ptr<InstructionSequence> generate(const std::shared_ptr<InstructionSequence> &hl_iseq);

private:
  std::shared_ptr<InstructionSequence> translate_hl_to_ll(const std::shared_ptr<InstructionSequence> &hl_iseq);
  void translate_instruction(Instruction *hl_ins, const std::shared_ptr<InstructionSequence> &ll_iseq);
  Operand get_ll_operand(Operand hl_operand, int size, const std::shared_ptr<InstructionSequence> &ll_iseq);
  // assign04
  unsigned int get_total_memory_storage();
  void set_storage_base(struct storage_info storage_base)
  {
    m_storage_base = storage_base;
  }
  void set_total_storage(unsigned total_storage)
  {
    m_storage_base.total_memory = total_storage;
  }
  void init_storage_base(Node *funcdef_ast);
  Operand operand_hl_ll(Operand hl_opd, int size);
  int get_offset(Operand opd);
  void emit_mov_hl_ll(int size, Operand src_operand, Operand dest_operand, const std::shared_ptr<InstructionSequence> &ll_iseq);
  Operand mov_to_temp(Operand opd, int size, const std::shared_ptr<InstructionSequence> &ll_iseq);
  Operand mov_to_temp(Operand opd, int size, unsigned vr, const std::shared_ptr<InstructionSequence> &ll_iseq);
  Operand emit_movzb_hl_ll(int size, Operand opd, unsigned vr_idx, const std::shared_ptr<InstructionSequence> &ll_iseq);
  // Operand emit_mov_promotion_hl_ll(LowLevelOpcode ll_opcode, int dst_size, Operand opd, unsigned vr_idx, const std::shared_ptr<InstructionSequence> &ll_iseq);
  Operand emit_set_hl_ll(HighLevelOpcode hl_opcode, Operand src_operand, const std::shared_ptr<InstructionSequence> &ll_iseq);
  unsigned get_last_opcode_size(Instruction *ins);
  /* for add comments */
  void add_comment(Instruction *hl_ins, const std::shared_ptr<InstructionSequence> &ll_iseq, unsigned idx);
  void print_uncompleted(Instruction *hl_ins, const std::shared_ptr<InstructionSequence> &ll_iseq);
};

#endif // LOWLEVEL_CODEGEN_H
