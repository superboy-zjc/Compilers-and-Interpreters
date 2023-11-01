#include <cassert>
#include "node.h"
#include "instruction.h"
#include "highlevel.h"
#include "ast.h"
#include "parse.tab.h"
#include "grammar_symbols.h"
#include "exceptions.h"
#include "local_storage_allocation.h"
#include "highlevel_codegen.h"

// Adjust an opcode for a basic type
HighLevelOpcode get_opcode(HighLevelOpcode base_opcode, const std::shared_ptr<Type> &type)
{
  if (type->is_basic())
    return static_cast<HighLevelOpcode>(int(base_opcode) + int(type->get_basic_type_kind()));
  else if (type->is_pointer())
    return static_cast<HighLevelOpcode>(int(base_opcode) + int(BasicTypeKind::LONG));
  else
    RuntimeError::raise("attempt to use type '%s' as data in opcode selection", type->as_str().c_str());
}

HighLevelCodegen::HighLevelCodegen(int next_label_num, bool optimize)
    : m_next_label_num(next_label_num), m_optimize(optimize), m_hl_iseq(new InstructionSequence())
{
}

HighLevelCodegen::~HighLevelCodegen()
{
}

void HighLevelCodegen::visit_function_definition(Node *n)
{
  // generate the name of the label that return instructions should target
  std::string fn_name = n->get_kid(1)->get_str();
  m_return_label_name = ".L" + fn_name + "_return";

  // get total storage size of the function block
  unsigned total_local_storage = n->get_memory_storage_size();
  set_cur_vreg(n->get_cur_vreg());

  m_hl_iseq->append(new Instruction(HINS_enter, Operand(Operand::IMM_IVAL, total_local_storage)));

  // visit body
  visit(n->get_kid(3));
  // return label statement
  m_hl_iseq->append(new Instruction(HINS_jmp, Operand(Operand::LABEL, m_return_label_name)));

  m_hl_iseq->define_label(m_return_label_name);
  m_hl_iseq->append(new Instruction(HINS_leave, Operand(Operand::IMM_IVAL, total_local_storage)));
  m_hl_iseq->append(new Instruction(HINS_ret));

  // Perform high-level optimizations?
  if (m_optimize)
  {
  }
}

void HighLevelCodegen::visit_statement_list(Node *n)
{
  // TODO: implement
  // temperoray virtual registers
  // struct vreg saved_vreg = get_cur_vreg();
  visit_children(n);
  // recover virtual registers
  // set_cur_vreg(saved_vreg);
}

void HighLevelCodegen::visit_expression_statement(Node *n)
{
  visit_children(n);
  // TODO: implement
  // for (auto i = n->cbegin(); i != n->cend(); ++i)
  // {
  //   Node *expression = *i;
  //   unsigned tag = expression->get_tag();
  //   if (tag == AST_BINARY_EXPRESSION)
  //   {
  //   }
  //   else if (tag == AST_UNARY_EXPRESSION)
  //   {
  //   }
  // }
}

void HighLevelCodegen::visit_return_statement(Node *n)
{
  // m_hl_iseq->append(new Instruction(HINS_jmp, Operand(Operand::LABEL, m_return_label_name)));
}

void HighLevelCodegen::visit_return_expression_statement(Node *n)
{

  // A possible implementation:

  Node *expr = n->get_kid(0);

  // generate code to evaluate the expression
  visit(expr);

  // move the computed value to the return value vreg
  HighLevelOpcode mov_opcode = get_opcode(HINS_mov_b, expr->get_type());
  m_hl_iseq->append(new Instruction(mov_opcode, Operand(Operand::VREG, LocalStorageAllocation::VREG_RETVAL), expr->get_operand()));

  // jump to the return label
  visit_return_statement(n);
}

void HighLevelCodegen::visit_while_statement(Node *n)
{
  // generate the name of the label that while loop condition should target
  std::string m_while_loop = ".L" + std::to_string(get_next_label_num());
  std::string m_while_condition = ".L" + std::to_string(get_next_label_num());
  // set_cur_loop_label_num(-2);
  // while condition statement
  m_hl_iseq->append(new Instruction(HINS_jmp, Operand(Operand::LABEL, m_while_condition)));
  // while loop
  m_hl_iseq->define_label(m_while_loop);
  visit(n->get_kid(1));
  // while condition
  m_hl_iseq->define_label(m_while_condition);
  visit(n->get_kid(0));
  // cjmp
  m_hl_iseq->append(new Instruction(HINS_cjmp_t, n->get_kid(0)->get_operand(), Operand(Operand::LABEL, m_while_loop)));
}

void HighLevelCodegen::visit_do_while_statement(Node *n)
{
  // generate the name of the label that while loop condition should target
  std::string m_do_while_loop = ".L" + std::to_string(get_next_label_num());
  // set_cur_loop_label_num(-1);
  //  while condition statement
  //  m_hl_iseq->append(new Instruction(HINS_jmp, Operand(Operand::LABEL, m_do_while_loop)));
  //  while loop
  m_hl_iseq->define_label(m_do_while_loop);
  visit(n->get_kid(0));
  // do condition
  visit(n->get_kid(1));
  // cjmp
  // std::string m_while_loop = ".L" + std::to_string(get_cur_loop_label_num());
  m_hl_iseq->append(new Instruction(HINS_cjmp_t, n->get_kid(1)->get_operand(), Operand(Operand::LABEL, m_do_while_loop)));
}

