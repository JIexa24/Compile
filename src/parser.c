#include "../include/compile.h"

extern token_t* tokens;
parser_node_t* nodes;
static token_t* cursor_tokens = NULL;

static parser_node_t* parser_createnode(int type, double value,
       parser_node_t* op1, parser_node_t* op2, parser_node_t* op3) {
  parser_node_t* p;
  p = (parser_node_t*)malloc(sizeof(p));
  if (p != NULL) {
    p->type_node = type;
    p->value = value;
    p->op1 = op1;
    p->op2 = op2;
    p->op3 = op3;
  }
  return p;
}

void parser_next_token() {
  if (cursor_tokens == NULL) cursor_tokens = tokens;
  else if (cursor_tokens->next != NULL) cursor_tokens = cursor_tokens->next;
  else parser_error("parser_next_token : end");
}

parser_node_t* parse_parent() {
  parser_node_t* p = NULL;
  if (strcmp(cursor_tokens->identifier, "(") != 0) {
    parser_error("While : Expected (");
  }
  parser_next_token();
  p = parse_expr();
  if (strcmp(cursor_tokens->identifier, ")") != 0) {
    parser_error("While : Expected )");
  }
  parser_next_token();
  return p;
}

parser_node_t* parse_expr() {
  parser_node_t* p = NULL;

  parser_next_token();
  return p;
}

parser_node_t* parse_brace() {
  parser_node_t* p = NULL;
  if (strcmp(cursor_tokens->identifier, "{") != 0) {
    parser_error("Expected {");
  }
  parser_next_token();
  p = parsing();
  if (strcmp(cursor_tokens->identifier, "}") != 0) {
    parser_error("Expected }");
  }
  parser_next_token();
  return p;
}

parser_node_t* parsing() {
  parser_node_t* p = NULL;
  if (cursor_tokens->type_token == L_LEXEM_T) {
    if (!strcmp(cursor_tokens->identifier, "while")) {
      p = parser_createnode(P_WHILE_T, 0, NULL, NULL, NULL);
      parser_next_token();
      p->op1 = parse_parent(); /* parse () */
      p->op2 = parse_brace();  /* parse {} */
    }
  }
  return p;
}

void parser() {
  nodes = parser_createnode(P_PROGRAMM_T, 0, parsing(), NULL, NULL);
}
