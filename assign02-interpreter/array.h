#ifndef ARRAY_H
#define ARRAY_H

#include <vector>
#include <string>
#include "valrep.h"
class Environment;
class Node;

class Array : public ValRep
{
private:
  std::vector<int> m_array;

  // value semantics prohibited
  Array(const Array &);
  Array &operator=(const Array &);

public:
  Array(std::vector<int> array);
  virtual ~Array();

  int get_length() const { return m_array.size(); }
  int get_member(const int id) const { return m_array[id]; }
  void set_member(const int id, const int value) { m_array[id] = value; }
  void push(const int value) { m_array.push_back(value); }
  void pop() { m_array.pop_back(); }

  // Environment *get_parent_env() const { return m_parent_env; }
};

#endif // ARRAY_H
