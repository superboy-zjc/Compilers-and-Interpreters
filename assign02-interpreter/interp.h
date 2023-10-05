#ifndef INTERP_H
#define INTERP_H

#include "value.h"
#include "environment.h"
#include <set>
class Node;
class Location;

class Interpreter
{
private:
  Node *m_ast;
  Environment m_env;

public:
  Interpreter(Node *ast_to_adopt);
  ~Interpreter();

  void analyze();
  Value execute();

  void analyzeNode(const Node &node);
  void analyzeNode(const Node &node, Environment *cur_env);
  static Value intrinsic_print(Value args[], unsigned num_args,
                               const Location &loc, Interpreter *interp);
  static Value intrinsic_println(Value args[], unsigned num_args,
                                 const Location &loc, Interpreter *interp);
  static Value intrinsic_readint(Value args[], unsigned num_args,
                                 const Location &loc, Interpreter *interp);
  // for array operation
  static Value intrinsic_mkarr(Value args[], unsigned num_args,
                               const Location &loc, Interpreter *interp);
  static Value intrinsic_len(Value args[], unsigned num_args,
                             const Location &loc, Interpreter *interp);
  static Value intrinsic_get(Value args[], unsigned num_args,
                             const Location &loc, Interpreter *interp);
  static Value intrinsic_set(Value args[], unsigned num_args,
                             const Location &loc, Interpreter *interp);
  static Value intrinsic_push(Value args[], unsigned num_args,
                              const Location &loc, Interpreter *interp);
  static Value intrinsic_pop(Value args[], unsigned num_args,
                             const Location &loc, Interpreter *interp);

private:
  // TODO: private member functions
  Value evaluate(const Node &node);
  Value evaluate(const Node &node, Environment *cur_env);
};

#endif // INTERP_H
