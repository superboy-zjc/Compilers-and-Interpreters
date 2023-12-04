#include <stdexcept>
#include "cpputil.h"
#include "instruction.h"
#include "highlevel.h"
#include "highlevel_formatter.h"

// names of machine registers for the 8 bit, 16 bit,
// 32 bit, and 64 bit sizes
const char *mreg_operand_names[][4] = {
    {"al", "ax", "eax", "rax"},
    {"bl", "bx", "ebx", "rbx"},
    {"cl", "cx", "ecx", "rcx"},
    {"dl", "dx", "edx", "rdx"},
    {"sil", "si", "esi", "rsi"},
    {"dil", "di", "edi", "rdi"},
    {"spl", "sp", "esp", "rsp"},
    {"bpl", "bp", "ebp", "rbp"},
    {"r8b", "r8w", "r8d", "r8"},
    {"r9b", "r9w", "r9d", "r9"},
    {"r10b", "r10w", "r10d", "r10"},
    {"r11b", "r11w", "r11d", "r11"},
    {"r12b", "r12w", "r12d", "r12"},
    {"r13b", "r13w", "r13d", "r13"},
    {"r14b", "r14w", "r14d", "r14"},
    {"r15b", "r15w", "r15d", "r15"},
};

HighLevelFormatter::HighLevelFormatter()
{
}

HighLevelFormatter::~HighLevelFormatter()
{
}

std::string HighLevelFormatter::format_operand(const Operand &operand) const
{
  std::string s;

  switch (operand.get_kind())
  {
  case Operand::VREG:
    // assign05
    if (operand.get_machine_reg() != MREG_END)
      s = cpputil::format("vr%d<%%%s>", operand.get_base_reg(), mreg_operand_names[operand.get_machine_reg()][3]);
    else
      s = cpputil::format("vr%d", operand.get_base_reg());
    break;
  case Operand::VREG_MEM:
    if (operand.get_machine_reg() != MREG_END)
      s = cpputil::format("(vr%d<%%%s>)", operand.get_base_reg(), mreg_operand_names[operand.get_machine_reg()][3]);
    else
      s = cpputil::format("(vr%d)", operand.get_base_reg());
    break;
  case Operand::VREG_MEM_IDX:
    s = cpputil::format("(vr%d, vr%d)", operand.get_base_reg(), operand.get_index_reg());
    break;
  case Operand::VREG_MEM_OFF:
    s = cpputil::format("%ld(vr%d)", operand.get_imm_ival(), operand.get_base_reg());
    break;
  default:
    s = Formatter::format_operand(operand);
  }

  return s;
}

std::string HighLevelFormatter::format_instruction(const Instruction *ins) const
{
  HighLevelOpcode opcode = HighLevelOpcode(ins->get_opcode());

  const char *mnemonic_ptr = highlevel_opcode_to_str(opcode);
  if (mnemonic_ptr == nullptr)
  {
    std::string exmsg = cpputil::format("Unknown highlevel opcode: %d", ins->get_opcode());
    throw std::runtime_error(exmsg);
  }
  std::string mnemonic(mnemonic_ptr);

  std::string buf;

  buf += mnemonic;
  // pad mnemonics to 8 characters
  unsigned padding = (mnemonic.size() < 8U) ? 8U - mnemonic.size() : 0;
  buf += ("         " + (8U - padding));
  for (unsigned i = 0; i < ins->get_num_operands(); i++)
  {
    if (i > 0)
    {
      buf += ", ";
    }
    buf += format_operand(ins->get_operand(i));
  }

  return buf;
}
