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

HighLevelOpcode TOK_TAG_TO_HH_CODE(unsigned tag)
{
  switch (tag)
  {
  case TOK_PLUS:
    return HighLevelOpcode::HINS_add_b;
  case TOK_ASSIGN:
    return HighLevelOpcode::HINS_mov_b;
  case TOK_MINUS:
    return HighLevelOpcode::HINS_sub_b;
  case TOK_ASTERISK:
    return HighLevelOpcode::HINS_mul_b;
  case TOK_DIVIDE:
    return HighLevelOpcode::HINS_div_b;
  case TOK_MOD:
    return HighLevelOpcode::HINS_mod_b;
  case TOK_LOGICAL_AND:
    return HighLevelOpcode::HINS_and_b;
  case TOK_LOGICAL_OR:
    return HighLevelOpcode::HINS_or_b;
  case TOK_GTE:
    return HighLevelOpcode::HINS_cmpgte_b;
  case TOK_GT:
    return HighLevelOpcode::HINS_cmpgt_b;
  case TOK_LTE:
    return HighLevelOpcode::HINS_cmplte_b;
  case TOK_LT:
    return HighLevelOpcode::HINS_cmplt_b;
  case TOK_EQUALITY:
    return HighLevelOpcode::HINS_cmpeq_b;

  default:
    RuntimeError::raise("unkown binary operation");
    return HighLevelOpcode::HINS_nop;
  }
}
bool IS_OPERATOR_EXCEPT_ASSIGNMENT(unsigned tag)
{
  switch (tag)
  {
  case TOK_PLUS:
  case TOK_MINUS:
  case TOK_ASTERISK:
  case TOK_DIVIDE:
  case TOK_MOD:
    // relational opt
  case TOK_LT:
  case TOK_LTE:
  case TOK_GT:
  case TOK_GTE:
  case TOK_EQUALITY:
  case TOK_INEQUALITY:
    // logical opt
  case TOK_LOGICAL_AND:
  case TOK_LOGICAL_OR:
    return true;
    break;
  default:
    return false;
    break;
  }
}

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

HighLevelOpcode get_promotion_opcode(const std::shared_ptr<Type> &base_type, const std::shared_ptr<Type> &promoted_type)
{
  HighLevelOpcode signed_conversion_array[3][4] =
      {{HINS_nop, HINS_sconv_bw, HINS_sconv_bl, HINS_sconv_bq},
       {HINS_nop, HINS_nop, HINS_sconv_wl, HINS_sconv_wq},
       {HINS_nop, HINS_nop, HINS_nop, HINS_sconv_lq}};
  HighLevelOpcode unsigned_conversion_array[3][4] =
      {{HINS_nop, HINS_uconv_bw, HINS_uconv_bl, HINS_uconv_bq},
       {HINS_nop, HINS_nop, HINS_uconv_wl, HINS_uconv_wq},
       {HINS_nop, HINS_nop, HINS_nop, HINS_uconv_lq}};

  int base_idx, promoted_idx;
  if (!base_type->is_basic() && !promoted_type->is_basic())
  {
    RuntimeError::raise("Invalid attempt to covert type '%s' into type '%s' ", base_type->as_str().c_str(), promoted_type->as_str().c_str());
  }
  base_idx = int(base_type->get_basic_type_kind());
  promoted_idx = int(promoted_type->get_basic_type_kind());
  if (base_idx >= 3 || promoted_idx >= 4)
  {
    RuntimeError::raise("Invalid conversion attempt!");
  }
  if (!promoted_type->is_signed())
  {
    return unsigned_conversion_array[base_idx][promoted_idx];
  }
  return signed_conversion_array[base_idx][promoted_idx];
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

  // enter
  m_hl_iseq->append(new Instruction(HINS_enter, Operand(Operand::IMM_IVAL, total_local_storage)));

  // assign arguments to virtual register
  Node *arg_list = n->get_kid(2);
  mov_args_to_vrs(arg_list);
  // visit body
  visit(n->get_kid(3));
  // return label statement
  m_hl_iseq->append(new Instruction(HINS_jmp, Operand(Operand::LABEL, m_return_label_name)));

  m_hl_iseq->define_label(m_return_label_name);
  m_hl_iseq->append(new Instruction(HINS_leave, Operand(Operand::IMM_IVAL, total_local_storage)));
  m_hl_iseq->append(new Instruction(HINS_ret));

  // assign04-2 save the virtual register status for low level code gen
  n->set_cur_vreg(get_cur_vreg());
  // Perform high-level optimizations?
  if (m_optimize)
  {
  }
}

