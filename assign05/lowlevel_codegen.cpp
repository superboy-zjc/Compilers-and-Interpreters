#include <cassert>
#include <map>
#include "node.h"
#include "instruction.h"
#include "operand.h"
#include "local_storage_allocation.h"
#include "highlevel.h"
#include "lowlevel.h"
#include "lowlevel_formatter.h"
#include "exceptions.h"
#include "lowlevel_codegen.h"
#include "highlevel_formatter.h"
#include "cfg.h"
#include "cfg_transform.h"
#include <cassert>
#include "peephole_ll.h"

// This map has some "obvious" translations of high-level opcodes to
// low-level opcodes.
const std::map<HighLevelOpcode, LowLevelOpcode> HL_TO_LL = {
    {HINS_nop, MINS_NOP},
    {HINS_add_b, MINS_ADDB},
    {HINS_add_w, MINS_ADDW},
    {HINS_add_l, MINS_ADDL},
    {HINS_add_q, MINS_ADDQ},
    {HINS_sub_b, MINS_SUBB},
    {HINS_sub_w, MINS_SUBW},
    {HINS_sub_l, MINS_SUBL},
    {HINS_sub_q, MINS_SUBQ},
    {HINS_mul_l, MINS_IMULL},
    {HINS_mul_q, MINS_IMULQ},
    {HINS_div_l, MINS_IDIVL},
    {HINS_div_q, MINS_IDIVQ},
    {HINS_mod_l, MINS_IDIVL},
    {HINS_mod_q, MINS_IDIVQ},
    {HINS_mov_b, MINS_MOVB},
    {HINS_mov_w, MINS_MOVW},
    {HINS_mov_l, MINS_MOVL},
    {HINS_mov_q, MINS_MOVQ},
    {HINS_sconv_bw, MINS_MOVSBW},
    {HINS_sconv_bl, MINS_MOVSBL},
    {HINS_sconv_bq, MINS_MOVSBQ},
    {HINS_sconv_wl, MINS_MOVSWL},
    {HINS_sconv_wq, MINS_MOVSWQ},
    {HINS_sconv_lq, MINS_MOVSLQ},
    {HINS_uconv_bw, MINS_MOVZBW},
    {HINS_uconv_bl, MINS_MOVZBL},
    {HINS_uconv_bq, MINS_MOVZBQ},
    {HINS_uconv_wl, MINS_MOVZWL},
    {HINS_uconv_wq, MINS_MOVZWQ},
    {HINS_uconv_lq, MINS_MOVZLQ},
    {HINS_ret, MINS_RET},
    {HINS_jmp, MINS_JMP},
    {HINS_call, MINS_CALL},

    // For comparisons, it is expected that the code generator will first
    // generate a cmpb/cmpw/cmpl/cmpq instruction to compare the operands,
    // and then generate a setXX instruction to put the result of the
    // comparison into the destination operand. These entries indicate
    // the apprpropriate setXX instruction to use.
    {HINS_cmplt_b, MINS_SETL},
    {HINS_cmplt_w, MINS_SETL},
    {HINS_cmplt_l, MINS_SETL},
    {HINS_cmplt_q, MINS_SETL},
    {HINS_cmplte_b, MINS_SETLE},
    {HINS_cmplte_w, MINS_SETLE},
    {HINS_cmplte_l, MINS_SETLE},
    {HINS_cmplte_q, MINS_SETLE},
    {HINS_cmpgt_b, MINS_SETG},
    {HINS_cmpgt_w, MINS_SETG},
    {HINS_cmpgt_l, MINS_SETG},
    {HINS_cmpgt_q, MINS_SETG},
    {HINS_cmpgte_b, MINS_SETGE},
    {HINS_cmpgte_w, MINS_SETGE},
    {HINS_cmpgte_l, MINS_SETGE},
    {HINS_cmpgte_q, MINS_SETGE},
    {HINS_cmpeq_b, MINS_SETE},
    {HINS_cmpeq_w, MINS_SETE},
    {HINS_cmpeq_l, MINS_SETE},
    {HINS_cmpeq_q, MINS_SETE},
    {HINS_cmpneq_b, MINS_SETNE},
    {HINS_cmpneq_w, MINS_SETNE},
    {HINS_cmpneq_l, MINS_SETNE},
    {HINS_cmpneq_q, MINS_SETNE},
};

