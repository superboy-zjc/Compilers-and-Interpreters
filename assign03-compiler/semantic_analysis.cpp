#include <cassert>
#include <algorithm>
#include <utility>
#include <map>
#include "grammar_symbols.h"
#include "parse.tab.h"
#include "node.h"
#include "ast.h"
#include "exceptions.h"
#include "semantic_analysis.h"

SemanticAnalysis::SemanticAnalysis()
    : m_global_symtab(new SymbolTable(nullptr))
{
  m_cur_symtab = m_global_symtab;
}

SemanticAnalysis::~SemanticAnalysis()
{
}

void SemanticAnalysis::visit_struct_type(Node *n)
{
  // TODO: implement
  std::string name = n->get_kid(0)->get_str();
  Symbol *struct_sym = m_cur_symtab->lookup_recursive("struct " + name);
  if (struct_sym == nullptr)
  {
    SemanticError::raise(n->get_loc(), "Type error: structure definition doesn't exist");
  }
  n->set_type(struct_sym->get_type());
}

void SemanticAnalysis::visit_union_type(Node *n)
{
  RuntimeError::raise("union types aren't supported");
}

void SemanticAnalysis::visit_variable_declaration(Node *n)
{
  // visit the base type
  visit(n->get_kid(1));
  std::shared_ptr<Type> base_type = n->get_kid(1)->get_type();
  // iterate through declarators, adding variables
  // to the symbol table
  Node *decl_list = n->get_kid(2);
  for (auto i = decl_list->cbegin(); i != decl_list->cend(); ++i)
  {
    Node *declarator = *i;
    // ...handle the declarator...
    int tag = declarator->get_tag();
    if (tag == AST_NAMED_DECLARATOR)
    {
      Node *node = declarator->get_kid(0);
      if (m_cur_symtab->has_symbol_local(node->get_str()) || m_cur_symtab->has_symbol_local("struct " + node->get_str()))
      {
        SemanticError::raise(n->get_loc(), "Type error: variable name conflicted with other definitions");
      }
      m_cur_symtab->define(SymbolKind::VARIABLE, node->get_str(), base_type);
    }
    else if (tag == AST_ARRAY_DECLARATOR)
    {
      std::string name;
      std::shared_ptr<Type> array_type = base_type;
      name = process_array(declarator, array_type);

      if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
      {
        SemanticError::raise(n->get_loc(), "Type error: variable name conflicted with other definitions");
      }
      m_cur_symtab->define(SymbolKind::VARIABLE, name, array_type);
    }
    else if (tag == AST_POINTER_DECLARATOR)
    {
      std::string name;
      std::shared_ptr<Type> pointer_type = base_type;
      pointer_type = std::make_shared<PointerType>(pointer_type);
      name = process_pointer(declarator, pointer_type);

      if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
      {
        SemanticError::raise(n->get_loc(), "Type error: variable name conflicted with other definitions");
      }
      m_cur_symtab->define(SymbolKind::VARIABLE, name, pointer_type);
    }
  }
}

std::string SemanticAnalysis::process_pointer(Node *declarator, std::shared_ptr<Type> &pointer_type)
{
  std::string name;
  for (auto i = declarator->cbegin(); i != declarator->cend(); ++i)
  {
    Node *cur_node = *i;
    switch (cur_node->get_tag())
    {
    case AST_NAMED_DECLARATOR:
      name = cur_node->get_kid(0)->get_str();
      break;
    case AST_POINTER_DECLARATOR:
      pointer_type = std::make_shared<PointerType>(pointer_type);
      name = process_pointer(cur_node, pointer_type);

      break;
    case AST_ARRAY_DECLARATOR:
      name = process_array(cur_node, pointer_type);
      break;
    }
  }
  return name;
}
std::string SemanticAnalysis::process_array(Node *declarator, std::shared_ptr<Type> &array_type)
{
  std::string name;
  Node *array_length = declarator->get_kid(1);
  array_type = std::make_shared<ArrayType>(array_type, std::stoi(array_length->get_str()));

  Node *array_unit = declarator->get_kid(0);
  switch (array_unit->get_tag())
  {
  case AST_NAMED_DECLARATOR:
    name = array_unit->get_kid(0)->get_str();
    break;
  case AST_ARRAY_DECLARATOR:
    name = process_array(array_unit, array_type);
    break;
  }
  // for (auto i = declarator->cbegin(); i != declarator->cend(); ++i)
  // {
  //   Node *cur_node = *i;
  //   switch (cur_node->get_tag())
  //   {
  //   case AST_NAMED_DECLARATOR:
  //     name = cur_node->get_kid(0)->get_str();
  //     break;
  //   case AST_ARRAY_DECLARATOR:
  //     name = process_array(cur_node, array_type);
  //     break;
  //   }
  // }
  return name;
}

