#ifndef ENVIRONMENT_H
#define ENVIRONMENT_H

#include <cassert>
#include <map>
#include <string>
#include "value.h"

class Environment
{
private:
  Environment *m_parent;
  // TODO: representation of environment (map of names to values)
  std::map<std::string, Value> m_map;

  // copy constructor and assignment operator prohibited
  Environment(const Environment &);
  Environment &operator=(const Environment &);

  // Assignment1

public:
  Environment(Environment *parent = nullptr);
  ~Environment();

  // TODO: add member functions allowing lookup, definition, and assignment
  Value lookup(const std::string &name, const Location &loc) const;
  void define(const std::string &name, const Value &value, const Location &loc);
  void assign(const std::string &name, const Value &value, const Location &loc);
};

#endif // ENVIRONMENT_H
