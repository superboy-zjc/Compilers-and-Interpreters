#include <cassert>
#include <map>
#include <string>
#include <memory>
#include "token.h"
#include "ast.h"
#include "exceptions.h"
#include "parser2.h"

////////////////////////////////////////////////////////////////////////
// Parser2 implementation
// This version of the parser builds an AST directly,
// rather than first building a parse tree.
////////////////////////////////////////////////////////////////////////

// This is the grammar (Unit is the start symbol):
//
// Unit -> Stmt
// Unit -> Stmt Unit
// Stmt -> E ;
// E -> T E'
// E' -> + T E'
// E' -> - T E'
// E' -> epsilon
// T -> F T'
// T' -> * F T'
// T' -> / F T'
// T' -> epsilon
// F -> number
// F -> ident
// F -> ( E )

// This is the new grammar the assignment should complete

// Unit → Stmt
// Unit → Stmt Unit

// Stmt → var ident ;
// Stmt → A ; *

// A → ident = A
// A → L
// L → R || R
// L → R && R
// L → R
// R → E < E
// R → E <= E
// R → E > E
// R → E >= E
// R → E == E
// R → E != E
// R → E

// E -> T E'
// E' -> + T E'
// E' -> - T E'
// E' -> epsilon
// T -> F T'
// T' -> * F T'
// T' -> / F T'
// T' -> epsilon
// F -> number
// F -> ident
// F -> ( A ) *

Parser2::Parser2(Lexer *lexer_to_adopt)
    : m_lexer(lexer_to_adopt), m_next(nullptr)
{
}

Parser2::~Parser2()
{
  delete m_lexer;
}

Node *Parser2::parse()
{
  return parse_Unit();
}
Node *Parser2::parse_Unit()
{
  // note that this function produces a "flattened" representation
  // of the unit

  std::unique_ptr<Node> unit(new Node(AST_UNIT));
  for (;;)
  {
    unit->append_kid(parse_Stmt());
    if (m_lexer->peek() == nullptr)
      break;
  }

  return unit.release();
}

Node *Parser2::parse_Stmt()
{
  // Stmt -> ^ E ;

  std::unique_ptr<Node> s(new Node(AST_STATEMENT));

  Node *next_tok = m_lexer->peek();
  if (next_tok == nullptr)
  {
    SyntaxError::raise(m_lexer->get_current_loc(), "Unexpected end of input looking for statement");
  }
  int next_tok_tag = next_tok->get_tag();
  if (next_tok_tag == TOK_VAR)
  {
    Node *next_next_tok = m_lexer->peek(2);
    if (next_tok == nullptr)
    {
      SyntaxError::raise(m_lexer->get_current_loc(), "Unexpected end of input looking for statement");
    }
    int next_next_tok_tag = next_next_tok->get_tag();
    if (next_next_tok_tag != TOK_IDENTIFIER)
    {
      SyntaxError::raise(next_next_tok->get_loc(), "Unexpected token '%s', parser2 118", next_next_tok->get_str().c_str());
    }

    // Stmt -> var ident ;

    // for var
    std::unique_ptr<Node> op(expect(static_cast<enum TokenKind>(next_tok_tag)));
    // for identifier
    std::unique_ptr<Node> tok(expect(static_cast<enum TokenKind>(next_next_tok_tag)));
    // identifier node of AST
    std::unique_ptr<Node> ast(new Node(AST_VARREF));
    ast->set_str(tok->get_str());
    ast->set_loc(tok->get_loc());
    // root
    ast.reset(new Node(AST_VARDEF, {ast.release()}));
    // copy source information from operator node
    ast->set_loc(op->get_loc());

    s->append_kid(ast.release());
    expect_and_discard(TOK_SEMICOLON);
    return s.release();
  }
  s->append_kid(parse_A());
  expect_and_discard(TOK_SEMICOLON);

  return s.release();
}

Node *Parser2::parse_E()
{
  // E -> ^ T E'

  // Get the AST corresponding to the term (T)
  Node *ast = parse_T();

  // Recursively continue the additive expression
  return parse_EPrime(ast);
}