void HighLevelCodegen::visit_statement_list(Node *n)
{
  // TODO: implement

  for (auto i = n->cbegin(); i != n->cend(); ++i)
  {
    Node *statement = *i;

    //  temperoray virtual registers
    // struct vreg saved_vreg = get_cur_vreg();
    visit(statement);
    // recover virtual registers
    // set_cur_vreg(saved_vreg);
  }
}

void HighLevelCodegen::visit_expression_statement(Node *n)
{
  visit_children(n);
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
  // skip virtual register reset
  // visit_children(n->get_kid(1));
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
  // set_cur_loop_label_num(-2);
  //  for condition statement
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
  // cjmp
  m_hl_iseq->append(new Instruction(HINS_cjmp_t, n->get_kid(1)->get_operand(), Operand(Operand::LABEL, m_for_loop)));
}

void HighLevelCodegen::visit_if_statement(Node *n)
{
  // generate the name of the label that if loop condition should target
  std::string m_if_loop = ".L" + std::to_string(get_next_label_num());
  std::string m_if_condition = ".L" + std::to_string(get_next_label_num());
  visit(n->get_kid(0));
  // cjmp if false
  m_hl_iseq->append(new Instruction(HINS_cjmp_f, n->get_kid(0)->get_operand(), Operand(Operand::LABEL, m_if_loop)));
  // if condition statement
  visit(n->get_kid(1));
  // if false
  m_hl_iseq->define_label(m_if_loop);
}

void HighLevelCodegen::visit_if_else_statement(Node *n)
{
  // generate the name of the label that while loop condition should target
  std::string m_rest_stats = ".L" + std::to_string(get_next_label_num());
  std::string m_if_false = ".L" + std::to_string(get_next_label_num());

  // if condition statement
  visit(n->get_kid(0));
  m_hl_iseq->append(new Instruction(HINS_cjmp_f, n->get_kid(0)->get_operand(), Operand(Operand::LABEL, m_if_false)));
  // if true statement
  visit(n->get_kid(1));
  m_hl_iseq->append(new Instruction(HINS_jmp, Operand(Operand::LABEL, m_rest_stats)));
  // if false
  m_hl_iseq->define_label(m_if_false);
  visit(n->get_kid(2));
  // for rest statements
  m_hl_iseq->define_label(m_rest_stats);
}

