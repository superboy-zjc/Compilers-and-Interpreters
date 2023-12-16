#include <cassert>
#include "node.h"
#include "symtab.h"
#include "local_storage_allocation.h"
#include "parse.tab.h"

LocalStorageAllocation::LocalStorageAllocation()
    : m_total_local_storage(0U), m_next_vreg(VREG_FIRST_LOCAL)
{
}

LocalStorageAllocation::~LocalStorageAllocation()
{
}

void LocalStorageAllocation::visit_declarator_list(Node *n)
{
  Symbol *cur_sym;
  for (auto i = n->cbegin(); i != n->cend(); ++i)
  {
    Node *declarator = *i;
    cur_sym = declarator->get_symbol();
    std::shared_ptr<Type> type = cur_sym->get_type();
    if (type->is_array())
    {
      // the storage location of array should be in the stack frame
      cur_sym->set_storage_type(StorageType::MEM);
      cur_sym->set_storage_location(m_storage_calc.add_field(type));
      // int a = cur_sym->get_symtab()->lookup_local(cur_sym->get_name())->get_storage_type();
      // printf("%d", a);
    }
    else if (type->is_struct())
    {
      // the storage location of array should be in the stack frame
      cur_sym->set_storage_type(StorageType::MEM);
      cur_sym->set_storage_location(m_storage_calc.add_field(type));
    }
    else
    {
      // others should be stored into a virtual register, e.g. intergal, pointers whose address has not been taken
      if (cur_sym->if_taken())
      {
        cur_sym->set_storage_type(StorageType::MEM);
        cur_sym->set_storage_location(m_storage_calc.add_field(type));
      }
      else
      {
        cur_sym->set_storage_type(StorageType::VREG);
        cur_sym->set_storage_location(get_next_local_vreg());
      }

      // used_local_vregs++;
    }
    // // store the total allocated memory size for each variable
    // m_storage_calc.finish();
    // n->get_symbol()->set_memory_storage_size(m_storage_calc.get_size());
    m_local_vreg_map[cur_sym->get_name()] = StorageLoc(cur_sym->get_storage_type(), cur_sym->get_storage_location());
    // printf("/* %s is stored in the %d, at the offset of %d */\n", cur_sym->get_name().c_str(), cur_sym->get_storage_type(), cur_sym->get_storage_location());
  }
}

void LocalStorageAllocation::visit_function_definition(Node *n)
{
  // save the storage status before entering into a new scope
  StorageCalculator saved_storage_status = m_storage_calc;
  // save the virtual registers before entering into a new scope
  struct vreg saved_vregs = get_cur_vreg();
  visit(n->get_kid(0));
  visit(n->get_kid(1));
  visit(n->get_kid(2));
  visit_children(n->get_kid(3));
  // store the total allocated memory size, as well as register status, for each block
  m_storage_calc.finish();
  unsigned size = m_storage_calc.get_size();
  n->set_memory_storage_size(size);
  n->set_cur_vreg(get_cur_vreg());
  // assign05, save virtual register status before assigning temporary vrs
  n->set_vreg_no_temp(get_cur_vreg());
  n->set_var_storage_map(m_local_vreg_map);
  m_local_vreg_map.clear();
  // recover  the virtual registers after exiting into a new scope
  set_cur_vreg(saved_vregs);
  // recover the storage status
  m_storage_calc = saved_storage_status;
}

void LocalStorageAllocation::visit_function_declaration(Node *n)
{
  // don't allocate storage for parameters in a function declaration

  // save the storage status before entering into a new scope
  StorageCalculator saved_storage_status = m_storage_calc;
  // save the virtual registers before entering into a new scope
  struct vreg saved_vregs = get_cur_vreg();
  // comment the visit_children function, because we don't have to allocate space for
  // function declaration
  // visit_children(n);
  //  recover  the virtual registers after exiting into a new scope
  set_cur_vreg(saved_vregs);
  // recover the storage status
  m_storage_calc = saved_storage_status;
}

void LocalStorageAllocation::visit_function_parameter(Node *n)
{
  Symbol *cur_sym;
  Node *declarator = n;
  cur_sym = declarator->get_symbol();
  std::shared_ptr<Type> type = cur_sym->get_type();
  if (type->is_array())
  {
    // the storage location of array should be in the stack frame
    cur_sym->set_storage_type(StorageType::MEM);
    cur_sym->set_storage_location(m_storage_calc.add_field(type));
    // int a = cur_sym->get_symtab()->lookup_local(cur_sym->get_name())->get_storage_type();
    // printf("%d", a);
  }
  else if (type->is_struct())
  {
    // the storage location of array should be in the stack frame
    cur_sym->set_storage_type(StorageType::MEM);
    cur_sym->set_storage_location(m_storage_calc.add_field(type));
  }
  else
  {
    // others should be stored into a virtual register, e.g. intergal, pointers whose address has not been taken
    cur_sym->set_storage_type(StorageType::VREG);
    cur_sym->set_storage_location(get_next_local_vreg());
  }
  m_local_vreg_map[cur_sym->get_name()] = StorageLoc(cur_sym->get_storage_type(), cur_sym->get_storage_location());

  // printf("/* %s is stored in the %d, at the offset of %d */ \n", cur_sym->get_name().c_str(), cur_sym->get_storage_type(), cur_sym->get_storage_location());
}

void LocalStorageAllocation::visit_statement_list(Node *n)
{
  // save the storage status before entering into a new scope
  StorageCalculator saved_storage_status = m_storage_calc;
  // save the virtual registers before entering into a new scope
  struct vreg saved_vregs = get_cur_vreg();
  visit_children(n);
  // store the total allocated memory size, as well as register status, for each block
  m_storage_calc.finish();
  unsigned size = m_storage_calc.get_size();
  n->set_memory_storage_size(size);
  n->set_cur_vreg(get_cur_vreg());
  // recover the virtual registers after exiting into a new scope
  set_cur_vreg(saved_vregs);
  // recover the storage status
  m_storage_calc = saved_storage_status;
}

void LocalStorageAllocation::visit_struct_type_definition(Node *n)
{
  // TODO: implement (if you are going to use this visitor to assign offsets for struct fields)
  Symbol *cur_sym = n->get_symbol();
  std::shared_ptr<Type> type = cur_sym->get_type();
  unsigned num_members = type->get_num_members();

  // add offset information of each field of struct type into member object
  StorageCalculator struct_fields;
  for (unsigned i = 0; i < num_members; i++)
  {
    const Member &mem = type->get_member(i);
    type->set_member_offset(i, struct_fields.add_field(mem.get_type()));
    printf("/*%s is stored, at the offset of %d */\n", mem.get_name().c_str(), mem.get_storage_offset());
  }
}

// implement private member functions
