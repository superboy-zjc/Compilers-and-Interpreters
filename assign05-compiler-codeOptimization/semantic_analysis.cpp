#include <cassert>
#include <algorithm>
#include <utility>
#include <vector>
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
      // for assignment04: label a symbol for every declarator
      // Example: every AST node -> AST_XXX_DECLARTOR, has a Symbol*
      declarator->set_symbol(m_cur_symtab->lookup_local(node->get_str()));
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
      // for assignment04: label a symbol for every declarator
      // Example: every AST node -> AST_XXX_DECLARTOR, has a Symbol*
      declarator->set_symbol(m_cur_symtab->lookup_local(name));
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
      // for assignment04: label a symbol for every declarator
      // Example: every AST node -> AST_XXX_DECLARTOR, has a Symbol*
      declarator->set_symbol(m_cur_symtab->lookup_local(name));
    }
  }
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
    std::shared_ptr<Type> char_type;
    if (has_unsigned)
    {
      char_type = std::make_shared<BasicType>(BasicTypeKind::CHAR, false);
    }
    else
    {
      char_type = std::make_shared<BasicType>(BasicTypeKind::CHAR, true);
    }
    // type qualifiers
    if (has_const)
    {
      // assign04 improve
      char_type = std::make_shared<QualifiedType>(char_type, TypeQualifier::CONST);
    }
    if (has_volatile)
    {
      // assign04 improve
      char_type = std::make_shared<QualifiedType>(char_type, TypeQualifier::VOLATILE);
      // std::shared_ptr<Type> qualified_type2 = std::make_shared<QualifiedType>(signed_char_type, TypeQualifier::VOLATILE);
      // signed_char_type = qualified_type2;
    }
    n->set_type(char_type);
  }
  else
  // Integral number type
  {
    std::shared_ptr<Type> int_type;
    // long
    if (has_long)
    {
      if (has_unsigned)
      {
        int_type = std::make_shared<BasicType>(BasicTypeKind::LONG, false);
      }
      else
      {
        int_type = std::make_shared<BasicType>(BasicTypeKind::LONG, true);
      }
    }
    // short
    else if (has_short)
    {
      if (has_unsigned)
      {
        int_type = std::make_shared<BasicType>(BasicTypeKind::SHORT, false);
      }
      else
      {
        int_type = std::make_shared<BasicType>(BasicTypeKind::SHORT, true);
      }
    }
    // int
    else
    {
      if (has_unsigned)
      {
        int_type = std::make_shared<BasicType>(BasicTypeKind::INT, false);
      }
      else
      {
        int_type = std::make_shared<BasicType>(BasicTypeKind::INT, true);
      }
    }

    // type qualifiers
    if (has_const)
    {
      int_type = std::make_shared<QualifiedType>(int_type, TypeQualifier::CONST);
      // std::shared_ptr<Type> qualified_type = std::make_shared<QualifiedType>(signed_int_type, TypeQualifier::CONST);
      // signed_int_type = qualified_type;
    }
    if (has_volatile)
    {
      int_type = std::make_shared<QualifiedType>(int_type, TypeQualifier::VOLATILE);
      // std::shared_ptr<Type> qualified_type2 = std::make_shared<QualifiedType>(int_type, TypeQualifier::VOLATILE);
      // signed_int_type = qualified_type2;
    }
    n->set_type(int_type);
  }
}

void SemanticAnalysis::visit_function_definition(Node *n)
{
  // visit the function's base type
  visit(n->get_kid(0));
  std::shared_ptr<Type> base_type = n->get_kid(0)->get_type();

  std::string name = n->get_kid(1)->get_str();
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
    // for assignment04: label a symbol for every function definition
    // Example: every AST node -> AST_FUNCTION_DEFINITION, has a Symbol*
    // which is for getting return
    // n->set_symbol(m_cur_symtab->lookup_local(name));
    // helper
    m_cur_symtab->define_no_print(SymbolKind::FUNCTION, "***return type***", base_type);
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
  // store symbol for assign04
  // n->set_symbol(m_cur_symtab->get_parent()->lookup_local(name));
  // parse the function statement lists
  visit(n->get_kid(3));
  // step out of the block of definition of function parameters
  leave_scope();
  m_cur_symtab->remove_symbol("***return type***");
}