void HighLevelCodegen::visit_binary_expression(Node *n)
{
  // temperoray virtual registers
  // struct vreg saved_vreg = get_cur_vreg();
  // visit_children(n);
  Node *opt = n->get_kid(0);
  Node *opd1_node = n->get_kid(1);
  Node *opd2_node = n->get_kid(2);
  std::shared_ptr<Type> opd1_type = opd1_node->get_type();
  std::shared_ptr<Type> opd2_type = opd2_node->get_type();
  visit(opd1_node);
  visit(opd2_node);
  Operand opd1 = opd1_node->get_operand();
  Operand opd2 = opd2_node->get_operand();

  HighLevelOpcode optcode = TOK_TAG_TO_HH_CODE(opt->get_tag());

  if (opt->get_tag() == TOK_ASSIGN)
  {
    // generate instructions, temporarily use opd1 as implicit converstions
    n->set_operand(emit_basic_opt(optcode, opd1, opd2, opd1_type));
  }
  else if (IS_OPERATOR_EXCEPT_ASSIGNMENT(opt->get_tag()))
  {
    // pointer arithmetic
    // point + 4
    if ((opd1_node->get_type()->is_array() || opd1_node->get_type()->is_pointer()) && opd2_node->get_type()->is_integral())
    {
      // memref of pointer arithmetic computation
      Operand tmp_dst(Operand::VREG, get_next_local_vreg());
      Operand memref = emit_pointer_arithmetric(opd1, opd2, opd1_type->get_base_type(), opd2_type);
      std::shared_ptr<Type> src_type = opd1_type->get_base_type();

      tmp_dst = emit_basic_opt(HINS_mov_b, tmp_dst, memref, src_type);
      if (!n->if_lvalue())
      {
        n->set_operand(tmp_dst);
      }
      else
      {
        n->set_operand(tmp_dst.memref_to());
      }
    }
    // normal situations
    else
    {
      Operand tmp_dst(Operand::VREG, get_next_local_vreg());
      std::shared_ptr<Type> src_type = n->get_type();

      // generate instructions, temporarily use opd1 as implicit converstions
      n->set_operand(emit_basic_opt(optcode, tmp_dst, opd1, opd2, src_type));
    }
  }
  else if (opt->get_tag() == TOK_GTE || opt->get_tag() == TOK_GT || opt->get_tag() == TOK_LTE || opt->get_tag() == TOK_LT || opt->get_tag() == TOK_EQUALITY)
  {
    // cmpXX_
    // generate instructions, temporarily use opd1 as implicit converstions
    Operand tmp_dst(Operand::VREG, get_next_local_vreg());
    n->set_operand(emit_basic_opt(optcode, tmp_dst, opd1, opd2, opd1_type));
  }
  // // recover virtual registers
  // set_cur_vreg(saved_vreg);
}

void HighLevelCodegen::visit_unary_expression(Node *n)
{
  // // TODO: implement
  Node *opd_node = n->get_kid(1);
  visit(n->get_kid(1));
  std::shared_ptr<Type> opd_type = opd_node->get_type();
  //  debug
  Operand opd = opd_node->get_operand();

  Node *opt = n->get_kid(0);
  // // - ! ~
  // if (opt->get_tag() == TOK_MINUS || opt->get_tag() == TOK_BITWISE_COMPL || opt->get_tag() == TOK_NOT)
  // {
  //   if (opd->is_integral())
  //   {
  //     if (opd->is_long())
  //     {
  //       res = opd;
  //     }
  //     else if (opd->get_basic_type_kind() < BasicTypeKind::INT)
  //     {
  //       // representing implicit
  //       n->set_kid(1, opd_node = promote_to_int(opd_node));

  //       res = std::make_shared<BasicType>(BasicTypeKind::INT, opd->is_signed());
  //     }
  //     n->set_lvalue(false);
  //   }
  //   else
  //   {
  //     SemanticError::raise(n->get_loc(), "error: improper usage of unary experssion");
  //   }
  // }

  if (opt->get_tag() == TOK_MINUS)
  {
    if (opd.is_memref())
    {
      opd = emit_basic_opt(HINS_mov_b, alloc_tmp_vreg(), opd, opd_type);
    }
    n->set_operand(emit_basic_opt(HINS_neg_b, alloc_tmp_vreg(), opd, opd_type));
  }
  // &
  else if (opt->get_tag() == TOK_AMPERSAND)
  {
    n->set_operand(opd.memref_to());
  }
  // *
  else if (opt->get_tag() == TOK_ASTERISK)
  {
    if (opd.is_memref())
    {
      Operand tmp_opt(Operand::VREG, get_next_local_vreg());
      // if opd is already a memref, move to a new register, and ref it
      m_hl_iseq->append(new Instruction(HINS_mov_q, tmp_opt, opd));

      // n->set_operand(emit_basic_opt(HINS_mov_q, tmp_opt, opd, src_type));
      n->set_operand(tmp_opt.to_memref());
    }
    else
    {
      n->set_operand(opd.to_memref());
    }
  }
}

