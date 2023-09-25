#ifndef AST_H
#define AST_H

#include "treeprint.h"

// AST node tags
enum ASTKind
{
  AST_ADD = 2000,
  AST_SUB,
  AST_MULTIPLY,
  AST_DIVIDE,
  AST_VARREF,
  AST_INT_LITERAL,
  AST_UNIT,
  AST_STATEMENT,
  // TODO: add members for other AST node kinds
  AST_ASSIGN,
  AST_AND,
  AST_OR,
  AST_GT,
  AST_GEQ,
  AST_LT,
  AST_LEQ,
  AST_EQ,
  AST_NEQ,
  AST_VARDEF,
  // assignment2
  AST_FUNC,
  AST_IF,
  AST_IF_ELSE,
  AST_IF_TRUE,
  AST_IF_FALSE,
  AST_WHILE,
  AST_WHILE_TRUE,
  AST_FUNC_STATEMENT_LIST,
  AST_PARAMETER_LIST,
  AST_FUNCTION_CALL,
  AST_ARGUMENT_LIST
};

class ASTTreePrint : public TreePrint
{
public:
  ASTTreePrint();
  virtual ~ASTTreePrint();

  virtual std::string node_tag_to_string(int tag) const;
};

#endif // AST_H
