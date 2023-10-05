#include "environment.h"
#include "exceptions.h"
#include "function.h"
#include "array.h"

Environment::Environment(Environment *parent)
    : m_parent(parent)
{
  assert(m_parent != this);
}

Environment::~Environment()
{
  // manage reference count, delete object with zero reference count
  for (std::map<std::string, Value>::iterator it = m_map.begin(); it != m_map.end(); ++it)
  {
    switch (it->second.get_kind())
    {
    case VALUE_FUNCTION:
    {
      it->second.get_function()->remove_ref();
      if (it->second.get_function()->get_num_refs() == 0)
      {
        delete it->second.get_function();
      }
      break;
    }
    case VALUE_ARRAY:
    {
      it->second.get_array()->remove_ref();
      if (it->second.get_array()->get_num_refs() == 0)
      {
        delete it->second.get_array();
      }
      break;
    }

    default:
      break;
    }
  }
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
void Environment::define(const std::string &name, const Value &value)
{
  m_map[name] = value;
}

void Environment::define(const std::string &name, const Value &value, const Location &loc)
{
  auto it = m_map.find(name);
  if (it != m_map.end())
    SemanticError::raise(loc, "Variable defined duplicately: '%s'", name.c_str());
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

void Environment::clear()
{
  m_map.clear();
}
