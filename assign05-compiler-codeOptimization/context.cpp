// Copyright (c) 2021-2022, David H. Hovemeyer <david.hovemeyer@gmail.com>
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

#include <set>
#include <memory>
#include <algorithm>
#include <iterator>
#include <cassert>
#include "exceptions.h"
#include "node.h"
#include "ast.h"
#include "parse.tab.h"
#include "lex.yy.h"
#include "parser_state.h"
#include "semantic_analysis.h"
#include "symtab.h"
#include "highlevel_codegen.h"
#include "local_storage_allocation.h"
#include "lowlevel_codegen.h"
#include "context.h"
#include "cfg_transform.h"

namespace
{
  const int BYTE = 0;
  const int WORD = 1;
  const int DWORD = 2;
  const int QUAD = 3;

  // names of machine registers for the 8 bit, 16 bit,
  // 32 bit, and 64 bit sizes
  const char *mreg_operand_names[][4] = {
      {"al", "ax", "eax", "rax"},
      {"bl", "bx", "ebx", "rbx"},
      {"cl", "cx", "ecx", "rcx"},
      {"dl", "dx", "edx", "rdx"},
      {"sil", "si", "esi", "rsi"},
      {"dil", "di", "edi", "rdi"},
      {"spl", "sp", "esp", "rsp"},
      {"bpl", "bp", "ebp", "rbp"},
      {"r8b", "r8w", "r8d", "r8"},
      {"r9b", "r9w", "r9d", "r9"},
      {"r10b", "r10w", "r10d", "r10"},
      {"r11b", "r11w", "r11d", "r11"},
      {"r12b", "r12w", "r12d", "r12"},
      {"r13b", "r13w", "r13d", "r13"},
      {"r14b", "r14w", "r14d", "r14"},
      {"r15b", "r15w", "r15d", "r15"},
  };

  const int num_mregs = sizeof(mreg_operand_names) / sizeof(mreg_operand_names[0]);

  std::string format_reg(int regnum, int size)
  {
    assert(regnum >= 0 && regnum < num_mregs);
    assert(size >= BYTE && size <= QUAD);
    return std::string("%") + mreg_operand_names[regnum][size];
  }
}
std::string find_var(std::map<std::string, StorageLoc> locs, int vreg)
{
  for (const auto &pair : locs)
  {
    if (pair.second.loc == StorageType::VREG && pair.second.offset == vreg)
    {
      std::string s = pair.first;
      return s;
    }
  }
  RuntimeError::raise("not eee\n");
}
Context::Context()
    : m_ast(nullptr)
{
}

Context::~Context()
{
  delete m_ast;
}

struct CloseFile
{
  void operator()(FILE *in)
  {
    if (in != nullptr)
    {
      fclose(in);
    }
  }
};

namespace
{

  template <typename Fn>
  void process_source_file(const std::string &filename, Fn fn)
  {
    // open the input source file
    std::unique_ptr<FILE, CloseFile> in(fopen(filename.c_str(), "r"));
    if (!in)
    {
      RuntimeError::raise("Couldn't open '%s'", filename.c_str());
    }

    // create an initialize ParserState; note that its destructor
    // will take responsibility for cleaning up the lexer state
    std::unique_ptr<ParserState> pp(new ParserState);
    pp->cur_loc = Location(filename, 1, 1);

    // prepare the lexer
    yylex_init(&pp->scan_info);
    yyset_in(in.get(), pp->scan_info);

    // make the ParserState available from the lexer state
    yyset_extra(pp.get(), pp->scan_info);

    // use the ParserState to either scan tokens or parse the input
    // to build an AST
    fn(pp.get());
  }

}

void Context::scan_tokens(const std::string &filename, std::vector<Node *> &tokens)
{
  auto callback = [&](ParserState *pp)
  {
    YYSTYPE yylval;

    // the lexer will store pointers to all of the allocated
    // token objects in the ParserState, so all we need to do
    // is call yylex() until we reach the end of the input
    while (yylex(&yylval, pp->scan_info) != 0)
      ;

    std::copy(pp->tokens.begin(), pp->tokens.end(), std::back_inserter(tokens));
  };

  process_source_file(filename, callback);
}