// This function is passed the "current" portion of the AST
// that has been built so far for the additive expression.
Node *Parser2::parse_EPrime(Node *ast_)
{
  // E' -> ^ + T E'
  // E' -> ^ - T E'
  // E' -> ^ epsilon

  std::unique_ptr<Node> ast(ast_);

  // peek at next token
  Node *next_tok = m_lexer->peek();
  if (next_tok != nullptr)
  {
    int next_tok_tag = next_tok->get_tag();
    if (next_tok_tag == TOK_PLUS || next_tok_tag == TOK_MINUS)
    {
      // E' -> ^ + T E'
      // E' -> ^ - T E'
      std::unique_ptr<Node> op(expect(static_cast<enum TokenKind>(next_tok_tag)));

      // build AST for next term, incorporate into current AST
      Node *term_ast = parse_T();
      ast.reset(new Node(next_tok_tag == TOK_PLUS ? AST_ADD : AST_SUB, {ast.release(), term_ast}));

      // copy source information from operator node
      ast->set_loc(op->get_loc());

      // continue recursively
      return parse_EPrime(ast.release());
    }
  }

  // E' -> ^ epsilon
  // No more additive operators, so just return the completed AST
  return ast.release();
}

Node *Parser2::parse_T()
{
  // T -> F T'

  // Parse primary expression
  Node *ast = parse_F();

  // Recursively continue the multiplicative expression
  return parse_TPrime(ast);
}

Node *Parser2::parse_TPrime(Node *ast_)
{
  // T' -> ^ * F T'
  // T' -> ^ / F T'
  // T' -> ^ epsilon

  std::unique_ptr<Node> ast(ast_);

  // peek at next token
  Node *next_tok = m_lexer->peek();
  if (next_tok != nullptr)
  {
    int next_tok_tag = next_tok->get_tag();
    if (next_tok_tag == TOK_TIMES || next_tok_tag == TOK_DIVIDE)
    {
      // T' -> ^ * F T'
      // T' -> ^ / F T'
      std::unique_ptr<Node> op(expect(static_cast<enum TokenKind>(next_tok_tag)));

      // build AST for next primary expression, incorporate into current AST
      Node *primary_ast = parse_F();
      ast.reset(new Node(next_tok_tag == TOK_TIMES ? AST_MULTIPLY : AST_DIVIDE, {ast.release(), primary_ast}));

      // copy source information from operator node
      ast->set_loc(op->get_loc());

      // continue recursively
      return parse_TPrime(ast.release());
    }
  }

  // T' -> ^ epsilon
  // No more multiplicative operators, so just return the completed AST
  return ast.release();
}

Node *Parser2::parse_F()
{
  // F -> ^ number
  // F -> ^ ident
  // F -> ^ ( E )

  Node *next_tok = m_lexer->peek();
  if (next_tok == nullptr)
  {
    error_at_current_loc("Unexpected end of input looking for primary expression");
  }

  int tag = next_tok->get_tag();
  if (tag == TOK_INTEGER_LITERAL || tag == TOK_IDENTIFIER)
  {
    // F -> ^ number
    // F -> ^ ident
    std::unique_ptr<Node> tok(expect(static_cast<enum TokenKind>(tag)));
    int ast_tag = tag == TOK_INTEGER_LITERAL ? AST_INT_LITERAL : AST_VARREF;
    std::unique_ptr<Node> ast(new Node(ast_tag));
    ast->set_str(tok->get_str());
    ast->set_loc(tok->get_loc());
    return ast.release();
  }
  else if (tag == TOK_LPAREN)
  {
    // F -> ^ ( E )
    expect_and_discard(TOK_LPAREN);
    std::unique_ptr<Node> ast(parse_A());
    expect_and_discard(TOK_RPAREN);
    return ast.release();
  }
  else
  {
    SyntaxError::raise(next_tok->get_loc(), "Invalid primary expression");
  }
}

// Assignment 1
Node *Parser2::parse_A()
{
  // A → ident = A
  // A → L
  Node *next_tok = m_lexer->peek(1);
  if (next_tok == nullptr)
  {
    error_at_current_loc("Unexpected end of input looking for primary expression");
  }
  int next_tok_tag = next_tok->get_tag();

  Node *next_next_tok = m_lexer->peek(2);
  if (next_next_tok != nullptr)
  {
    int next_next_tok_tag = next_next_tok->get_tag();
    if (next_tok_tag == TOK_IDENTIFIER && next_next_tok_tag == TOK_ASSIGN)
    {
      std::unique_ptr<Node> tok(expect(static_cast<enum TokenKind>(next_tok_tag)));
      int ast_tag = AST_VARREF;
      std::unique_ptr<Node> ast(new Node(ast_tag));
      ast->set_str(tok->get_str());
      ast->set_loc(tok->get_loc());

      std::unique_ptr<Node> op(expect(static_cast<enum TokenKind>(next_next_tok_tag)));

      // build AST for next term, incorporate into current AST
      Node *term_ast = parse_A();
      ast.reset(new Node(AST_ASSIGN, {ast.release(), term_ast}));

      // copy source information from operator node
      ast->set_loc(op->get_loc());

      // continue recursively
      return ast.release();
    }
    // error_at_current_loc("Unexpected end of input looking for primary expression");
  }

  // Recursively continue the additive expression
  return parse_L();

  /*debug
  // std::unique_ptr<Node> number(new Node(AST_INT_LITERAL));
  // number->set_str("1");
  return parse_F();*/
}

