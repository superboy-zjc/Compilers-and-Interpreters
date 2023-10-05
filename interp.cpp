#include <cassert>
#include <algorithm>
#include <memory>
#include "ast.h"
#include "node.h"
#include "exceptions.h"
#include "function.h"
#include "array.h"
#include "interp.h"
#include "ast.h"

Interpreter::Interpreter(Node *ast_to_adopt)
    : m_ast(ast_to_adopt)
{
  m_env.define("print", Value(&intrinsic_print));
  m_env.define("println", Value(&intrinsic_println));
  m_env.define("readint", Value(&intrinsic_readint));
  m_env.define("mkarr", Value(&intrinsic_mkarr));
  m_env.define("len", Value(&intrinsic_len));
  m_env.define("get", Value(&intrinsic_get));
  m_env.define("set", Value(&intrinsic_set));
  m_env.define("push", Value(&intrinsic_push));
  m_env.define("pop", Value(&intrinsic_pop));
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
  std::unique_ptr<Environment> pre_analysis(new Environment(&m_env));
  analyzeNode(node, pre_analysis.get());
}

void Interpreter::analyzeNode(const Node &node, Environment *cur_env)
{
  if (node.get_tag() == AST_VARREF)
  {
    cur_env->lookup(node.get_str(), node.get_loc());
  }
  else if (node.get_tag() == AST_VARDEF)
  {
    cur_env->define(node.get_kid(0)->get_str(), Value(0), node.get_loc());
  }
  else if (node.get_tag() == AST_FUNC)
  {
    cur_env->define(node.get_kid(0)->get_str(), Value(0), node.get_loc());
    std::unique_ptr<Environment> func_call(new Environment(cur_env));
    std::unique_ptr<Environment> func_env(new Environment(func_call.get()));

    analyzeNode(*node.get_kid(1), func_call.get());
    analyzeNode(*node.get_kid(2), func_env.get());
  }
  else if (node.get_tag() == AST_PARAMETER_LIST)
  {
    for (unsigned int i = 0; i < node.get_num_kids(); i++)
    {
      cur_env->define(node.get_kid(i)->get_str(), Value(0), node.get_loc());
    }
  }
  else if (node.get_tag() == AST_FUNCTION_CALL)
  {
    cur_env->lookup(node.get_kid(0)->get_str(), node.get_loc());

    std::unique_ptr<Environment> func_call(new Environment(cur_env));
    analyzeNode(*node.get_kid(1), func_call.get());
  }
  else if (node.get_tag() == AST_IF || node.get_tag() == AST_IF_ELSE || node.get_tag() == AST_WHILE)
  {
    std::unique_ptr<Environment> c_env(new Environment(cur_env));
    // if statement's condition belong to the current environment;
    analyzeNode(*node.get_kid(0), cur_env);
    analyzeNode(*node.get_kid(1), c_env.get());
    if (node.get_tag() == AST_IF_ELSE)
    {
      std::unique_ptr<Environment> else_env(new Environment(cur_env));
      analyzeNode(*node.get_kid(2), else_env.get());
    }
  }
  else
  {
    for (unsigned int i = 0; i < node.get_num_kids(); i++)
    {
      analyzeNode(*node.get_kid(i), cur_env);
    }
  }
}

