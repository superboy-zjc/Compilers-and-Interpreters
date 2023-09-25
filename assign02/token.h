#ifndef TOKEN_H
#define TOKEN_H

// This header file defines the tags used for tokens (i.e., terminal
// symbols in the grammar.)

enum TokenKind
{
  TOK_IDENTIFIER,
  TOK_INTEGER_LITERAL,
  TOK_PLUS,
  TOK_MINUS,
  TOK_TIMES,
  TOK_DIVIDE,
  TOK_LPAREN,
  TOK_RPAREN,
  TOK_SEMICOLON,
  // TODO: add members for additional kinds of tokens
  TOK_VAR,
  TOK_ASSIGN,
  TOK_OR,
  TOK_AND,
  TOK_LT,
  TOK_LEQ,
  TOK_GT,
  TOK_GEQ,
  TOK_EQ,
  TOK_NEQ,
  //
  TOK_FUNC,
  TOK_IF,
  TOK_ELSE,
  TOK_WHILE,
  TOK_LBRACE,
  TOK_RBRACE,
  TOK_COMMA,
  //
  TOK_ERROR
};

#endif // TOKEN_H
