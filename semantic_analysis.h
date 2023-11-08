#ifndef SEMANTIC_ANALYSIS_H
#define SEMANTIC_ANALYSIS_H

#include <cstdint>
#include <memory>
#include <utility>
#include "type.h"
#include "symtab.h"
#include "ast_visitor.h"

class SemanticAnalysis : public ASTVisitor
{
private:
  SymbolTable *m_global_symtab, *m_cur_symtab;

public:
  SemanticAnalysis();
  virtual ~SemanticAnalysis();

  SymbolTable *get_global_symtab() { return m_global_symtab; }

  virtual void visit_struct_type(Node *n);
  virtual void visit_union_type(Node *n);
  virtual void visit_variable_declaration(Node *n);
  virtual void visit_basic_type(Node *n);
  virtual void visit_function_definition(Node *n);
  virtual void visit_function_declaration(Node *n);
  virtual void visit_function_parameter(Node *n);
  // virtual void visit_function_parameter_list(Node *n);
  virtual void visit_statement_list(Node *n);
  virtual void visit_return_expression_statement(Node *n);
  virtual void visit_struct_type_definition(Node *n);
  virtual void visit_binary_expression(Node *n);
  virtual void visit_unary_expression(Node *n);
  virtual void visit_postfix_expression(Node *n);
  virtual void visit_conditional_expression(Node *n);
  virtual void visit_cast_expression(Node *n);
  virtual void visit_function_call_expression(Node *n);
  virtual void visit_field_ref_expression(Node *n);
  virtual void visit_indirect_field_ref_expression(Node *n);
  virtual void visit_array_element_ref_expression(Node *n);
  virtual void visit_variable_ref(Node *n);
  virtual void visit_literal_value(Node *n);
  Node *promote_to_int(Node *n);
  Node *implicit_conversion(Node *n, const std::shared_ptr<Type> &type);
  // assign04
  Node *promote_to_a_type(Node *n, const std::shared_ptr<Type> &type);
  bool is_operator_except_assignment(unsigned tag);
  void binary_implicitly_conversion(std::shared_ptr<Type> &opd1, std::shared_ptr<Type> &opd2);
  bool is_relational_operator(unsigned tag);
  bool is_logical_operator(unsigned tag);

private:
  void enter_scope();
  void leave_scope();
  std::string process_array(Node *declarator, std::shared_ptr<Type> &base_type);
  std::string process_pointer(Node *declarator, std::shared_ptr<Type> &base_type);
  void visit_function_declaration_parameter(Node *n, std::shared_ptr<Type> &type);
};

#endif // SEMANTIC_ANALYSIS_H