void SemanticAnalysis::visit_basic_type(Node *n)
{
  if (!n)
    return;
  bool has_char = false;
  bool has_int = false;
  bool has_void = false;
  bool has_long = false;
  bool has_short = false;
  bool has_signed = false;
  bool has_unsigned = false;
  bool has_const = false;
  bool has_volatile = false;

  n->each_child([&](Node *child)
                {
        std::string str = child->get_str();
        if (str == "char") {
            if (has_int || has_void || has_long || has_short) {
                  SemanticError::raise(child->get_loc(), "Type error: char cannot be combined with int or void");
            }
            has_char = true;
        } else if (str == "int") {
            if (has_char || has_void) {
                  SemanticError::raise(child->get_loc(), "Type error: int cannot be combined with char or void");
            }
            has_int = true;
        } else if (str == "void") {
            if (has_char || has_int || has_signed || has_unsigned || has_long || has_short || has_const || has_volatile) {
                  SemanticError::raise(child->get_loc(), "Type error: void cannot be combined with int or char");
            }
            has_void = true;
        } else if (str == "long") {
            if (has_short || has_char || has_void) {
                  SemanticError::raise(child->get_loc(), "Type error: long cannot be combined with short, char or void");
            }
            has_long = true;
        } else if (str == "short") {
            if (has_long || has_char || has_void) {
                  SemanticError::raise(child->get_loc(), "Type error: short cannot be combined with char, long or void");
            }
            has_short = true;
        } else if (str == "signed") {
            if (has_unsigned || has_void) {
                  SemanticError::raise(child->get_loc(), "Type error: signed cannot be combined with unsigned or void");
            }
            has_signed = true;
        } else if (str == "unsigned") {
            if (has_signed || has_void) {
                  SemanticError::raise(child->get_loc(), "Type error: unsigned cannot be combined with signed, void");
            }
            has_unsigned = true;
        } else if (str == "const") {
            if (has_void) {
                  SemanticError::raise(child->get_loc(), "Type error: const cannot be combined with void");
            }
            has_const = true;
        } else if (str == "volatile") {
            if (has_void) {
                  SemanticError::raise(child->get_loc(), "Type error: volatile cannot be combined with void");
            }
            has_volatile = true;
        } });

  if (has_void)
  {
    std::shared_ptr<Type> void_type(new BasicType(BasicTypeKind::VOID, true));
    n->set_type(void_type);
  }
  else if (has_char)
  {
    std::shared_ptr<Type> signed_char_type;
    if (has_unsigned)
    {
      signed_char_type = std::make_shared<BasicType>(BasicTypeKind::CHAR, false);
    }
    else
    {
      signed_char_type = std::make_shared<BasicType>(BasicTypeKind::CHAR, true);
    }
    // type qualifiers
    if (has_const)
    {
      std::shared_ptr<Type> qualified_type = std::make_shared<QualifiedType>(signed_char_type, TypeQualifier::CONST);
      signed_char_type = qualified_type;
    }
    if (has_volatile)
    {
      std::shared_ptr<Type> qualified_type2 = std::make_shared<QualifiedType>(signed_char_type, TypeQualifier::VOLATILE);
      signed_char_type = qualified_type2;
    }
    n->set_type(signed_char_type);
  }
  else
  // Integral number type
  {
    std::shared_ptr<Type> signed_int_type;
    // long
    if (has_long)
    {
      if (has_unsigned)
      {
        signed_int_type = std::make_shared<BasicType>(BasicTypeKind::LONG, false);
      }
      else
      {
        signed_int_type = std::make_shared<BasicType>(BasicTypeKind::LONG, true);
      }
    }
    // short
    else if (has_short)
    {
      if (has_unsigned)
      {
        signed_int_type = std::make_shared<BasicType>(BasicTypeKind::SHORT, false);
      }
      else
      {
        signed_int_type = std::make_shared<BasicType>(BasicTypeKind::SHORT, true);
      }
    }
    // int
    else
    {
      if (has_unsigned)
      {
        signed_int_type = std::make_shared<BasicType>(BasicTypeKind::INT, false);
      }
      else
      {
        signed_int_type = std::make_shared<BasicType>(BasicTypeKind::INT, true);
      }
    }

    // type qualifiers
    if (has_const)
    {
      std::shared_ptr<Type> qualified_type = std::make_shared<QualifiedType>(signed_int_type, TypeQualifier::CONST);
      signed_int_type = qualified_type;
    }
    if (has_volatile)
    {
      std::shared_ptr<Type> qualified_type2 = std::make_shared<QualifiedType>(signed_int_type, TypeQualifier::VOLATILE);
      signed_int_type = qualified_type2;
    }
    n->set_type(signed_int_type);
  }
}