void SemanticAnalysis::visit_function_declaration(Node *n)
{
  // visit the function's base type
  visit(n->get_kid(0));
  std::shared_ptr<Type> base_type = n->get_kid(0)->get_type();

  std::string name = n->get_kid(1)->get_str();
  // if function name been defined in the local symboltable, throw a error
  if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
  {
    SemanticError::raise(n->get_loc(), "Type error: function name conflicted with other definitions");
  }
  std::shared_ptr<Type> function_type(new FunctionType(base_type));
  for (auto i = n->get_kid(2)->cbegin(); i != n->get_kid(2)->cend(); ++i)
  {
    Node *n = *i;
    visit_function_declaration_parameter(n, function_type);
  }
  m_cur_symtab->declare(SymbolKind::FUNCTION, name, function_type);
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
    // for assignment04: label a symbol for every parameter
    // Example: every AST node -> AST_FUNCTION_PARAMETER, has a Symbol*
    n->set_symbol(m_cur_symtab->lookup_local(node->get_str()));
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
    // for assignment04: label a symbol for every parameter
    // Example: every AST node -> AST_FUNCTION_PARAMETER, has a Symbol*
    n->set_symbol(m_cur_symtab->lookup_local(name));
  }
  else if (tag == AST_POINTER_DECLARATOR)
  {
    std::string name;
    std::shared_ptr<Type> pointer_type = base_type;
    pointer_type = std::make_shared<PointerType>(pointer_type);
    name = process_pointer(declarator, pointer_type);

    if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
    {
      SemanticError::raise(n->get_loc(), "Type error: function name conflicted with other definitions");
    }
    m_cur_symtab->define(SymbolKind::VARIABLE, name, pointer_type);
    // for assignment04: label a symbol for every parameter
    // Example: every AST node -> AST_FUNCTION_PARAMETER, has a Symbol*
    n->set_symbol(m_cur_symtab->lookup_local(name));
  }
}

void SemanticAnalysis::visit_statement_list(Node *n)
{
  enter_scope();
  visit_children(n);
  leave_scope();
}

void SemanticAnalysis::visit_return_expression_statement(Node *n)
{
  std::shared_ptr<Type> res;
  Node *return_node = n->get_kid(0);
  visit(return_node);

  if (!return_node->has_type())
  {
    SemanticError::raise(n->get_loc(), "return value doesn't have a type!");
  }
  std::shared_ptr<Type> return_type = return_node->get_type();

  //
  Symbol *function_retype = m_cur_symtab->lookup_recursive("***return type***");
  std::shared_ptr<Type> predefined_return_type = function_retype->get_type();

  if (!return_type->is_same(predefined_return_type.get()))
  {
    // printf("type: opd1: %s\n opd2: %s\n", opd1->as_str().c_str(), rawPointer->as_str().c_str());
    if (return_type->is_integral() && predefined_return_type->is_integral())
    {
      funcdef_implicitly_conversion(return_type, predefined_return_type);
      // explicitly implicit conversion
      std::shared_ptr<Type> old_return_type = return_node->get_type();
      if (!return_type->is_same(old_return_type.get()))
      {
        n->set_kid(0, return_node = promote_to_a_type(return_node, predefined_return_type));
        // printf("type: %s converted to %s\n", old_return_type->as_str().c_str(), return_type->as_str().c_str());
      }
    }
    else
    {
      SemanticError::raise(n->get_loc(), "Return type error: function return value incompatible with expected value");
    }
  }
  n->set_type(predefined_return_type);
}

void SemanticAnalysis::visit_struct_type_definition(Node *n)
{
  std::string name = n->get_kid(0)->get_str(); /* the name of the struct type */
  // if struct name been defined in the local symboltable, throw a error
  if (m_cur_symtab->has_symbol_local(name) || m_cur_symtab->has_symbol_local("struct " + name))
  {
    SemanticError::raise(n->get_loc(), "Type error: struct name conflicted with other definitions");
  }
  std::shared_ptr<Type> struct_type(new StructType(name));
  Symbol *struct_sym = m_cur_symtab->define(SymbolKind::TYPE, "struct " + name, struct_type);

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
    // m_cur_symtab->get_parent()->lookup_local("struct " + name)->get_type()->add_member(member);
    // improve when doing assign04
    struct_type->add_member(member);
  }
  // for assignment04: label a symbol for every struct type definition
  // Example: every AST node -> AST_STRUCT_TYPE_DEFINITION, has a Symbol*
  n->set_symbol(struct_sym);

  // step out of the block of struct definition
  leave_scope();
}

