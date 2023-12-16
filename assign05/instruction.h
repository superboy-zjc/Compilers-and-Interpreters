#ifndef INSTRUCTION_H
#define INSTRUCTION_H

#include <string>
#include "symtab.h"
#include "operand.h"

// Instruction object type.
// Can be used for either high-level or low-level code.
class Instruction
{
private:
  int m_opcode;
  unsigned m_num_operands;
  Operand m_operands[3];
  std::string m_comment;
  Symbol *m_symbol;
  int m_opcode_size = -1;

public:
  Instruction(int opcode);
  Instruction(int opcode, const Operand &op1);
  Instruction(int opcode, const Operand &op1, const Operand &op2);
  Instruction(int opcode, const Operand &op1, const Operand &op2, const Operand &op3, unsigned num_operands = 3);

  ~Instruction();

  Instruction *duplicate() const { return new Instruction(*this); }

  int get_opcode() const;

  unsigned get_num_operands() const;

  const Operand &get_operand(unsigned index) const;

  void set_operand(unsigned index, const Operand &operand);

  Operand get_last_operand() const;

  void set_comment(const std::string &comment) { m_comment = comment; }
  bool has_comment() const { return !m_comment.empty(); }
  const std::string &get_comment() const { return m_comment; }

  void set_symbol(Symbol *sym) { m_symbol = sym; }
  Symbol *get_symbol() const { return m_symbol; }

  // assign04
  void set_opcode_size(unsigned size)
  {
    m_opcode_size = size;
  }
  unsigned get_opcode_size()
  {
    if (m_opcode_size == -1)
    {
      printf("error here!");
    }
    return m_opcode_size;
  }
};

#endif // INSTRUCTION_H