void SemanticAnalysis::visit_function_definition(Node *n)
{
  // visit the function's base type
  visit(n->get_kid(0));
  std::shared_ptr<Type> base_type = n->get_kid(0)->get_type();

  std::string name = n->get_kid(1)->get_str(); /* the name of the struct type */
  // if function name been defined in the local symboltable, throw a error
  if ((m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name)) && m_cur_symtab->lookup_local(name)->is_defined())
  {
    SemanticError::raise(n->get_loc(), "Type error: function name conflicted with other definitions");
  }
  std::shared_ptr<Type> function_type(new FunctionType(base_type));
  // if function has been decla
  if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
  {
    m_cur_symtab->lookup_local(name)->set_is_defined(true);
  }
  else
  {
    m_cur_symtab->define(SymbolKind::FUNCTION, name, function_type);
  }
  // visit the block of definition of function parameters
  enter_scope();
  // create symbol table entries of parameters of a function definition
  visit(n->get_kid(2));
  // add all parameters as members onto the function type instance
  for (SymbolTable::const_iterator it = m_cur_symtab->cbegin(); it != m_cur_symtab->cend(); ++it)
  {
    Symbol *symbol = *it;
    Member member(symbol->get_name(), symbol->get_type());
    m_cur_symtab->get_parent()->lookup_local(name)->get_type()->add_member(member);
  }
  // parse the function statement lists
  visit(n->get_kid(3));
  // step out of the block of definition of function parameters
  leave_scope();
}

void SemanticAnalysis::visit_function_declaration(Node *n)
{
  // visit the function's base type
  visit(n->get_kid(0));
  std::shared_ptr<Type> base_type = n->get_kid(0)->get_type();

  std::string name = n->get_kid(1)->get_str(); /* the name of the struct type */
  // if function name been defined in the local symboltable, throw a error
  if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
  {
    SemanticError::raise(n->get_loc(), "Type error: function name conflicted with other definitions");
  }
  std::shared_ptr<Type> function_type(new FunctionType(base_type));
  // m_cur_symtab->declare(SymbolKind::FUNCTION, name, function_type);
  //  visit the block of definition of function parameters
  //  enter_scope();
  //  create symbol table entries of parameters of a function definition
  //  visit(n->get_kid(2));
  for (auto i = n->get_kid(2)->cbegin(); i != n->get_kid(2)->cend(); ++i)
  {
    Node *n = *i;
    visit_function_declaration_parameter(n, function_type);
  }
  m_cur_symtab->declare(SymbolKind::FUNCTION, name, function_type);
  // add all parameters as members onto the function type instance
  // for (SymbolTable::const_iterator it = m_cur_symtab->cbegin(); it != m_cur_symtab->cend(); ++it)
  // {
  //   Symbol *symbol = *it;
  //   Member member(symbol->get_name(), symbol->get_type());
  //   m_cur_symtab->lookup_local(name)->get_type()->add_member(member);
  // }

  // leave the scope of definition of function parameters
  // leave_scope();
}