void SemanticAnalysis::visit_binary_expression(Node *n)
{
  std::shared_ptr<Type> res;
  Node *opd1_node = n->get_kid(1);
  Node *opd2_node = n->get_kid(2);
  visit(opd1_node);
  visit(opd2_node);

  if (!opd1_node->has_type())
  {
    SemanticError::raise(n->get_loc(), "opd1 doesn't have a type!");
  }
  if (!opd2_node->has_type())
  {
    SemanticError::raise(n->get_loc(), "opd2 doesn't have a type!");
  }

  std::shared_ptr<Type> opd1 = n->get_kid(1)->get_type();
  std::shared_ptr<Type> opd2 = n->get_kid(2)->get_type();

  Node *opt = n->get_kid(0);
  if (opt->get_tag() == TOK_ASSIGN)
  {
    if (opd1->is_integral() && opd2->is_integral())
    {
      if (opd1->is_const())
      {
        SemanticError::raise(n->get_loc(), "const variable cannot be assigned");
      }
      if (!opd1_node->if_lvalue())
      {
        SemanticError::raise(n->get_loc(), "is not a lvalue");
      }
      n->set_type(opd1);
    }
    else if (opd1->is_pointer() && (opd2->is_pointer() || opd2->is_array()))
    {
      std::shared_ptr<Type> base_type1 = opd1->get_base_type();
      std::shared_ptr<Type> base_type2 = opd2->get_base_type();
      // printf("type: opd1: %s\n opd2: %s\n", opd1->get_base_type()->get_unqualified_type()->as_str().c_str(), opd2->get_base_type()->get_unqualified_type()->as_str().c_str());
      if (!base_type1->get_unqualified_type()->is_same(base_type2->get_unqualified_type()))
      {
        SemanticError::raise(n->get_loc(), "two points assigment without same unqualified type");
      }
      if ((base_type2->is_const() && !base_type1->is_const()) || (base_type2->is_volatile() && !base_type1->is_volatile()))
      {
        SemanticError::raise(n->get_loc(), "Right base type lack of qualifiers");
      }
      n->set_type(opd1);
    }
    else if ((opd1->is_pointer() && !opd2->is_pointer()) || (!opd1->is_pointer() && opd2->is_pointer()))
    {
      // printf("type: opd1: %s\n opd2: %s\n", opd1->as_str().c_str(), opd2->as_str().c_str());
      SemanticError::raise(n->get_loc(), "An assignment involving both pointer and non-pointer operands is never legal");
    }
    else if (opd1->is_struct() && opd2->is_struct())
    {
      Type *rawPointer = opd2.get();
      if (!opd1->is_same(rawPointer))
      {
        SemanticError::raise(n->get_loc(), "the type of both the left and right sides are not the same struct type");
      }
    }
    else
    {
      SemanticError::raise(n->get_loc(), "errrrrrrrrror");
    }
  }
  else if (is_operator_except_assignment(opt->get_tag()))
  {
    // bug: lack of consideration for qualified type
    if (opd1->is_integral() && opd2->is_integral())
    {
      binary_implicitly_conversion(opd1, opd2);
      // explicitly implicit conversion
      std::shared_ptr<Type> old_opd1 = n->get_kid(1)->get_type();
      std::shared_ptr<Type> old_opd2 = n->get_kid(2)->get_type();
      if (!opd1->is_same(old_opd1.get()))
      {
        n->set_kid(1, opd1_node = promote_to_a_type(opd1_node, opd1));
        // printf("type: %s converted to %s\n", old_opd1->as_str().c_str(), n->get_kid(1)->get_type()->as_str().c_str());
      }
      if (!opd2->is_same(old_opd2.get()))
      {
        n->set_kid(2, opd2_node = promote_to_a_type(opd2_node, opd2));
        // printf("type: %s converted to %s\n", old_opd2->as_str().c_str(), n->get_kid(2)->get_type()->as_str().c_str());
      }
      n->set_lvalue(false);
    }
    else if ((opd1->is_pointer() || opd1->is_array()) && opd2->is_integral())
    {
      // if operaion performed on an array, it should be converted into a pointer type
      if (opd1->is_array())
      {
        opd1 = std::make_shared<PointerType>(opd1->get_base_type());
      }
      n->set_lvalue(false);
    }
    else
    {
      SemanticError::raise(n->get_loc(), "error: invalid operands on binary expression");
    }

    // if (n->get_kid(0)->get_tag() == TOK_PLUS && n->get_kid(1)->get_kid(0)->get_str() == "i" && n->get_kid(2)->get_kid(0)->get_str() == "1")
    // {
    //   printf("debug!\n");
    // }
    // if relational operator or logical operator, the result type must be INT
    if (is_relational_operator(opt->get_tag()) || is_logical_operator(opt->get_tag()))
    {
      n->set_type(std::make_shared<BasicType>(BasicTypeKind::INT, true));
    }
    else
    {
      n->set_type(opd1);
    }
  }
}

