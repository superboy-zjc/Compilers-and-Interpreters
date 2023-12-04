// Copyright (c) 2021, David H. Hovemeyer <david.hovemeyer@gmail.com>
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#ifndef NODE_BASE_H
#define NODE_BASE_H

#include <memory>
#include "type.h"
#include "symtab.h"
#include "literal_value.h"
#include "operand.h"
#include <set>

// The Node class will inherit from this type, so you can use it
// to define any attributes and methods that Node objects should have
// (constant value, results of semantic analysis, code generation info,
// etc.)
struct vreg
{
  unsigned m_local_vreg;
  unsigned m_arg_vreg;
};

class NodeBase
{
private:
  // fields (pointer to Type, pointer to Symbol, etc.)
  std::shared_ptr<Type> m_type;
  // there is something weird happening when m_Symbol was not initialized.
  Symbol *m_symbol = nullptr;
  bool m_lvalue = true;

  // copy ctor and assignment operator not supported
  NodeBase(const NodeBase &);
  NodeBase &operator=(const NodeBase &);

  // assign04
  // used for every block
  unsigned int m_memory_storage_size;
  struct vreg m_vregs;
  LiteralValue m_value;
  Operand m_operand;

  // assign05
  struct vreg m_vregs_no_temp;
  std::set<MachineReg> m_caller_saved;

public:
  NodeBase();
  virtual ~NodeBase();

  // add member functions
  void set_symbol(Symbol *symbol);
  void set_type(const std::shared_ptr<Type> &type);
  bool has_symbol() const;
  Symbol *get_symbol() const;
  bool has_type() const;
  std::shared_ptr<Type> get_type() const;
  void set_lvalue(bool flag);
  bool if_lvalue();
  // assign04
  //  for calulating memory allocated for function definition
  unsigned int get_memory_storage_size() const
  {
    return m_memory_storage_size;
  };
  void set_memory_storage_size(unsigned memory_storage_size)
  {
    m_memory_storage_size = memory_storage_size;
  };

  // TODO: add private member functions
  // assign04

  struct vreg get_cur_vreg() const
  {
    return m_vregs;
  };

  void set_cur_vreg(struct vreg vregs)
  {
    m_vregs.m_arg_vreg = vregs.m_arg_vreg;
    m_vregs.m_local_vreg = vregs.m_local_vreg;
  };
  // assign05
  void set_vreg_no_temp(struct vreg vregs)
  {
    m_vregs_no_temp.m_arg_vreg = vregs.m_arg_vreg;
    m_vregs_no_temp.m_local_vreg = vregs.m_local_vreg;
  };
  // assign05
  struct vreg get_vreg_no_temp() const
  {
    return m_vregs_no_temp;
  };
  void insert_caller_save_list(MachineReg mreg)
  {
    m_caller_saved.insert(mreg);
  }
  const std::set<MachineReg> &get_caller_save_list()
  {
    return m_caller_saved;
  }
  // assign 04
  void
  set_literal_value(LiteralValue value)
  {
    m_value = value;
  };
  LiteralValue get_literal_value() const
  {
    return m_value;
  };
  // assign 04
  void set_operand(Operand operand)
  {
    m_operand = operand;
    // printf("operand type: %d\n", operand.get_kind());
  };
  Operand get_operand() const
  {
    return m_operand;
  };
  unsigned int get_nums_of_allocated_virtual_registers()
  {
    return m_vregs.m_local_vreg - 10;
  }
  unsigned int get_last_allocated_virtual_registers()
  {
    return m_vregs.m_local_vreg - 1;
  }
  // assign05
  unsigned int get_last_allocated_virtual_registers_no_temp()
  {
    // printf("no temp vregs: %d\n", m_vregs_no_temp.m_local_vreg - 1);
    return m_vregs_no_temp.m_local_vreg - 1;
  }
  void set_string_constant_label(std::string label_name);
};

#endif // NODE_BASE_H