void Context::parse(const std::string &filename)
{
  auto callback = [&](ParserState *pp)
  {
    // parse the input source code
    yyparse(pp);

    // free memory allocated by flex
    yylex_destroy(pp->scan_info);

    m_ast = pp->parse_tree;

    // delete any Nodes that were created by the lexer,
    // but weren't incorporated into the parse tree
    std::set<Node *> tree_nodes;
    m_ast->preorder([&tree_nodes](Node *n)
                    { tree_nodes.insert(n); });
    for (auto i = pp->tokens.begin(); i != pp->tokens.end(); ++i)
    {
      if (tree_nodes.count(*i) == 0)
      {
        delete *i;
      }
    }
  };

  process_source_file(filename, callback);
}

void Context::analyze()
{
  assert(m_ast != nullptr);
  m_sema.visit(m_ast);
}

void Context::highlevel_codegen(ModuleCollector *module_collector, bool optimize)
{
  // Assign
  //   - vreg numbers to parameters
  //   - local storage offsets to local variables requiring storage in
  //     memory
  //
  // This will also determine the total local storage requirements
  // for each function.
  //
  // Any local variable not assigned storage in memory will be allocated
  // a vreg as its storage.
  LocalStorageAllocation local_storage_alloc;
  local_storage_alloc.visit(m_ast);

  // find all of the string constants in the AST
  //       and call the ModuleCollector's collect_string_constant
  //       member function for each one
  collect_string_constants(m_ast, module_collector);

  // collect all of the global variables
  SymbolTable *globals = m_sema.get_global_symtab();
  for (auto i = globals->cbegin(); i != globals->cend(); ++i)
  {
    Symbol *sym = *i;
    if (sym->get_kind() == SymbolKind::VARIABLE)
      module_collector->collect_global_var(sym->get_name(), sym->get_type());
  }

  // generating high-level code for each function, and then send the
  // generated high-level InstructionSequence to the ModuleCollector
  int next_label_num = 0;
  for (auto i = m_ast->cbegin(); i != m_ast->cend(); ++i)
  {
    Node *child = *i;
    if (child->get_tag() == AST_FUNCTION_DEFINITION)
    {
      HighLevelCodegen hl_codegen(next_label_num, optimize);
      hl_codegen.visit(child);
      std::string fn_name = child->get_kid(1)->get_str();
      std::shared_ptr<InstructionSequence> hl_iseq = hl_codegen.get_hl_iseq();

      // if optimized
      std::shared_ptr<InstructionSequence> cur_hl_iseq(hl_iseq);
      if (optimize)
      {
        // High-level optimizations
        // Create a control-flow graph representation of the high-level code
        HighLevelControlFlowGraphBuilder hl_cfg_builder(cur_hl_iseq);
        std::shared_ptr<ControlFlowGraph> cfg = hl_cfg_builder.build();

        // Do local optimizations
        for (int opt_time = 0; opt_time < 5; opt_time++)
        {
          LVNOptimizationHighLevel hl_opts(cfg);
          cfg = hl_opts.transform_cfg();

          // dead store elimination optimization
          DeadStoreElimination dse_opts(cfg);
          cfg = dse_opts.transform_cfg();
        }
        // Local Register Allocation
        LocalRegisterAllocation lra_opts(cfg, child);
        cfg = lra_opts.transform_cfg();

        // Convert thetransformed high-level CFG back to an InstructionSequence
        cur_hl_iseq = cfg->create_instruction_sequence();
      }
      // print the local variable storage location
      std::map<std::string, StorageLoc> locs = child->get_var_storage_map();
      for (auto it = locs.begin(); it != locs.end(); ++it)
      {
        if (it->second.loc == StorageType::MEM)
          printf("/* variable '%s' allocated at memory offset %d */\n", it->first.c_str(), it->second.offset);
        else if (it->second.loc == StorageType::VREG)
        {
          printf("/* variable '%s' allocated vreg %d */\n", it->first.c_str(), it->second.offset);
        }
      }
      const std::vector<LocalRegMatching>
          local_rank_list = child->get_local_rank_list();
      for (const auto &element : local_rank_list)
      {
        printf("/* allocate machine register %s for variable '%s' (v%d), which rank is %d */\n", format_reg(element.reg, QUAD).c_str(), find_var(locs, element.vreg).c_str(), element.vreg, element.rank);
      }

      // store a pointer to the function definition AST in the
      // high-level InstructionSequence: this is useful in case information
      // about the function definition is needed by the low-level
      // code generator
      cur_hl_iseq->set_funcdef_ast(child);

      module_collector->collect_function(fn_name, cur_hl_iseq);

      // make sure local label numbers are not reused between functions
      next_label_num = hl_codegen.get_next_label_num();
    }
  }
}
// collect all the string constants from AST nodes
void Context::collect_string_constants(Node *node, ModuleCollector *module_collector)
{
  if (node == nullptr)
  {
    return;
  }
  if (node->get_tag() == AST_LITERAL_VALUE && node->get_kid(0)->get_tag() == TOK_STR_LIT)
  {
    LiteralValue string = node->get_literal_value();
    std::string next_label = get_next_constant_label();
    module_collector->collect_string_constant(next_label, encodeString(string.get_str_value()));
    node->set_string_constant_label(next_label);
  }
  for (auto i = node->cbegin(); i != node->cend(); ++i)
  {
    Node *n = *i;
    collect_string_constants(n, module_collector);
  }
}