void HighLevelCodegen::visit_for_statement(Node *n)
{
  // for statement initialization
  visit(n->get_kid(0));
  // generate the name of the label that while loop condition should target
  std::string m_for_loop = ".L" + std::to_string(get_next_label_num());
  std::string m_for_condition = ".L" + std::to_string(get_next_label_num());
  set_cur_loop_label_num(-2);
  // for condition statement
  m_hl_iseq->append(new Instruction(HINS_jmp, Operand(Operand::LABEL, m_for_condition)));
  // for loop label
  m_hl_iseq->define_label(m_for_loop);
  // for body
  visit(n->get_kid(3));
  // for update
  visit(n->get_kid(2));
  // for condition label
  m_hl_iseq->define_label(m_for_condition);
  visit(n->get_kid(1));
}

void HighLevelCodegen::visit_if_statement(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void HighLevelCodegen::visit_if_else_statement(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void HighLevelCodegen::visit_binary_expression(Node *n)
{
  // TODO: implement
  // // temperoray virtual registers
  struct vreg saved_vreg = get_cur_vreg();
  // visit_children(n);
  Node *opd1_node = n->get_kid(1);
  Node *opd2_node = n->get_kid(2);
  visit(opd1_node);
  visit(opd2_node);
  Operand opd1 = opd1_node->get_operand();
  Operand opd2 = opd2_node->get_operand();

  Node *opt = n->get_kid(0);
  if (opt->get_tag() == TOK_ASSIGN)
  {
    // unsigned int vreg = get_next_local_vreg();
    //  Operand dest(Operand::VREG, vreg);
    //   get two operand

    // generate instructions, temporarily use opd1 as implicit converstions
    HighLevelOpcode opcode = get_opcode(HINS_mov_b, opd1_node->get_type());
    m_hl_iseq->append(new Instruction(opcode, opd1, opd2));
    n->set_operand(opd1);
  }
  else if (opt->get_tag() == TOK_PLUS || opt->get_tag() == TOK_MINUS || opt->get_tag() == TOK_ASTERISK || opt->get_tag() == TOK_LOGICAL_AND || opt->get_tag() == TOK_LOGICAL_OR)
  {
    unsigned int vreg = get_next_local_vreg();
    Operand dest(Operand::VREG, vreg);
    // get two operand

    // generate instructions, temporarily use opd1 as implicit converstions
    HighLevelOpcode opcode = get_opcode(HINS_add_b, opd1_node->get_type());
    m_hl_iseq->append(new Instruction(opcode, dest, opd1, opd2));
    n->set_operand(dest);
  }
  else if (opt->get_tag() == TOK_GTE || opt->get_tag() == TOK_GT || opt->get_tag() == TOK_LTE || opt->get_tag() == TOK_LT || opt->get_tag() == TOK_EQUALITY)
  {
    unsigned int vreg = get_next_local_vreg();
    HighLevelOpcode optcode;
    Operand dest(Operand::VREG, vreg);
    switch (opt->get_tag())
    {
    case TOK_GTE:
      optcode = HighLevelOpcode::HINS_cmpgte_b;
      break;
    case TOK_GT:
      optcode = HighLevelOpcode::HINS_cmpgt_b;
      break;
    case TOK_LTE:
      optcode = HighLevelOpcode::HINS_cmplte_b;
      break;
    case TOK_LT:
      optcode = HighLevelOpcode::HINS_cmplt_b;
      break;
    case TOK_EQUALITY:
      optcode = HighLevelOpcode::HINS_cmpeq_b;
      break;
    default:
      RuntimeError::raise("unkown unary operation");
      break;
    }
    // generate instructions, temporarily use opd1 as implicit converstions
    HighLevelOpcode opcode = get_opcode(optcode, opd1_node->get_type());
    // cmpXX_
    m_hl_iseq->append(new Instruction(opcode, dest, opd1, opd2));
    n->set_operand(dest);
  }
  // // recover virtual registers
  set_cur_vreg(saved_vreg);
}

void HighLevelCodegen::visit_unary_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void HighLevelCodegen::visit_function_call_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void HighLevelCodegen::visit_field_ref_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void HighLevelCodegen::visit_indirect_field_ref_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void HighLevelCodegen::visit_array_element_ref_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void HighLevelCodegen::visit_variable_ref(Node *n)
{
  // TODO: implement
  Symbol *cur_sym = n->get_symbol();
  unsigned int stor_loc = cur_sym->get_storage_location();
  if (cur_sym->get_storage_type() == StorageType::VREG)
  {
    Operand dest(Operand::VREG, stor_loc);
    n->set_operand(dest);
  }
  else if (cur_sym->get_storage_type() == StorageType::MEM)
  {
    // if lvalue, generate a sequence of instructions to compute the exact address of the referenced lvalue.
    if (n->if_lvalue())
    {
    }
  }
  else
  {
    RuntimeError::raise("unkown storage type");
  }
}

void HighLevelCodegen::visit_literal_value(Node *n)
{
  // A partial implementation (note that this won't work correctly
  // for string constants!):

  LiteralValue val = n->get_literal_value();
  if (n->get_kid(0)->get_tag() == TOK_INT_LIT)
  {
    unsigned int vreg = get_next_local_vreg();
    Operand dest(Operand::VREG, vreg);
    HighLevelOpcode mov_opcode = get_opcode(HINS_mov_b, n->get_type());
    m_hl_iseq->append(new Instruction(mov_opcode, dest, Operand(Operand::IMM_IVAL, val.get_int_value())));
    n->set_operand(dest);
  }
}

void HighLevelCodegen::visit_implicit_conversion(Node *n)
{
  // TODO: implement
  visit_children(n);
}

std::string HighLevelCodegen::next_label()
{
  std::string label = ".L" + std::to_string(m_next_label_num++);
  return label;
}

// TODO: additional private member functions

// void update_vreg_status(Symbol *sym) {

// }