void HighLevelCodegen::visit_function_call_expression(Node *n)
{
  std::string func_name = n->get_kid(0)->get_kid(0)->get_str();
  std::shared_ptr<Type> func_type = n->get_kid(0)->get_type();
  HighLevelOpcode mov_opcode;

  // vrg0 ret operand
  Operand ret_opd = Operand(Operand::VREG, LocalStorageAllocation::VREG_RETVAL);

  visit(n->get_kid(1));
  // assign arguments to virtual register

  // save registers before call function
  struct vreg saved_vreg = get_cur_vreg();

  int loop_counter = 0;
  for (auto i = n->get_kid(1)->cbegin(); i != n->get_kid(1)->cend(); ++i)
  {
    Node *func_parameter = *i;

    unsigned int arg_vreg = get_next_arg_vreg();
    Operand param_opd = func_parameter->get_operand();
    std::shared_ptr<Type> src_type = func_type->get_member(loop_counter).get_type();
    // convert an array reference to a pointer
    if (src_type->is_array())
    {
      src_type = std::make_shared<PointerType>(src_type->get_base_type());
    }
    // decay a array variable memref into a pointer -> func_a(arr) /
    if ((func_parameter->get_type()->is_array() || func_parameter->get_type()->is_pointer()) && param_opd.is_memref())
    {
      param_opd = param_opd.memref_to();
    }

    // generate instructions, temporarily use opd1 as implicit converstions
    emit_basic_opt(HINS_mov_b, Operand(Operand::VREG, arg_vreg), param_opd, src_type);
    // m_hl_iseq->append(new Instruction(HighLevelOpcode::HINS_mov_q, Operand(Operand::VREG, arg_vreg), param_opd));
    loop_counter++;
  }
  // call instruction
  m_hl_iseq->append(new Instruction(HINS_call, Operand(Operand::LABEL, func_name)));
  // recover argument registers
  set_cur_vreg(saved_vreg);
  // assign the return value in vreg0 into a new temporary virtual register
  mov_opcode = get_opcode(HINS_mov_b, func_type->get_base_type());

  Operand temp_opd(Operand(Operand::VREG, get_next_local_vreg()));
  m_hl_iseq->append(new Instruction(mov_opcode, temp_opd, ret_opd));
  // function return stored in the temporary virtual register from vreg0
  n->set_operand(temp_opd);
}

void HighLevelCodegen::visit_field_ref_expression(Node *n)
{
  // load struct base address
  Node *struct_base_node = n->get_kid(0);
  visit(struct_base_node);

  std::string field_name = n->get_kid(1)->get_str();

  Operand struct_base_opd = struct_base_node->get_operand();

  n->set_operand(emit_field_arithmetric(struct_base_opd, struct_base_node->get_type(), field_name));
}

void HighLevelCodegen::visit_indirect_field_ref_expression(Node *n)
{
  // load struct base address
  Node *struct_base_node = n->get_kid(0);
  visit(struct_base_node);

  std::string field_name = n->get_kid(1)->get_str();

  Operand struct_base_opd = struct_base_node->get_operand();

  n->set_operand(emit_field_arithmetric(struct_base_opd, struct_base_node->get_type(), field_name));
}

void HighLevelCodegen::visit_array_element_ref_expression(Node *n)
{
  visit_children(n);

  Node *array_base_node = n->get_kid(0);
  Node *array_ref_node = n->get_kid(1);

  Operand array_idx_opd = array_ref_node->get_operand();
  Operand array_base_opd = array_base_node->get_operand();

  std::shared_ptr<Type> base_type = array_base_node->get_type()->get_base_type();
  std::shared_ptr<Type> idx_type = array_ref_node->get_type();

  n->set_operand(emit_pointer_arithmetric(array_base_opd, array_idx_opd, base_type, idx_type));
}

void HighLevelCodegen::visit_variable_ref(Node *n)
{
  Symbol *cur_sym = n->get_symbol();
  Operand variable_ref = get_var_storage_loc(cur_sym);
  n->set_operand(variable_ref);
}