namespace
{

  // ModuleCollector implementation which generates low-level code
  // from generated high-level code, and then forwards the generated
  // low-level code to a delegate.
  class LowLevelCodeGenModuleCollector : public ModuleCollector
  {
  private:
    ModuleCollector *m_delegate;
    bool m_optimize;

  public:
    LowLevelCodeGenModuleCollector(ModuleCollector *delegate, bool optimize);
    virtual ~LowLevelCodeGenModuleCollector();

    virtual void collect_string_constant(const std::string &name, const std::string &strval);
    virtual void collect_global_var(const std::string &name, const std::shared_ptr<Type> &type);
    virtual void collect_function(const std::string &name, const std::shared_ptr<InstructionSequence> &iseq);
  };

  LowLevelCodeGenModuleCollector::LowLevelCodeGenModuleCollector(ModuleCollector *delegate, bool optimize)
      : m_delegate(delegate), m_optimize(optimize)
  {
  }

  LowLevelCodeGenModuleCollector::~LowLevelCodeGenModuleCollector()
  {
  }

  void LowLevelCodeGenModuleCollector::collect_string_constant(const std::string &name, const std::string &strval)
  {
    m_delegate->collect_string_constant(name, strval);
  }

  void LowLevelCodeGenModuleCollector::collect_global_var(const std::string &name, const std::shared_ptr<Type> &type)
  {
    m_delegate->collect_global_var(name, type);
  }

  void LowLevelCodeGenModuleCollector::collect_function(const std::string &name, const std::shared_ptr<InstructionSequence> &iseq)
  {
    LowLevelCodeGen ll_codegen(m_optimize);

    // translate high-level code to low-level code
    std::shared_ptr<InstructionSequence> ll_iseq = ll_codegen.generate(iseq);

    // send the low-level code on to the delegate (i.e., print the code)
    m_delegate->collect_function(name, ll_iseq);
  }

}

void Context::lowlevel_codegen(ModuleCollector *module_collector, bool optimize)
{
  LowLevelCodeGenModuleCollector ll_codegen_module_collector(module_collector, optimize);
  highlevel_codegen(&ll_codegen_module_collector, optimize);
}
