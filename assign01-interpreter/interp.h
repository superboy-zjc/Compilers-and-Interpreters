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

private:
  // TODO: private member functions
  Value evaluate(const Node &node);
};

#endif // INTERP_H