Value Interpreter::evaluate(const Node &node)
{
  return evaluate(node, &m_env);
}
Value Interpreter::evaluate(const Node &node, Environment *cur_env)
{
  if (node.get_tag() == AST_UNIT || node.get_tag() == AST_IF_TRUE || node.get_tag() == AST_IF_FALSE || node.get_tag() == AST_WHILE_TRUE || node.get_tag() == AST_FUNC_STATEMENT_LIST)
  {
    int statms = node.get_num_kids();
    for (int i = 0; i < statms - 1; i++)
    {
      evaluate(*node.get_kid(i), cur_env);
    }
    return evaluate(*node.get_kid(statms - 1), cur_env);
  }
  else if (node.get_tag() == AST_FUNC)
  {
    std::string fn_name = node.get_kid(0)->get_str().c_str();
    std::vector<std::string> param_names;
    for (unsigned int i = 0; i < node.get_kid(1)->get_num_kids(); i++)
    {
      param_names.push_back(node.get_kid(1)->get_kid(i)->get_str().c_str());
    }
    Node *body = node.get_kid(2);

    // initialize fn_name, param_names, and body ...
    Function *init_function = new Function(fn_name, param_names, cur_env, body);
    // add refer count to the dynamic type of data
    init_function->add_ref();
    // assign the function object to Value object
    Value fn_val(init_function);
    cur_env->define(fn_name, fn_val, node.get_loc());
    return Value();
  }
  else if (node.get_tag() == AST_FUNCTION_CALL)
  {
    Value look = cur_env->lookup(node.get_kid(0)->get_str(), node.get_loc());
    if (look.get_kind() == VALUE_INTRINSIC_FN)
    {
      unsigned int num_args = node.get_kid(1)->get_num_kids();
      // Value args[num_args];
      auto args = std::make_unique<Value[]>(num_args);
      for (unsigned int i = 0; i < num_args; i++)
      {
        args[i] = evaluate(*node.get_kid(1)->get_kid(i), cur_env);
      }
      // store arguments in the args array
      IntrinsicFn fn = look.get_intrinsic_fn();
      Value result = fn(args.get(), num_args, node.get_loc(), this);
      return result;
    }
    else if (look.get_kind() == VALUE_FUNCTION)
    {
      // check the number of arguments
      if (node.get_kid(1)->get_num_kids() != look.get_function()->get_num_params())
      {
        EvaluationError::raise(node.get_loc(), "too few arguments in function call %s", look.as_str().c_str());
      }
      // create a function call environment for reserving and mapping arguments with parameters
      std::unique_ptr<Environment> func_call(new Environment(look.get_function()->get_parent_env()));
      for (unsigned int i = 0; i < look.get_function()->get_num_params(); i++)
      {
        func_call->define(look.get_function()->get_params()[i], evaluate(*node.get_kid(1)->get_kid(i), cur_env), node.get_kid(1)->get_kid(i)->get_loc());
      }
      // create a function statment environment which parent env is function call
      //  and in which function statements been executed
      std::unique_ptr<Environment> func_statements(new Environment(func_call.get()));
      return evaluate(*look.get_function()->get_body(), func_statements.get());
    }
    else
    {
      EvaluationError::raise(node.get_loc(), "expression preceding parentheses of apparent call must have function type %s", node.get_kid(0)->get_str().c_str());
    }
  }
  else if (node.get_tag() == AST_STATEMENT)
  {
    return evaluate(*node.get_kid(0), cur_env);
  }
  else if (node.get_tag() == AST_IF || node.get_tag() == AST_IF_ELSE)
  {
    std::unique_ptr<Environment> if_env(new Environment(cur_env));
    std::unique_ptr<Environment> else_env(new Environment(cur_env));
    // if statement's condition belong to the current environment;
    Value res = evaluate(*node.get_kid(0), cur_env);
    if (!res.is_numeric())
    {
      EvaluationError::raise(node.get_loc(), "expression must have bool type");
    }
    else if (res.get_ival() != 0)
    {
      evaluate(*node.get_kid(1), if_env.get());
    }
    else if (res.get_ival() == 0 && node.get_tag() == AST_IF_ELSE)
    {
      evaluate(*node.get_kid(2), else_env.get());
    }

    return Value(0);
  }
  else if (node.get_tag() == AST_WHILE)
  {
    std::unique_ptr<Environment> c_env(new Environment(cur_env));
    Value res;
    // if statement's condition belong to the current environment;
    for (;;)
    {
      res = evaluate(*node.get_kid(0), cur_env);
      if (!res.is_numeric())
      {
        EvaluationError::raise(node.get_loc(), "expression must have bool type %s", node.get_str().c_str());
      }
      else if (res.get_ival() != 0)
      {
        evaluate(*node.get_kid(1), c_env.get());
        c_env->clear();
      }
      else
      {
        break;
      }
    }
    return Value(0);
  }
  else if (node.get_tag() == AST_INT_LITERAL)
  {
    return Value(std::stoi(node.get_str()));
  }
  else if (node.get_tag() == AST_VARREF)
  {
    return cur_env->lookup(node.get_str(), node.get_loc());
  }
  else if (node.get_tag() == AST_ASSIGN)
  {
    Value r_side = evaluate(*node.get_kid(1), cur_env);
    cur_env->assign(node.get_kid(0)->get_str(), r_side, node.get_kid(0)->get_loc());
    return r_side;
  }
  else if (node.get_tag() == AST_VARDEF)
  {
    Value init = Value(0);
    cur_env->define(node.get_kid(0)->get_str(), init, node.get_loc());
    return init;
  }
  else
  {
    switch (node.get_tag())
    {
    case AST_ADD:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() + evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_SUB:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() - evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_MULTIPLY:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() * evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_DIVIDE:
    {
      Value divisor = evaluate(*node.get_kid(1), cur_env);
      if (divisor.get_ival() == 0)
      {
        EvaluationError::raise(node.get_loc(), "Divisor should not be 0");
      }
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() / divisor.get_ival());
    }
    case AST_AND:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() && evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_OR:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() || evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_GT:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() > evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_GEQ:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() >= evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_LT:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() < evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_LEQ:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() <= evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_EQ:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() == evaluate(*node.get_kid(1), cur_env).get_ival());
    case AST_NEQ:
      return Value(evaluate(*node.get_kid(0), cur_env).get_ival() != evaluate(*node.get_kid(1), cur_env).get_ival());
    default:
      EvaluationError::raise(node.get_loc(), "Unknown operator %s", node.get_str().c_str());
    }
  }
}