void SemanticAnalysis::visit_unary_expression(Node *n)
{
  std::shared_ptr<Type> res;
  Node *opd_node = n->get_kid(1);
  visit(opd_node);

  if (!opd_node->has_type())
  {
    SemanticError::raise(n->get_loc(), "opd doesn't have a type!");
  }

  std::shared_ptr<Type> opd = n->get_kid(1)->get_type();

  Node *opt = n->get_kid(0);
  // - ! ~
  if (opt->get_tag() == TOK_MINUS || opt->get_tag() == TOK_BITWISE_COMPL || opt->get_tag() == TOK_NOT)
  {
    if (opd->is_integral())
    {
      // For unary (one operand) operations on integer values,
      // the operand value should be promoted to int or unsigned
      // int if it belongs to a less-precise type.
      if (opd->get_basic_type_kind() < BasicTypeKind::INT)
      {
        n->set_kid(1, opd_node = promote_to_int(opd_node));
        res = opd_node->get_type();
        // printf("type: %s converted to %s\n", opd->as_str().c_str(), n->get_kid(1)->get_type()->as_str().c_str());
      }
      else
      {
        res = opd;
      }
      n->set_lvalue(false);
    }
    else
    {
      SemanticError::raise(n->get_loc(), "error: improper usage of unary experssion");
    }
  }
  // &
  else if (opt->get_tag() == TOK_AMPERSAND)
  {
    if (!opd_node->if_lvalue())
    {
      SemanticError::raise(n->get_loc(), "Error: Taking address of non-lvalue");
    }
    else
    {
      // if operaion performed on an array, it should be converted into a pointer type
      if (opd->is_array())
      {
        std::shared_ptr<Type> opd = std::make_shared<PointerType>(opd->get_base_type());
      }
      res = std::make_shared<PointerType>(opd);
      // assign04
      // special case for AST_ARRAY_ELEMENT_REF_EXPRESSION
      // array element ref expression would be first kid of unary expresson, but it would not
      // contain a symbol object. And array is naturally allocated storage in the stack frame
      // without any need to mark its address taken.
      if (opd_node->has_symbol())
      {
        opd_node->get_symbol()->taken_address(true);
      }

      n->set_lvalue(false);
    }
  }
  // *
  else if (opt->get_tag() == TOK_ASTERISK)
  {
    if (opd->is_pointer() || opd->is_array())
    {
      res = opd->get_base_type();
      n->set_lvalue(true);
    }
    else
    {
      SemanticError::raise(n->get_loc(), "Dereference of non-pointer");
    }
  }
  n->set_type(res);
}

void SemanticAnalysis::visit_postfix_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void SemanticAnalysis::visit_conditional_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void SemanticAnalysis::visit_cast_expression(Node *n)
{
  // TODO: implement
  visit_children(n);
}