LowLevelCodeGen::LowLevelCodeGen(bool optimize)
    : m_total_memory_storage(0), m_optimize(optimize)
{
}

LowLevelCodeGen::~LowLevelCodeGen()
{
}

std::shared_ptr<InstructionSequence> LowLevelCodeGen::generate(const std::shared_ptr<InstructionSequence> &hl_iseq)
{
  Node *funcdef_ast = hl_iseq->get_funcdef_ast();
  // cur_hl_iseq is the "current" version of the high-level IR,
  // which could be a transformed version if we are doing optimizations
  std::shared_ptr<InstructionSequence> cur_hl_iseq(hl_iseq);
  if (m_optimize)
  {
    // High-level optiimizations

    // Create a control-flow graph representation of the high-level code
    HighLevelControlFlowGraphBuilder hl_cfg_builder(cur_hl_iseq);
    std::shared_ptr<ControlFlowGraph> cfg = hl_cfg_builder.build();

    // Convert thetransformed high-level CFG back to an InstructionSequence
    cur_hl_iseq = cfg->create_instruction_sequence();

    // The function definition AST might have information nedded for
    // low-level code generation
    cur_hl_iseq->set_funcdef_ast(funcdef_ast);
  }
  std::shared_ptr<InstructionSequence> ll_iseq = translate_hl_to_ll(cur_hl_iseq);

  // if optimizations are enabled, could do analysis/transformation of low-level code
  if (m_optimize)
  {
    // ...could do transformations on the low-level code, including peephole
    // optimizations
    LowLevelControlFlowGraphBuilder ll_cfg_builder(ll_iseq);
    std::shared_ptr<ControlFlowGraph> ll_cfg = ll_cfg_builder.build();

    bool done = false;
    while (!done)
    {
      PeepholeLowLevel peephole_ll(ll_cfg);
      ll_cfg = peephole_ll.transform_cfg();

      if (peephole_ll.get_num_matched() == 0)
        done = true;
    }
    ll_iseq = ll_cfg->create_instruction_sequence();
  }
  return ll_iseq;
}

std::shared_ptr<InstructionSequence> LowLevelCodeGen::translate_hl_to_ll(const std::shared_ptr<InstructionSequence> &hl_iseq)
{
  std::shared_ptr<InstructionSequence> ll_iseq(new InstructionSequence());

  // The high-level InstructionSequence will have a pointer to the Node
  // representing the function definition. Useful information could be stored
  // there (for example, about the amount of memory needed for local storage,
  // maximum number of virtual registers used, etc.)
  Node *funcdef_ast = hl_iseq->get_funcdef_ast();
  assert(funcdef_ast != nullptr);

  // It's not a bad idea to store the pointer to the function definition AST
  // in the low-level InstructionSequence as well, in case it's needed by
  // optimization passes.
  ll_iseq->set_funcdef_ast(funcdef_ast);

  // Determine the total number of bytes of memory storage
  // that the function needs. This should include both variables that
  // *must* have storage allocated in memory (e.g., arrays), and also
  // any additional memory that is needed for virtual registers,
  // spilled machine registers, etc.
  m_total_memory_storage = init_storage_base(funcdef_ast);

  // Iterate through high level instructions
  for (auto i = hl_iseq->cbegin(); i != hl_iseq->cend(); ++i)
  {
    Instruction *hl_ins = *i;

    // If the high-level instruction has a label, define an equivalent
    // label in the low-level instruction sequence
    if (i.has_label())
      ll_iseq->define_label(i.get_label());

    // Translate the high-level instruction into one or more low-level instructions
    translate_instruction(hl_ins, ll_iseq);
  }

  return ll_iseq;
}

// These helper functions are provided to make it easier to handle
// the way that instructions and operands vary based on operand size
// ('b'=1 byte, 'w'=2 bytes, 'l'=4 bytes, 'q'=8 bytes.)

// Check whether hl_opcode matches a range of opcodes, where base
// is a _b variant opcode. Return true if the hl opcode is any variant
// of that base.
bool match_hl(int base, int hl_opcode)
{
  return hl_opcode >= base && hl_opcode < (base + 4);
}