Value Interpreter::intrinsic_print(Value args[], unsigned num_args,
                                   const Location &loc, Interpreter *interp)
{
  if (num_args != 1)
    EvaluationError::raise(loc, "Wrong number of arguments passed to print function");
  printf("%s", args[0].as_str().c_str());
  return Value();
}

Value Interpreter::intrinsic_println(Value args[], unsigned num_args,
                                     const Location &loc, Interpreter *interp)
{
  if (num_args != 1)
    EvaluationError::raise(loc, "Wrong number of arguments passed to print function");
  printf("%s\n", args[0].as_str().c_str());
  return Value();
}

Value Interpreter::intrinsic_readint(Value args[], unsigned num_args,
                                     const Location &loc, Interpreter *interp)
{
  if (num_args != 0)
    EvaluationError::raise(loc, "Wrong number of arguments passed to print function");
  int num;
  int ret = scanf("%d", &num);
  if (ret == 1)
  {
    return Value(num);
  }
  else if (ret == EOF)
  {
    EvaluationError::raise(loc, "Error: End of file or error occurred!\n");
  }
  else
  {
    EvaluationError::raise(loc, "Error:  Invalid input!\n");
  }
}

Value Interpreter::intrinsic_mkarr(Value args[], unsigned num_args,
                                   const Location &loc, Interpreter *interp)
{
  std::vector<int> arr = {};
  // initialize fn_name, param_names, and body ...
  Array *init_array = new Array(arr);
  // add refer count to the dynamic type of data
  init_array->add_ref();
  // assign the function object to Value object

  if (num_args > 0)
  {
    for (unsigned int i = 0; i < num_args; i++)
    {
      if (args[i].get_kind() != VALUE_INT)
      {
        EvaluationError::raise(loc, "Error: Invalid array element type!\n");
      }
      init_array->push(args[i].get_ival());
    }
  }
  return Value(init_array);
}
Value Interpreter::intrinsic_len(Value args[], unsigned num_args,
                                 const Location &loc, Interpreter *interp)
{
  if (num_args != 1 || args[0].get_kind() != VALUE_ARRAY)
  {
    EvaluationError::raise(loc, "Wrong number or type of arguments passed to len function");
  }
  return Value(args[0].get_array()->get_length());
}
Value Interpreter::intrinsic_get(Value args[], unsigned num_args,
                                 const Location &loc, Interpreter *interp)
{
  if (num_args != 2)
  {
    EvaluationError::raise(loc, "Wrong number of arguments passed to get function");
  }
  if (args[0].get_kind() != VALUE_ARRAY || args[1].get_kind() != VALUE_INT)
  {
    EvaluationError::raise(loc, "Wrong type of arguments passed to get function");
  }
  Array *arr = args[0].get_array();
  int index = args[1].get_ival();
  if (arr->get_length() < index + 1)
  {
    EvaluationError::raise(loc, "Wrong index of array passed to get function, the index doesn't exsit");
  }
  return Value(arr->get_member(index));
}
Value Interpreter::intrinsic_set(Value args[], unsigned num_args,
                                 const Location &loc, Interpreter *interp)
{
  if (num_args != 3)
  {
    EvaluationError::raise(loc, "Wrong number of arguments passed to get function");
  }

  if (args[0].get_kind() != VALUE_ARRAY || args[1].get_kind() != VALUE_INT || args[2].get_kind() != VALUE_INT)
  {
    EvaluationError::raise(loc, "Wrong type of arguments passed to get function");
  }

  Array *arr = args[0].get_array();
  int index = args[1].get_ival();
  int value = args[2].get_ival();
  if (arr->get_length() < index + 1)
  {
    EvaluationError::raise(loc, "Wrong index of array passed to get function, the index doesn't exsit");
  }
  arr->set_member(index, value);
  return Value();
}
Value Interpreter::intrinsic_push(Value args[], unsigned num_args,
                                  const Location &loc, Interpreter *interp)
{
  if (num_args != 2)
  {
    EvaluationError::raise(loc, "Wrong number of arguments passed to get function");
  }

  if (args[0].get_kind() != VALUE_ARRAY || args[1].get_kind() != VALUE_INT)
  {
    EvaluationError::raise(loc, "Wrong type of arguments passed to get function");
  }
  Array *arr = args[0].get_array();
  int value = args[1].get_ival();
  arr->push(value);
  return Value();
}
Value Interpreter::intrinsic_pop(Value args[], unsigned num_args,
                                 const Location &loc, Interpreter *interp)
{
  if (num_args != 1)
  {
    EvaluationError::raise(loc, "Wrong number of arguments passed to get function");
  }

  if (args[0].get_kind() != VALUE_ARRAY)
  {
    EvaluationError::raise(loc, "Wrong type of arguments passed to get function");
  }
  Array *arr = args[0].get_array();
  if (arr->get_length() < 1)
  {
    EvaluationError::raise(loc, "The array cannot pop");
  }

  arr->pop();
  return Value();
}