void HighLevelCodegen::visit_literal_value(Node *n)
{
  // A partial implementation (note that this won't work correctly
  // for string constants!):

  LiteralValue val = n->get_literal_value();
  Operand dest = alloc_tmp_vreg();
  unsigned literal_kind = n->get_kid(0)->get_tag();
  if (literal_kind == TOK_INT_LIT)
  {
    Operand src(Operand::IMM_IVAL, val.get_int_value());
    std::shared_ptr<Type> src_type = n->get_type();

    n->set_operand(emit_basic_opt(HINS_mov_b, dest, src, src_type));
  }
  else if (literal_kind == TOK_CHAR_LIT)
  {
    Operand src(Operand::IMM_IVAL, static_cast<int>(val.get_char_value()));
    std::shared_ptr<Type> src_type = n->get_type();

    n->set_operand(emit_basic_opt(HINS_mov_b, dest, src, src_type));
  }
  else if (literal_kind == TOK_STR_LIT)
  {
    Operand src(Operand::IMM_LABEL, val.get_str_value());
    std::shared_ptr<Type> src_type = n->get_type();

    n->set_operand(emit_basic_opt(HINS_mov_b, dest, src, src_type));
  }
}

void HighLevelCodegen::visit_implicit_conversion(Node *n)
{
  visit_children(n);

  Operand opd_to_promote = n->get_kid(0)->get_operand();
  Operand promoted_opd = alloc_tmp_vreg();

  HighLevelOpcode opcode = get_promotion_opcode(n->get_kid(0)->get_type(), n->get_type());
  m_hl_iseq->append(new Instruction(opcode, promoted_opd, opd_to_promote));

  n->set_operand(promoted_opd);
}

std::string HighLevelCodegen::next_label()
{
  std::string label = ".L" + std::to_string(m_next_label_num++);
  return label;
}

// additional private member functions
Operand HighLevelCodegen::emit_pointer_arithmetric(Operand base_opd, Operand idx_opd, const std::shared_ptr<Type> &base_type, const std::shared_ptr<Type> &idx_type)
{
  if (base_opd.is_memref())
  {
    base_opd = base_opd.memref_to();
  }

  // Xsconv_XX vrXX, vrXX: align array index data width with pointer's
  // bug wl should be bq
  Operand tmp_opd = Operand(Operand::VREG, get_next_local_vreg());
  HighLevelOpcode sconv_opcode = get_sconv_opcode(HINS_sconv_lq, idx_type);
  m_hl_iseq->append(new Instruction(sconv_opcode, tmp_opd, idx_opd));
  // mul_q vrXX, vrXX, $X: mutiply to get the storage offset of the array index
  Operand index_offset_tmp_opd(Operand::VREG, get_next_local_vreg());
  Operand unit_size_opd(Operand::IMM_IVAL, base_type->get_storage_size());
  m_hl_iseq->append(new Instruction(HighLevelOpcode::HINS_mul_q, index_offset_tmp_opd, tmp_opd, unit_size_opd));
  // add_q vrXX, VrXX, vrXX: Conduct "add" to get the storage address of the index
  tmp_opd.set_base_reg(get_next_local_vreg());
  m_hl_iseq->append(new Instruction(HighLevelOpcode::HINS_add_q, tmp_opd, base_opd, index_offset_tmp_opd));
  return tmp_opd.to_memref();
};

// for struct field
Operand HighLevelCodegen::emit_field_arithmetric(Operand base_opd, const std::shared_ptr<Type> &type, std::string field_name)
{
  std::shared_ptr<Type> struct_type = type;
  if (base_opd.is_memref())
  {
    base_opd = base_opd.memref_to();
  }
  // for struct field indirect reference
  if (type->is_pointer())
  {
    struct_type = type->get_base_type();
  }
  std::shared_ptr<Type> field_type = struct_type->find_member(field_name)->get_type();
  // get the relative offset of the struct field
  unsigned offset = struct_type->find_member(field_name)->get_storage_offset();

  Operand field_offset_opd(Operand::IMM_IVAL, offset);
  Operand field_offset_tmp_opd(Operand::VREG, get_next_local_vreg());
  // mov_q tmp_opd1, field_offset
  m_hl_iseq->append(new Instruction(HighLevelOpcode::HINS_mov_q, field_offset_tmp_opd, field_offset_opd));
  // add_q vrXX, VrXX, vrXX: Conduct "add" to get the storage address of the index
  Operand tmp_add_opd(Operand::VREG, get_next_local_vreg());
  m_hl_iseq->append(new Instruction(HighLevelOpcode::HINS_add_q, tmp_add_opd, base_opd, field_offset_tmp_opd));

  /* for those fields whose type is pointer or array, the field reference should be a pointer
      rather than a variable reference */
  if (field_type->is_array() || field_type->is_pointer())
  {
    return tmp_add_opd;
  }

  return tmp_add_opd.to_memref();
};