void SemanticAnalysis::visit_function_call_expression(Node *n)
{
  std::shared_ptr<Type> res;
  std::vector<std::shared_ptr<Type>> args_type;
  visit(n->get_kid(0));
  Node *fun_call = n->get_kid(0);
  if (!fun_call->get_type()->is_function())
  {
    SemanticError::raise(n->get_loc(), "Calling wrong function type");
  }

  Node *args = n->get_kid(1);

  // get all the arguments type into one vector
  for (auto i = args->cbegin(); i != args->cend(); ++i)
  {
    Node *cur_node = *i;
    visit(cur_node);
    std::shared_ptr<Type> myType = cur_node->get_type();
    args_type.push_back(myType);
  }
  // check arguments number
  if (fun_call->get_type()->get_num_members() != args_type.size())
  {
    SemanticError::raise(n->get_loc(), "Lack of function arguments");
  }
  // check arguments type
  for (unsigned int i = 0; i < fun_call->get_type()->get_num_members(); i++)
  {
    std::shared_ptr<Type> pre_defined_arg = fun_call->get_type()->get_member(i).get_type();
    std::shared_ptr<Type> passed_arg = args_type[i];
    Node *passed_arg_node = args->get_kid(i);
    // for callee
    //  array in the function parameter should be recognized as a pointer
    if (pre_defined_arg->is_array())
    {
      pre_defined_arg = std::make_shared<PointerType>(pre_defined_arg->get_base_type());
    }
    // for caller
    //  array in the function argument should be recognized as a pointer
    if (passed_arg->is_array())
    {
      passed_arg = std::make_shared<PointerType>(passed_arg->get_base_type());
      // assign04 for patching the argument expression node derivated from the AST function call node
      // update the argument with array reference to a pointer type
      // args->get_kid(i)->update_type(args_type[i]);
    }
    if (!passed_arg->is_same(pre_defined_arg.get()))
    {
      // printf("type: opd1: %s\n opd2: %s\n", args_type[i]->as_str().c_str(), rawPointer->as_str().c_str());
      if (passed_arg->is_integral() && pre_defined_arg->is_integral())
      {
        funcdef_implicitly_conversion(passed_arg, pre_defined_arg);
        // explicitly implicit conversion
        std::shared_ptr<Type> old_passed_arg_type = passed_arg_node->get_type();
        if (!passed_arg->is_same(old_passed_arg_type.get()))
        {
          args->set_kid(i, passed_arg_node = promote_to_a_type(passed_arg_node, passed_arg));
          // printf("type: %s converted to %s\n", old_passed_arg_type->as_str().c_str(), passed_arg_node->get_type()->as_str().c_str());
        }
      }
      else
      {
        SemanticError::raise(n->get_loc(), "Wrong Argument format");
      }
    }
  }

  res = fun_call->get_type()->get_base_type();
  n->set_type(res);
  n->set_lvalue(false);
}
// |     +--AST_FIELD_REF_EXPRESSION
// |     |  +--AST_VARIABLE_REF
// |     |  |  +--TOK_IDENT[b]
// |     |  +--TOK_IDENT[x]
// b.x
void SemanticAnalysis::visit_field_ref_expression(Node *n)
{
  // visit variable ref
  std::shared_ptr<Type> res;
  Node *block_ref = n->get_kid(0);
  std::string block_unit_name_to_visit = n->get_kid(1)->get_str();

  visit(block_ref);

  if (!block_ref->has_type())
  {
    SemanticError::raise(n->get_loc(), "struct field doesn't have a type!");
  }

  std::shared_ptr<Type> block_type = block_ref->get_type();

  if (!block_type->is_function() && !block_type->is_struct())
  {
    SemanticError::raise(n->get_loc(), "Field member doesn't exist");
  }
  res = block_type->find_member(block_unit_name_to_visit)->get_type();
  // if (!array_ref->get_type()->is_array())
  // {
  //   SemanticError::raise(n->get_loc(), "Array Variable Ref error: This is not a array type");
  // }
  n->set_type(res);
  // printf("%s", n->get_type()->as_str().c_str());
  n->set_lvalue(true);
}