// almost same as vriable_declaration function
void SemanticAnalysis::visit_function_parameter(Node *n)
{
  // visit the base type
  visit(n->get_kid(0));
  std::shared_ptr<Type> base_type = n->get_kid(0)->get_type();
  // iterate through declarators, adding variables
  // to the symbol table
  Node *declarator = n->get_kid(1);
  // ...handle the declarator...
  int tag = declarator->get_tag();
  if (tag == AST_NAMED_DECLARATOR)
  {
    Node *node = declarator->get_kid(0);
    if (m_cur_symtab->has_symbol_local(node->get_str()) || m_cur_symtab->has_symbol_local("struct " + node->get_str()))
    {
      SemanticError::raise(n->get_loc(), "Type error: function name conflicted with other definitions");
    }
    m_cur_symtab->define(SymbolKind::VARIABLE, node->get_str(), base_type);
  }
  else if (tag == AST_ARRAY_DECLARATOR)
  {
    std::string name;
    std::shared_ptr<Type> array_type = base_type;
    name = process_array(declarator, array_type);
    if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
    {
      SemanticError::raise(n->get_loc(), "Type error: function name conflicted with other definitions");
    }
    m_cur_symtab->define(SymbolKind::VARIABLE, name, array_type);
  }
  else if (tag == AST_POINTER_DECLARATOR)
  {
    std::string name;
    std::shared_ptr<Type> pointer_type = base_type;
    name = process_pointer(declarator, pointer_type);

    pointer_type = std::make_shared<PointerType>(pointer_type);
    if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
    {
      SemanticError::raise(n->get_loc(), "Type error: function name conflicted with other definitions");
    }
    m_cur_symtab->define(SymbolKind::VARIABLE, name, pointer_type);
  }
}

void SemanticAnalysis::visit_function_declaration_parameter(Node *n, std::shared_ptr<Type> &type)
{
  // visit the base type
  visit(n->get_kid(0));
  std::shared_ptr<Type> base_type = n->get_kid(0)->get_type();
  // iterate through declarators, adding variables
  // to the symbol table
  Node *declarator = n->get_kid(1);
  // ...handle the declarator...
  int tag = declarator->get_tag();
  if (tag == AST_NAMED_DECLARATOR)
  {
    Node *node = declarator->get_kid(0);
    Member member(node->get_str(), base_type);
    type->add_member(member);
  }
  else if (tag == AST_ARRAY_DECLARATOR)
  {
    std::string name;
    std::shared_ptr<Type> array_type = base_type;
    name = process_array(declarator, array_type);

    Member member(name, array_type);
    type->add_member(member);
  }
  else if (tag == AST_POINTER_DECLARATOR)
  {
    std::string name;
    std::shared_ptr<Type> pointer_type = base_type;
    name = process_pointer(declarator, pointer_type);

    pointer_type = std::make_shared<PointerType>(pointer_type);

    Member member(name, pointer_type);
    type->add_member(member);
  }
}

// void SemanticAnalysis::visit_function_parameter_list(Node *n)
// {
//   // TODO: solution
//   enter_scope();
//   visit_children(n);
// }

void SemanticAnalysis::visit_statement_list(Node *n)
{
  // TODO: implement
  enter_scope();
  visit_children(n);
  leave_scope();
}

void SemanticAnalysis::visit_return_expression_statement(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void SemanticAnalysis::visit_struct_type_definition(Node *n)
{
  // TODO: implement
  std::string name = n->get_kid(0)->get_str(); /* the name of the struct type */
  // if struct name been defined in the local symboltable, throw a error
  if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
  {
    SemanticError::raise(n->get_loc(), "Type error: struct name conflicted with other definitions");
  }
  std::shared_ptr<Type> struct_type(new StructType(name));
  m_cur_symtab->define(SymbolKind::TYPE, "struct " + name, struct_type);
  // visit the block of struct definition
  enter_scope();
  // create symbol table entries of fields of struct
  visit(n->get_kid(1));
  // add all fields as members onto the struct type instance
  for (SymbolTable::const_iterator it = m_cur_symtab->cbegin(); it != m_cur_symtab->cend(); ++it)
  {
    Symbol *symbol = *it;
    Member member(symbol->get_name(), symbol->get_type());
    // after definition of structure, adding fields onto struct type
    m_cur_symtab->get_parent()->lookup_local("struct " + name)->get_type()->add_member(member);
  }
  // step out of the block of struct definition
  leave_scope();
}

void SemanticAnalysis::visit_binary_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_unary_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_postfix_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_conditional_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_cast_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_function_call_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_field_ref_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_indirect_field_ref_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_array_element_ref_expression(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_variable_ref(Node *n)
{
  // TODO: implement
}

void SemanticAnalysis::visit_literal_value(Node *n)
{
  // TODO: implement
}

// TODO: implement helper functions
void SemanticAnalysis::enter_scope()
{
  SymbolTable *scope = new SymbolTable(m_cur_symtab);
  m_cur_symtab = scope;
}

void SemanticAnalysis::leave_scope()
{
  m_cur_symtab = m_cur_symtab->get_parent();
  assert(m_cur_symtab != nullptr);
}