Operand HighLevelCodegen::emit_basic_opt(HighLevelOpcode basic_code, Operand dst_opd, Operand src_opd, const std::shared_ptr<Type> &src_type)
{
  HighLevelOpcode opcode;
  // if (basic_code == HINS_mov_q)
  // {
  //   opcode == basic_code;
  // }
  // else
  // {
  opcode = get_opcode(basic_code, src_type);
  // }
  m_hl_iseq->append(new Instruction(opcode, dst_opd, src_opd));
  return m_hl_iseq->get_last_instruction()->get_operand(0);
}

Operand HighLevelCodegen::emit_basic_opt(HighLevelOpcode basic_code, Operand dst_opd, Operand src1_opd, Operand src2_opd, const std::shared_ptr<Type> &src_type)
{
  // operation with 3 operands will move the memref value to a new temp registers
  // While operation with 2 operands such as assignment doesn't do that
  if (src1_opd.is_memref())
  {
    src1_opd = emit_basic_opt(HINS_mov_b, alloc_tmp_vreg(), src1_opd, src_type);
  }
  if (src2_opd.is_memref())
  {
    src2_opd = emit_basic_opt(HINS_mov_b, alloc_tmp_vreg(), src2_opd, src_type);
  }

  HighLevelOpcode opcode = get_opcode(basic_code, src_type);
  m_hl_iseq->append(new Instruction(opcode, dst_opd, src1_opd, src2_opd));
  return m_hl_iseq->get_last_instruction()->get_operand(0);
}

// Adjust an opcode for a sconv type
HighLevelOpcode HighLevelCodegen::get_sconv_opcode(HighLevelOpcode base_opcode, const std::shared_ptr<Type> &type)
{
  return HighLevelOpcode::HINS_sconv_lq;
}
Operand HighLevelCodegen::alloc_tmp_vreg()
{
  return Operand(Operand::VREG, get_next_local_vreg());
}
Operand HighLevelCodegen::get_var_storage_loc(Symbol *sym)
{
  unsigned int stor_loc = sym->get_storage_location();
  Operand dest;
  if (sym->get_storage_type() == StorageType::VREG)
  {
    dest = Operand(Operand::VREG, stor_loc);
  }
  else if (sym->get_storage_type() == StorageType::MEM)
  {
    // if lvalue, generate a sequence of instructions to compute the exact address of the referenced lvalue.
    Operand lvalue_opd(Operand::VREG, get_next_local_vreg());
    m_hl_iseq->append(new Instruction(HighLevelOpcode::HINS_localaddr, lvalue_opd, Operand(Operand::IMM_IVAL, sym->get_storage_location())));
    dest = lvalue_opd.to_memref();
  }
  else
  {
    RuntimeError::raise("unkown storage type");
  }
  return dest;
}
// n -> arg_list
void HighLevelCodegen::mov_args_to_vrs(Node *arg_list)
{
  Symbol *cur_sym;
  for (auto i = arg_list->cbegin(); i != arg_list->cend(); ++i)
  {
    Node *func_parameter = *i;
    cur_sym = func_parameter->get_symbol();
    unsigned int arg_vreg = get_next_arg_vreg();

    if (cur_sym->get_storage_type() == StorageType::VREG)
    {
      Operand param_opd(Operand::VREG, cur_sym->get_storage_location());
      // arg virtual reg
      HighLevelOpcode mov_opcode = get_opcode(HINS_mov_b, func_parameter->get_type());
      m_hl_iseq->append(new Instruction(mov_opcode, param_opd, Operand(Operand::VREG, arg_vreg)));
    }
  }
  reset_arg_vreg();
}