// |     +--AST_INDIRECT_FIELD_REF_EXPRESSION
// |     |  +--AST_VARIABLE_REF
// |     |  |  +--TOK_IDENT[q]
// |     |  +--TOK_IDENT[x]
// q->x
void SemanticAnalysis::visit_indirect_field_ref_expression(Node *n)
{
  // visit variable ref
  std::shared_ptr<Type> res;
  Node *struct_var = n->get_kid(0);
  visit(struct_var);

  std::shared_ptr<Type> struct_type;
  std::string field_name = n->get_kid(1)->get_str();
  struct_type = struct_var->get_type();
  // struct abc *c;
  if (!struct_type->is_pointer() || !struct_type->get_base_type()->is_struct())
  {
    SemanticError::raise(n->get_loc(), "field indirect ref error!");
  }
  // find field member
  res = struct_type->get_base_type()->find_member(field_name)->get_type();

  n->set_type(res);
  // printf("%s", n->get_type()->as_str().c_str());
  n->set_lvalue(true);
}
// |     +--AST_ARRAY_ELEMENT_REF_EXPRESSION
// |     |  +--AST_VARIABLE_REF
// |     |  |  +--TOK_IDENT[a]
// |     |  +--AST_LITERAL_VALUE
// |     |     +--TOK_INT_LIT[3]
// a[3] -> example 04
void SemanticAnalysis::visit_array_element_ref_expression(Node *n)
{
  // visit variable ref
  std::shared_ptr<Type> res;
  Node *array_ref = n->get_kid(0);
  // traversal array base node and index node
  visit_children(n);
  if (!array_ref->has_type())
  {
    SemanticError::raise(n->get_loc(), "array element doesn't have a type!");
  }
  std::shared_ptr<Type> array_type = array_ref->get_type();

  // if (!array_ref->get_type()->is_array())
  // {
  //   SemanticError::raise(n->get_loc(), "Array Variable Ref error: This is not a array type");
  // }
  n->set_type(array_type->get_base_type());
  // printf("%s", n->get_type()->as_str().c_str());
  n->set_lvalue(true);
}

// |     |  +--AST_VARIABLE_REF
// |     |  |  +--TOK_IDENT[a]
void SemanticAnalysis::visit_variable_ref(Node *n)
{
  std::string name = n->get_kid(0)->get_str();
  Symbol *variable_ref = m_cur_symtab->lookup_recursive(name);
  //
  // Symbol *array_ref;
  if (variable_ref == nullptr)
  {
    SemanticError::raise(n->get_loc(), "Variable Ref error: variable name has not been defined yet");
  }
  if (variable_ref->get_type()->is_array())
  {
    // std::shared_ptr<Type> arr = std::make_shared<PointerType>(variable_ref->get_type()->get_base_type());
    // array_ref = new Symbol(SymbolKind::VARIABLE, name, arr, variable_ref->get_symtab(), true);

    // modified by assign04
    //  array_ref = new Symbol(SymbolKind::VARIABLE, name, variable_ref->get_type(), variable_ref->get_symtab(), true);
    n->set_lvalue(false);
  }
  else
  {
    n->set_lvalue(true);
  }
  n->set_symbol(variable_ref);
}
// |     |  +--AST_LITERAL_VALUE
// |     |     +--TOK_INT_LIT[3]
void SemanticAnalysis::visit_literal_value(Node *n)
{
  LiteralValue test;
  Node *literal = n->get_kid(0);
  bool ifsigned;

  if (literal->get_tag() == TOK_INT_LIT)
  {
    test = LiteralValue::from_int_literal(literal->get_str(), n->get_loc());
    // save the liternal value into the node
    n->set_literal_value(test);
    ifsigned = test.is_unsigned() ? false : true;
    if (test.is_long())
    {
      std::shared_ptr<Type> literal_type(new BasicType(BasicTypeKind::LONG, ifsigned));
      n->set_type(literal_type);
    }
    else
    {
      std::shared_ptr<Type> literal_type(new BasicType(BasicTypeKind::INT, ifsigned));
      n->set_type(literal_type);
    }
  }
  else if (literal->get_tag() == TOK_STR_LIT)
  {
    test = LiteralValue::from_str_literal(literal->get_str(), n->get_loc());
    // save the liternal value into the node
    n->set_literal_value(test);
    std::shared_ptr<Type> literal_type = std::make_shared<BasicType>(BasicTypeKind::CHAR, true);
    literal_type = std::make_shared<QualifiedType>(literal_type, TypeQualifier::CONST);
    literal_type = std::make_shared<PointerType>(literal_type);
    n->set_type(literal_type);
  }
  else if (literal->get_tag() == TOK_CHAR_LIT)
  {
    test = LiteralValue::from_char_literal(literal->get_str(), n->get_loc());
    // save the liternal value into the node
    n->set_literal_value(test);
    std::shared_ptr<Type> literal_type(new BasicType(BasicTypeKind::CHAR, true));

    n->set_type(literal_type);
  }
  n->set_lvalue(false);
}

// implement helper functions
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
  return name;
}

// almost same as vriable_declaration function
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
    pointer_type = std::make_shared<PointerType>(pointer_type);
    name = process_pointer(declarator, pointer_type);

    Member member(name, pointer_type);
    type->add_member(member);
  }
}

