#include "exceptions.h"
#include "ast.h"

ASTTreePrint::ASTTreePrint()
{
}

ASTTreePrint::~ASTTreePrint()
{
}

std::string ASTTreePrint::node_tag_to_string(int tag) const
{
  switch (tag)
  {
  case AST_ADD:
    return "ADD";
  case AST_SUB:
    return "SUB";
  case AST_MULTIPLY:
    return "MULTIPLY";
  case AST_DIVIDE:
    return "DIVIDE";
  case AST_VARREF:
    return "VARREF";
  case AST_INT_LITERAL:
    return "INT_LITERAL";
  case AST_UNIT:
    return "UNIT";
  case AST_STATEMENT:
    return "STATEMENT";
  // TODO: add cases for other AST node kinds
  case AST_VARDEF:
    return "VARDEF";
  case AST_ASSIGN:
    return "ASSIGN";
  case AST_AND:
    return "AND";
  case AST_OR:
    return "OR";
  case AST_LT:
    return "LT";
  case AST_LEQ:
    return "LEQ";
  case AST_GT:
    return "GT";
  case AST_GEQ:
    return "GEQ";
  case AST_EQ:
    return "EQ";
  case AST_NEQ:
    return "AST_NEQ";

  default:
    RuntimeError::raise("Unknown AST node type %d\n", tag);
  }
}
