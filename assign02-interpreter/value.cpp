#include "cpputil.h"
#include "exceptions.h"
#include "valrep.h"
#include "function.h"
#include "array.h"
#include "value.h"

Value::Value(int ival)
    : m_kind(VALUE_INT)
{
  m_atomic.ival = ival;
}

Value::Value(Function *fn)
    : m_kind(VALUE_FUNCTION), m_rep(fn)
{
  m_rep = fn;
}

Value::Value(Array *arr)
    : m_kind(VALUE_ARRAY), m_rep(arr)
{
  m_rep = arr;
}

Value::Value(IntrinsicFn intrinsic_fn)
    : m_kind(VALUE_INTRINSIC_FN)
{
  m_atomic.intrinsic_fn = intrinsic_fn;
}

Value::Value(const Value &other)
    : m_kind(VALUE_INT)
{
  // Just use the assignment operator to copy the other Value's data
  *this = other;
}

Value::~Value()
{
  // TODO: handle reference counting (detach from ValRep, if any)
}

Value &Value::operator=(const Value &rhs)
{
  if (this != &rhs &&
      !(is_dynamic() && rhs.is_dynamic() && m_rep == rhs.m_rep))
  {
    // TODO: handle reference counting (detach from previous ValRep, if any)
    m_kind = rhs.m_kind;
    if (is_dynamic())
    {
      // attach to rhs's dynamic representation
      m_rep = rhs.m_rep;
      // TODO: handle reference counting (attach to the new ValRep)
    }
    else
    {
      // copy rhs's atomic representation
      m_atomic = rhs.m_atomic;
    }
  }
  return *this;
}

Function *Value::get_function() const
{
  assert(m_kind == VALUE_FUNCTION);
  return m_rep->as_function();
}

Array *Value::get_array() const
{
  assert(m_kind == VALUE_ARRAY);
  return m_rep->as_array();
}

std::string Value::as_str() const
{
  switch (m_kind)
  {
  case VALUE_INT:
    return cpputil::format("%d", m_atomic.ival);
  case VALUE_FUNCTION:
    return cpputil::format("<function %s>", m_rep->as_function()->get_name().c_str());
  case VALUE_INTRINSIC_FN:
    return "<intrinsic function>";
  case VALUE_ARRAY:
  {
    std::string result = "[";
    for (int i = 0; i < m_rep->as_array()->get_length(); ++i)
    {
      result += std::to_string(m_rep->as_array()->get_member(i));
      if (i != m_rep->as_array()->get_length() - 1)
      { // if not the last element
        result += ", ";
      }
    }
    result += "]";
    return result;
  }
  default:
    // this should not happen
    RuntimeError::raise("Unknown value type %d", int(m_kind));
  }
}

// TODO: implementations of additional member functions