Node *Parser2::parse_L()
{
  // L -> R || R
  // L -> R && R
  // L -> R
  std::unique_ptr<Node> ast(parse_R());
  // std::unique_ptr<Node> ast(ast_);
  //  peek at next token
  Node *next_tok = m_lexer->peek();
  if (next_tok != nullptr)
  {
    int next_tok_tag = next_tok->get_tag();
    if (next_tok_tag == TOK_OR || next_tok_tag == TOK_AND)
    {
      // L -> R || R
      // L -> R && R
      std::unique_ptr<Node> op(expect(static_cast<enum TokenKind>(next_tok_tag)));
      // build AST for next term, incorporate into current AST
      Node *term_ast = parse_R();
      ast.reset(new Node(next_tok_tag == TOK_OR ? AST_OR : AST_AND, {ast.release(), term_ast}));

      // copy source information from operator node
      ast->set_loc(op->get_loc());

      // continue recursively
      return ast.release();
    }
  }

  // E' -> ^ epsilon
  // No more additive operators, so just return the completed AST
  return ast.release();
}

Node *Parser2::parse_R()
{
  // R -> E < E
  // R -> E <= E
  // R -> E > E
  // R -> E >= E
  // R -> E == E
  // R -> E != E
  // R -> E
  std::unique_ptr<Node> ast(parse_E());
  // std::unique_ptr<Node> ast(ast_);
  //  peek at next token
  Node *next_tok = m_lexer->peek();
  if (next_tok != nullptr)
  {
    int next_tok_tag = next_tok->get_tag();
    if (next_tok_tag == TOK_LT || next_tok_tag == TOK_LEQ || next_tok_tag == TOK_GT || next_tok_tag == TOK_GEQ || next_tok_tag == TOK_EQ || next_tok_tag == TOK_NEQ)
    {
      // L -> R || R
      // L -> R && R
      std::unique_ptr<Node> op(expect(static_cast<enum TokenKind>(next_tok_tag)));
      // build AST for next term, incorporate into current AST
      Node *term_ast = parse_E();

      int ast_tok_tag = AST_LT;
      switch (next_tok_tag)
      {
      case TOK_LT:
        /* code */
        ast_tok_tag = AST_LT;
        break;
      case TOK_LEQ:
        ast_tok_tag = AST_LEQ;
        break;
      case TOK_GT:
        ast_tok_tag = AST_GT;
        break;
      case TOK_GEQ:
        ast_tok_tag = AST_GEQ;
        break;
      case TOK_EQ:
        ast_tok_tag = AST_EQ;
        break;
      case TOK_NEQ:
        ast_tok_tag = AST_NEQ;
        break;
      default:
        break;
      }

      ast.reset(new Node(ast_tok_tag, {ast.release(), term_ast}));

      // copy source information from operator node
      ast->set_loc(op->get_loc());

      // continue recursively
      return ast.release();
    }
  }

  // E' -> ^ epsilon
  // No more additive operators, so just return the completed AST
  return ast.release();
}

Node *Parser2::expect(enum TokenKind tok_kind)
{
  std::unique_ptr<Node> next_terminal(m_lexer->next());
  if (next_terminal->get_tag() != tok_kind)
  {
    SyntaxError::raise(next_terminal->get_loc(), "Unexpected token '%s'", next_terminal->get_str().c_str());
  }
  return next_terminal.release();
}

void Parser2::expect_and_discard(enum TokenKind tok_kind)
{
  Node *tok = expect(tok_kind);
  delete tok;
}

void Parser2::error_at_current_loc(const std::string &msg)
{
  SyntaxError::raise(m_lexer->get_current_loc(), "%s", msg.c_str());
}