// For a low-level instruction with 4 size variants, return the correct
// variant. base_opcode should be the "b" variant, and operand_size
// should be the operand size in bytes (1, 2, 4, or 8.)
LowLevelOpcode select_ll_opcode(LowLevelOpcode base_opcode, int operand_size)
{
  int off;

  switch (operand_size)
  {
  case 1: // 'b' variant
    off = 0;
    break;
  case 2: // 'w' variant
    off = 1;
    break;
  case 4: // 'l' variant
    off = 2;
    break;
  case 8: // 'q' variant
    off = 3;
    break;
  default:
    assert(false);
    off = 3;
  }

  return LowLevelOpcode(int(base_opcode) + off);
}

// Get the correct Operand::Kind value for a machine register
// of the specified size (1, 2, 4, or 8 bytes.)
Operand::Kind select_mreg_kind(int operand_size)
{
  switch (operand_size)
  {
  case 1:
    return Operand::MREG8;
  case 2:
    return Operand::MREG16;
  case 4:
    return Operand::MREG32;
  case 8:
    return Operand::MREG64;
  default:
    assert(false);
    return Operand::MREG64;
  }
}

void LowLevelCodeGen::translate_instruction(Instruction *hl_ins, const std::shared_ptr<InstructionSequence> &ll_iseq)
{
  HighLevelOpcode hl_opcode = HighLevelOpcode(hl_ins->get_opcode());
  /* for set comments  */
  unsigned int first_instruct_idx = ll_iseq->get_length();

  if (hl_opcode == HINS_enter)
  {
    // Function prologue: this will create an ABI-compliant stack frame.
    // The local variable area is *below* the address in %rbp, and local storage
    // can be accessed at negative offsets from %rbp. For example, the topmost
    // 4 bytes in the local storage area are at -4(%rbp).
    ll_iseq->append(new Instruction(MINS_PUSHQ, Operand(Operand::MREG64, MREG_RBP)));
    ll_iseq->append(new Instruction(MINS_MOVQ, Operand(Operand::MREG64, MREG_RSP), Operand(Operand::MREG64, MREG_RBP)));
    if (m_total_memory_storage > 0)
      ll_iseq->append(new Instruction(MINS_SUBQ, Operand(Operand::IMM_IVAL, m_total_memory_storage), Operand(Operand::MREG64, MREG_RSP)));

    // if you allocated callee-saved registers as storage for local variables,
    //       emit pushq instructions to save their original values
    // save callee-saved registers (if any)
    const std::vector<LocalRegMatching>
        local_rank_list = ll_iseq->get_funcdef_ast()->get_local_rank_list();
    for (const auto &element : local_rank_list)
    {
      ll_iseq->append(new Instruction(MINS_PUSHQ, Operand(Operand::MREG64, element.reg)));
    }
    // aligned with 16 bytes
    const std::set<MachineReg> caller_saved = ll_iseq->get_funcdef_ast()->get_caller_save_list();
    if (m_optimize && (caller_saved.size() % 2) == 1)
    {
      ll_iseq->append(new Instruction(MINS_SUBQ, Operand(Operand::IMM_IVAL, 8), Operand(Operand::MREG64, MREG_RSP)));
    }

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode == HINS_leave)
  {
    // Function epilogue: deallocate local storage area and restore original value
    // of %rbp

    // if you allocated callee-saved registers as storage for local variables,
    //       emit popq instructions to save their original values
    const std::set<MachineReg> caller_saved = ll_iseq->get_funcdef_ast()->get_caller_save_list();
    // aligned with 16 bytes
    if ((caller_saved.size() % 2) == 1)
    {
      ll_iseq->append(new Instruction(MINS_ADDQ, Operand(Operand::IMM_IVAL, 8), Operand(Operand::MREG64, MREG_RSP)));
    }
    for (auto it = caller_saved.rbegin(); it != caller_saved.rend(); ++it)
    {
      const MachineReg &element = *it;
      ll_iseq->append(new Instruction(MINS_POPQ, Operand(Operand::MREG64, element)));
    }

    if (m_total_memory_storage > 0)
      ll_iseq->append(new Instruction(MINS_ADDQ, Operand(Operand::IMM_IVAL, m_total_memory_storage), Operand(Operand::MREG64, MREG_RSP)));
    ll_iseq->append(new Instruction(MINS_POPQ, Operand(Operand::MREG64, MREG_RBP)));

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode == HINS_ret)
  {
    ll_iseq->append(new Instruction(MINS_RET));

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  // handle other high-level instructions
  // Note that you can use the highlevel_opcode_get_source_operand_size() and
  // highlevel_opcode_get_dest_operand_size() functions to determine the
  // size (in bytes, 1, 2, 4, or 8) of either the source operands or
  // destination operand of a high-level instruction. This should be useful
  // for choosing the appropriate low-level instructions and
  // machine register operands.
  if (match_hl(HINS_mov_b, hl_opcode))
  {
    int size = highlevel_opcode_get_source_operand_size(hl_opcode);
    emit_mov_hl_ll(size, hl_ins->get_operand(1), hl_ins->get_operand(0), ll_iseq);

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (match_hl(HINS_add_b, hl_opcode) || match_hl(HINS_sub_b, hl_opcode))
  {
    int size = highlevel_opcode_get_source_operand_size(hl_opcode);

    LowLevelOpcode add_opcode = HL_TO_LL.at(hl_opcode);

    Operand src1_operand = get_ll_operand(hl_ins->get_operand(2), size, ll_iseq);
    Operand src2_operand = get_ll_operand(hl_ins->get_operand(1), size, ll_iseq);
    Operand dest_operand = get_ll_operand(hl_ins->get_operand(0), size, ll_iseq);

    src2_operand = emit_mov_to_temp(src2_operand, size, ll_iseq);

    ll_iseq->append(new Instruction(add_opcode, src1_operand, src2_operand));

    emit_mov_hl_ll(size, src2_operand, dest_operand, ll_iseq);

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (match_hl(HINS_mul_b, hl_opcode))
  {
    int size = highlevel_opcode_get_source_operand_size(hl_opcode);

    LowLevelOpcode mul_opcode = HL_TO_LL.at(hl_opcode);

    Operand src1_operand = get_ll_operand(hl_ins->get_operand(2), size, ll_iseq);
    Operand src2_operand = get_ll_operand(hl_ins->get_operand(1), size, ll_iseq);
    Operand dest_operand = get_ll_operand(hl_ins->get_operand(0), size, ll_iseq);

    // assign05, fix the bug! destructive assignment to operand 2 (which is destination)!!!
    // move source operand into a temporary register
    src2_operand = emit_mov_to_temp(src2_operand, size, ll_iseq);

    ll_iseq->append(new Instruction(mul_opcode, src1_operand, src2_operand));

    emit_mov_hl_ll(size, src2_operand, dest_operand, ll_iseq);

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (match_hl(HINS_div_b, hl_opcode) || match_hl(HINS_mod_b, hl_opcode))
  {
    int size = highlevel_opcode_get_source_operand_size(hl_opcode);

    Operand src1_operand = get_ll_operand(hl_ins->get_operand(2), size, ll_iseq);
    Operand src2_operand = get_ll_operand(hl_ins->get_operand(1), size, ll_iseq);
    Operand dest_operand = get_ll_operand(hl_ins->get_operand(0), size, ll_iseq);
    // movl     -32(%rbp), %eax     /* div_l    vr13, vr10, vr11 */
    src2_operand = emit_mov_hl_ll(size, src2_operand, Operand(select_mreg_kind(size), MREG_RAX), ll_iseq);
    // cdq
    ll_iseq->append(new Instruction(MINS_CDQ));
    // movl     -24(%rbp), %r10d
    src1_operand = emit_mov_to_temp(src1_operand, size, ll_iseq);
    // idivl    %r10d
    ll_iseq->append(new Instruction(HL_TO_LL.at(hl_opcode), src1_operand));

    if (match_hl(HINS_div_b, hl_opcode))
    {
      // movl     %eax, -8(%rbp)
      emit_mov_hl_ll(size, src2_operand, dest_operand, ll_iseq);
    }
    else
    {
      // movl     %edx, -8(%rbp)
      emit_mov_hl_ll(size, Operand(select_mreg_kind(size), MREG_RDX), dest_operand, ll_iseq);
    }

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode == HINS_jmp)
  {
    ll_iseq->append(new Instruction(MINS_JMP, hl_ins->get_operand(0)));

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode >= HINS_cmplt_b && hl_opcode <= HINS_cmpneq_q)
  {
    int size = highlevel_opcode_get_source_operand_size(hl_opcode);

    LowLevelOpcode cmp_opcode = select_ll_opcode(MINS_CMPB, size);

    Operand src1_operand = get_ll_operand(hl_ins->get_operand(2), size, ll_iseq);
    Operand src2_operand = get_ll_operand(hl_ins->get_operand(1), size, ll_iseq);
    Operand dest_operand = get_ll_operand(hl_ins->get_operand(0), size, ll_iseq);

    if (src1_operand.is_memref() && src2_operand.is_memref())
    {
      // move source operand into a temporary register
      src2_operand = emit_mov_to_temp(src2_operand, size, ll_iseq);
    }
    ll_iseq->append(new Instruction(cmp_opcode, src1_operand, src2_operand));

    src2_operand = emit_set_hl_ll(hl_opcode, src2_operand, ll_iseq);

    emit_mov_hl_ll(size, emit_movzb_hl_ll(size, src2_operand, 11, ll_iseq), dest_operand, ll_iseq);

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode == HINS_cjmp_t || hl_opcode == HINS_cjmp_f)
  {
    // int size = get_last_opcode_size(ll_iseq->get_last_instruction());
    //  highlevel_opcode_get_source_operand_size(hl_opcode);
    // LowLevelOpcode cmp_opcode = select_ll_opcode(MINS_CMPB, size);
    // **bug here**, we are not sure what size the operand is when operating the cmp instruction.
    LowLevelOpcode cmp_opcode = MINS_CMPL;
    Operand dst_operand = get_ll_operand(hl_ins->get_operand(0), 4, ll_iseq);
    // cmp $0, X(%rbp)
    ll_iseq->append(new Instruction(cmp_opcode, Operand(Operand::IMM_IVAL, 0), dst_operand));

    switch (hl_opcode)
    {
    case HINS_cjmp_t:
      ll_iseq->append(new Instruction(MINS_JNE, hl_ins->get_operand(1)));
      break;
    case HINS_cjmp_f:
      ll_iseq->append(new Instruction(MINS_JE, hl_ins->get_operand(1)));
      break;
    default:
      RuntimeError("Error!");
      break;
    }
    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode == HINS_call)
  {
    ll_iseq->append(new Instruction(MINS_CALL, hl_ins->get_operand(0)));
    // for peephole optimization
    ll_iseq->get_last_instruction()->set_symbol(hl_ins->get_symbol());
    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode >= HINS_sconv_bw && hl_opcode <= HINS_sconv_lq)
  {
    int src_size = highlevel_opcode_get_source_operand_size(hl_opcode);
    int dst_size = highlevel_opcode_get_dest_operand_size(hl_opcode);

    Operand src_operand = get_ll_operand(hl_ins->get_operand(1), src_size, ll_iseq);
    Operand dest_operand = get_ll_operand(hl_ins->get_operand(0), dst_size, ll_iseq);
    // movl X(%rbp), %r10X
    src_operand = emit_mov_to_temp(src_operand, src_size, ll_iseq);
    // movslq %r10X, %r10
    Operand tmp(select_mreg_kind(dst_size), src_operand.get_base_reg());
    ll_iseq->append(new Instruction(HL_TO_LL.at(hl_opcode), src_operand, tmp));
    // movq %r10, X(%rbp)
    emit_mov_hl_ll(dst_size, tmp, dest_operand, ll_iseq);

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode == HINS_localaddr)
  {
    int size = highlevel_opcode_get_source_operand_size(hl_opcode);

    Operand src_operand = get_ll_operand(hl_ins->get_operand(1), size, ll_iseq);
    Operand dest_operand = get_ll_operand(hl_ins->get_operand(0), size, ll_iseq);
    Operand tmp(Operand::MREG64, MREG_R10);
    // leaq -8(%rbp), %r10
    ll_iseq->append(new Instruction(MINS_LEAQ, get_lea_offset_operand(src_operand), tmp));
    // movq %r10, -72(%rbp)
    emit_mov_hl_ll(size, tmp, dest_operand, ll_iseq);

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }

  if (hl_opcode == HINS_spill_b)
  {
    return;
  }

  if (match_hl(HINS_neg_b, hl_opcode))
  {
    int size = highlevel_opcode_get_source_operand_size(hl_opcode);

    Operand src_operand = get_ll_operand(hl_ins->get_operand(1), size, ll_iseq);
    Operand dest_operand = get_ll_operand(hl_ins->get_operand(0), size, ll_iseq);
    // movl     -16(%rbp), %r10d    /* neg_l    vr12, vr11 */
    Operand tmp = emit_mov_to_temp(src_operand, size, ll_iseq);
    // movl     $0, -8(%rbp)
    emit_mov_hl_ll(size, Operand(Operand::IMM_IVAL, 0), dest_operand, ll_iseq);
    // subl     %r10d, -8(%rbp)
    ll_iseq->append(new Instruction(select_ll_opcode(MINS_SUBB, size), tmp, dest_operand));

    add_comment(hl_ins, ll_iseq, first_instruct_idx);
    return;
  }
  // if the translation doesn't cover certain opcode, then just NOP it
  print_uncompleted(hl_ins, ll_iseq);
}

/*
 Compute all the memory storage a function need for both virtual registers and memory storage.
*/
unsigned LowLevelCodeGen::init_storage_base(Node *funcdef_ast)
{
  struct storage_info storage_base;
  storage_base.allocated_memory = funcdef_ast->get_memory_storage_size();
  // assign05
  storage_base.allocated_vr_num = funcdef_ast->get_last_allocated_virtual_registers() - 10 + 1;

  if ((storage_base.allocated_memory) % 8 != 0)
    storage_base.allocated_memory += (8 - (storage_base.allocated_memory % 8));

  unsigned int virtual_register_allocated = 8 * storage_base.allocated_vr_num;
  unsigned vr_start_offset = storage_base.allocated_memory + virtual_register_allocated;
  storage_base.allocated_vr_start_offset = vr_start_offset;

  // The function prologue will push %rbp, which should guarantee that the
  // stack pointer (%rsp) will contain an address that is a multiple of 16.
  // If the total memory storage required is not a multiple of 16, add to
  // it so that it is.
  m_total_memory_storage = vr_start_offset;
  if ((m_total_memory_storage) % 16 != 0)
    m_total_memory_storage += (16 - (m_total_memory_storage % 16));

  set_storage_base(storage_base);
  return m_total_memory_storage;
}

Operand LowLevelCodeGen::get_ll_operand(Operand hl_operand, int size, const std::shared_ptr<InstructionSequence> &ll_iseq)
{
  Operand opd;

  switch (hl_operand.get_kind())
  {
  case Operand::VREG:
    opd = operand_hl_ll(hl_operand, size);
    break;
  case Operand::VREG_MEM:
  {
    opd = operand_hl_ll(hl_operand.memref_to(), 8);
    opd = emit_mov_to_temp(opd, 8, ll_iseq);
    opd = opd.to_memref();
    break;
  }
  case Operand::IMM_IVAL:
    opd = hl_operand;
    break;
  case Operand::LABEL:
    opd = hl_operand;
    break;
  default:
    opd = hl_operand;
    break;
  }
  return opd;
}

Operand LowLevelCodeGen::operand_hl_ll(Operand hl_opd, int size)
{
  unsigned vr_idx = hl_opd.get_base_reg();
  // assign05
  MachineReg mreg = hl_opd.get_machine_reg();
  Operand ll_opd;
  if (hl_opd.get_kind() == Operand::VREG)
  {
    if (vr_idx >= 10 && mreg == MREG_END)
    {
      ll_opd = Operand(Operand::MREG64_MEM_OFF, MREG_RBP, get_offset(hl_opd));
    }
    else if (vr_idx >= 10 && mreg != MREG_END)
    {
      ll_opd = Operand(select_mreg_kind(size), mreg);
    }
    switch (vr_idx)
    {
    case 0:
      ll_opd = Operand(select_mreg_kind(size), MREG_RAX);
      break;
    case 1:
      ll_opd = Operand(select_mreg_kind(size), MREG_RDI);
      break;
    case 2:
      ll_opd = Operand(select_mreg_kind(size), MREG_RSI);
      break;
    case 3:
      ll_opd = Operand(select_mreg_kind(size), MREG_RDX);
      break;
    case 4:
      ll_opd = Operand(select_mreg_kind(size), MREG_RCX);
      break;
    case 5:
      ll_opd = Operand(select_mreg_kind(size), MREG_R8);
      break;
    case 6:
      ll_opd = Operand(select_mreg_kind(size), MREG_R9);
      break;
    default:
      break;
    }
  }
  return ll_opd;
}
int LowLevelCodeGen::get_offset(Operand opd)
{
  if (opd.get_kind() == Operand::VREG)
  {
    return -1 * (m_storage_base.allocated_vr_start_offset - (opd.get_base_reg() - 10) * 8);
  }
  else
  {
    RuntimeError::raise("unkown operand kind");
  }
}
Operand LowLevelCodeGen::get_lea_offset_operand(Operand hl_opd)
{
  int localaddr_idx;
  int lea_idx;
  if (hl_opd.has_imm_ival())
  {
    localaddr_idx = hl_opd.get_imm_ival();
  }
  else
  {
    RuntimeError::raise("Invalid immediate value!");
  }
  lea_idx = -1 * (m_storage_base.allocated_memory - localaddr_idx);
  return Operand(Operand::MREG64_MEM_OFF, MREG_RBP, lea_idx);
}

void LowLevelCodeGen::add_comment(Instruction *hl_ins, const std::shared_ptr<InstructionSequence> &ll_iseq, unsigned idx)
{
  HighLevelFormatter formatter;
  std::string formatted_ins = formatter.format_instruction(hl_ins);
  ll_iseq->get_instruction(idx)->set_comment(formatted_ins);
}
void LowLevelCodeGen::print_uncompleted(Instruction *hl_ins, const std::shared_ptr<InstructionSequence> &ll_iseq)
{
  HighLevelFormatter formatter;
  std::string formatted_ins = formatter.format_instruction(hl_ins);
  Instruction *ins = new Instruction(MINS_NOP);
  ins->set_comment(formatted_ins);
  ll_iseq->append(ins);
}

Operand LowLevelCodeGen::emit_mov_hl_ll(int size, Operand src_operand, Operand dest_operand, const std::shared_ptr<InstructionSequence> &ll_iseq)
{
  LowLevelOpcode mov_opcode = select_ll_opcode(MINS_MOVB, size);

  Operand ll_src_operand = get_ll_operand(src_operand, size, ll_iseq);
  Operand ll_dest_operand = get_ll_operand(dest_operand, size, ll_iseq);

  if (ll_src_operand.is_memref() && ll_dest_operand.is_memref())
  {
    // move source operand into a temporary register
    ll_src_operand = emit_mov_to_temp(ll_src_operand, size, ll_iseq);
  }
  Instruction *inst = new Instruction(mov_opcode, ll_src_operand, ll_dest_operand);
  ll_iseq->append(inst);
  return ll_dest_operand;
}

Operand LowLevelCodeGen::emit_mov_to_temp(Operand opd, int size, const std::shared_ptr<InstructionSequence> &ll_iseq)
{
  LowLevelOpcode mov_opcode = select_ll_opcode(MINS_MOVB, size);

  Operand temp = get_next_tmp_register(size);
  ll_iseq->append(new Instruction(mov_opcode, opd, temp));

  return temp;
}

Operand LowLevelCodeGen::emit_movzb_hl_ll(int size, Operand opd, unsigned vr_idx, const std::shared_ptr<InstructionSequence> &ll_iseq)
{
  Operand::Kind mreg_kind = select_mreg_kind(size);
  LowLevelOpcode movzb_opcode;
  switch (size)
  {
  case 2:
    movzb_opcode = MINS_MOVZBW;
    break;
  case 4:
    movzb_opcode = MINS_MOVZBL;
    break;
  case 8:
    movzb_opcode = MINS_MOVZBQ;
    break;
  default:
    RuntimeError("error!");
    break;
  }
  Operand temp_vr;
  switch (vr_idx)
  {
  case 10:
    temp_vr = Operand(mreg_kind, MREG_R10);
    break;
  case 11:
    temp_vr = Operand(mreg_kind, MREG_R11);

  default:
    break;
  }
  ll_iseq->append(new Instruction(movzb_opcode, opd, temp_vr));

  return temp_vr;
}

Operand LowLevelCodeGen::emit_set_hl_ll(HighLevelOpcode hl_opcode, Operand src_operand, const std::shared_ptr<InstructionSequence> &ll_iseq)
{
  // convert a operand to a boolean length of operand

  // assign05
  Operand bool_opd = get_next_tmp_register(1);
  ll_iseq->append(new Instruction(HL_TO_LL.at(hl_opcode), bool_opd));
  return bool_opd;
}

Operand LowLevelCodeGen::get_next_tmp_register(int size)
{
  Operand cur_tmp(select_mreg_kind(size), m_cur_tmp_register);
  m_cur_tmp_register = (m_cur_tmp_register == MREG_R10) ? MREG_R11 : MREG_R10;
  return cur_tmp;
}