#include "environment.h"
#include "exceptions.h"

Environment::Environment(Environment *parent)
    : m_parent(parent)
{
  assert(m_parent != this);
}

Environment::~Environment()
{
}

// TODO: implement member functions

Value Environment::lookup(const std::string &name, const Location &loc) const
{
  auto it = m_map.find(name);
  if (it != m_map.end())
    return it->second;
  else if (m_parent)
    return m_parent->lookup(name, loc);
  else
    SemanticError::raise(loc, "Variable not defined: '%s'", name.c_str());
}

void Environment::define(const std::string &name, const Value &value, const Location &loc)
{
  m_map[name] = value;
}

void Environment::assign(const std::string &name, const Value &value, const Location &loc)
{
  if (m_map.find(name) != m_map.end())
    m_map[name] = value;
  else if (m_parent)
    m_parent->assign(name, value, loc);
  else
    SemanticError::raise(loc, "Variable not defined: '%s'", name.c_str());
}
