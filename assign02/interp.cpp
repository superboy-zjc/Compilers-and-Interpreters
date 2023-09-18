#include <cassert>
#include <algorithm>
#include <memory>
#include "ast.h"
#include "node.h"
#include "exceptions.h"
#include "function.h"
#include "interp.h"
#include "ast.h"

Interpreter::Interpreter(Node *ast_to_adopt)
    : m_ast(ast_to_adopt)
{
}

Interpreter::~Interpreter()
{
  delete m_ast;
}

void Interpreter::analyze()
{
  // TODO: implement
  // std::set<std::string> definedVariables;
  analyzeNode(*m_ast);
}

Value Interpreter::execute()
{
  // TODO: implement
  return evaluate(*m_ast);
}

void Interpreter::analyzeNode(const Node &node)
{
  if (node.get_tag() == AST_VARREF)
  {
    m_env.lookup(node.get_str(), node.get_loc());
  }
  else if (node.get_tag() == AST_VARDEF)
  {
    m_env.define(node.get_kid(0)->get_str(), Value(0), node.get_loc());
  }
  else
  {
    for (unsigned int i = 0; i < node.get_num_kids(); i++)
    {
      analyzeNode(*node.get_kid(i));
    }
  }
}

Value Interpreter::evaluate(const Node &node)
{
  if (node.get_tag() == AST_UNIT)
  {
    int statms = node.get_num_kids();
    for (int i = 0; i < statms - 1; i++)
    {
      evaluate(*node.get_kid(i));
    }
    return evaluate(*node.get_kid(statms - 1));
  }
  else if (node.get_tag() == AST_STATEMENT)
  {
    return evaluate(*node.get_kid(0));
  }
  else if (node.get_tag() == AST_INT_LITERAL)
  {
    return Value(std::stoi(node.get_str()));
  }
  else if (node.get_tag() == AST_VARREF)
  {
    return m_env.lookup(node.get_str(), node.get_loc());
  }
  else if (node.get_tag() == AST_ASSIGN)
  {
    Value r_side = evaluate(*node.get_kid(1));
    m_env.assign(node.get_kid(0)->get_str(), r_side, node.get_kid(0)->get_loc());
    return r_side;
  }
  else if (node.get_tag() == AST_VARDEF)
  {
    Value init = Value(0);
    m_env.define(node.get_kid(0)->get_str(), init, node.get_loc());
    return init;
  }
  else
  {
    switch (node.get_tag())
    {
    case AST_ADD:
      return Value(evaluate(*node.get_kid(0)).get_ival() + evaluate(*node.get_kid(1)).get_ival());
    case AST_SUB:
      return Value(evaluate(*node.get_kid(0)).get_ival() - evaluate(*node.get_kid(1)).get_ival());
    case AST_MULTIPLY:
      return Value(evaluate(*node.get_kid(0)).get_ival() * evaluate(*node.get_kid(1)).get_ival());
    case AST_DIVIDE:
    {
      Value divisor = evaluate(*node.get_kid(1));
      if (divisor.get_ival() == 0)
      {
        EvaluationError::raise(node.get_loc(), "Divisor should not be 0");
      }
      return Value(evaluate(*node.get_kid(0)).get_ival() / divisor.get_ival());
    }
    case AST_AND:
      return Value(evaluate(*node.get_kid(0)).get_ival() && evaluate(*node.get_kid(1)).get_ival());
    case AST_OR:
      return Value(evaluate(*node.get_kid(0)).get_ival() || evaluate(*node.get_kid(1)).get_ival());
    case AST_GT:
      return Value(evaluate(*node.get_kid(0)).get_ival() > evaluate(*node.get_kid(1)).get_ival());
    case AST_GEQ:
      return Value(evaluate(*node.get_kid(0)).get_ival() >= evaluate(*node.get_kid(1)).get_ival());
    case AST_LT:
      return Value(evaluate(*node.get_kid(0)).get_ival() < evaluate(*node.get_kid(1)).get_ival());
    case AST_LEQ:
      return Value(evaluate(*node.get_kid(0)).get_ival() <= evaluate(*node.get_kid(1)).get_ival());
    case AST_EQ:
      return Value(evaluate(*node.get_kid(0)).get_ival() == evaluate(*node.get_kid(1)).get_ival());
    case AST_NEQ:
      return Value(evaluate(*node.get_kid(0)).get_ival() != evaluate(*node.get_kid(1)).get_ival());
    default:
      EvaluationError::raise(node.get_loc(), "Unknown operator %s", node.get_str().c_str());
    }
  }
}