Node *SemanticAnalysis::promote_to_int(Node *n)
{
  assert(n->get_type()->is_integral());
  assert(n->get_type()->get_basic_type_kind() < BasicTypeKind::INT);
  std::shared_ptr<Type> type(new BasicType(BasicTypeKind::INT, n->get_type()->is_signed()));
  return implicit_conversion(n, type);
}

Node *SemanticAnalysis::implicit_conversion(Node *n, const std::shared_ptr<Type> &type)
{
  std::unique_ptr<Node> conversion(new Node(AST_IMPLICIT_CONVERSION, {n}));
  conversion->set_type(type);
  return conversion.release();
}
// assign04
Node *SemanticAnalysis::promote_to_a_type(Node *n, const std::shared_ptr<Type> &type)
{
  assert(n->has_type());
  // assert(n->get_type()->get_basic_type_kind() < BasicTypeKind::INT);
  // std::shared_ptr<Type> type(new BasicType(BasicTypeKind::INT, n->get_type()->is_signed()));
  return implicit_conversion(n, type);
}

// assign04
// + - * / %
bool SemanticAnalysis::is_operator_except_assignment(unsigned tag)
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
// < <= > >= == !=
bool SemanticAnalysis::is_relational_operator(unsigned tag)
{
  switch (tag)
  {
  case TOK_LT:
  case TOK_LTE:
  case TOK_GT:
  case TOK_GTE:
  case TOK_EQUALITY:
  case TOK_INEQUALITY:
    return true;
    break;
  default:
    return false;
    break;
  }
}
// && ||
bool SemanticAnalysis::is_logical_operator(unsigned tag)
{
  switch (tag)
  {
  case TOK_LOGICAL_AND:
  case TOK_LOGICAL_OR:
    return true;
    break;
  default:
    return false;
    break;
  }
}
void SemanticAnalysis::binary_implicitly_conversion(std::shared_ptr<Type> &opd1, std::shared_ptr<Type> &opd2)
{
  // implicit conversion through either operand
  // rule 1
  if (opd1->get_basic_type_kind() < BasicTypeKind::INT)
  {
    // representing implicit
    // n->set_kid(1, opd1_node = promote_to_int(opd1_node));
    opd1 = std::make_shared<BasicType>(BasicTypeKind::INT, opd1->is_signed());
  }
  // printf("type: opd1: %s\n opd2: %s\n", opd1->as_str().c_str(), opd2->as_str().c_str());
  if (opd2->get_basic_type_kind() < BasicTypeKind::INT)
  {
    // representing implicit
    // n->set_kid(2, opd2_node = promote_to_int(opd2_node));
    opd2 = std::make_shared<BasicType>(BasicTypeKind::INT, opd2->is_signed());
  }
  // rule 2
  if (opd1->get_basic_type_kind() < opd2->get_basic_type_kind())
  {
    opd1 = std::make_shared<BasicType>(opd2->get_basic_type_kind(), opd1->is_signed());
  }
  else if (opd1->get_basic_type_kind() > opd2->get_basic_type_kind())
  {
    opd2 = std::make_shared<BasicType>(opd1->get_basic_type_kind(), opd2->is_signed());
  }
  // rule 3
  if (!opd1->is_signed() || !opd2->is_signed())
  {
    opd1 = std::make_shared<BasicType>(opd1->get_basic_type_kind(), false);
    opd2 = std::make_shared<BasicType>(opd2->get_basic_type_kind(), false);
  }
}

void SemanticAnalysis::funcdef_implicitly_conversion(std::shared_ptr<Type> &opd1, std::shared_ptr<Type> &opd2)
{
  // implicit conversion through either operand
  // rule 2
  if (opd1->get_basic_type_kind() < opd2->get_basic_type_kind())
  {
    opd1 = std::make_shared<BasicType>(opd2->get_basic_type_kind(), opd1->is_signed());
  }
  // rule 3
  // if opd1 is signed and opd2 is unsigned, that means opd1 needs to be converted into unsigned
  // otherwise, we don't have to do anything special
  if (opd1->is_signed() && !opd2->is_signed())
  {
    opd1 = std::make_shared<BasicType>(opd1->get_basic_type_kind(), false);
  }
}
