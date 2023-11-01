#ifndef LOCAL_STORAGE_ALLOCATION_H
#define LOCAL_STORAGE_ALLOCATION_H

#include "storage.h"
#include "ast_visitor.h"
#include "exceptions.h"

class LocalStorageAllocation : public ASTVisitor
{
public:
  // vr0 is the return value vreg
  static const int VREG_RETVAL = 0;

  // vr1 is 1st argument vreg
  static const int VREG_FIRST_ARG = 1;

  // local variable allocation starts at vr10
  static const int VREG_FIRST_LOCAL = 10;

private:
  StorageCalculator m_storage_calc;
  unsigned m_total_local_storage;
  int m_next_vreg;
  // assign04
  unsigned int m_next_local_vreg = VREG_FIRST_LOCAL;
  unsigned int m_next_arg_vreg = VREG_FIRST_ARG;
  struct vreg m_vregs;

public:
  LocalStorageAllocation();
  virtual ~LocalStorageAllocation();

  virtual void visit_declarator_list(Node *n);
  virtual void visit_function_definition(Node *n);
  virtual void visit_function_declaration(Node *n);
  virtual void visit_function_parameter(Node *n);
  virtual void visit_statement_list(Node *n);
  virtual void visit_struct_type_definition(Node *n);
  virtual void visit_unary_expression(Node *n);

private:
  // TODO: add private member functions
  // assign04
  unsigned get_next_local_vreg()
  {
    return m_next_local_vreg++;
  };

  struct vreg get_cur_vreg()
  {
    m_vregs.m_arg_vreg = m_next_arg_vreg;
    m_vregs.m_local_vreg = m_next_local_vreg;
    return m_vregs;
  };
  void set_cur_vreg(struct vreg vregs)
  {
    m_next_arg_vreg = vregs.m_arg_vreg;
    m_next_local_vreg = vregs.m_local_vreg;
  };

  unsigned get_next_arg_vreg()
  {
    if (m_next_arg_vreg < 10)
    {
      return m_next_arg_vreg++;
    }
    else
    {
      RuntimeError::raise("arg vreg overflow!");
    }
  };
  //
};

#endif // LOCAL_STORAGE_ALLOCATION_H
