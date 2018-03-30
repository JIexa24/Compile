#ifndef PARSER_H
#define PARSER_H

#define parser_error(msg) fprintf(stderr, "\E[31mParser error\E[39m: %s\n", msg)
#define parser_msg(msg) fprintf(stdout, "\E[32mParser message\E[39m: %s\n", msg)

#define P_PROGRAMM_T 0
#define P_WHILE_T 1
#define P_COMPARE_T 2

typedef struct parser_node_s {
  int type_node;
  double value;
  struct parser_node_s* op1;
  struct parser_node_s* op2;
  struct parser_node_s* op3;  // for ELSE?
} parser_node_t;

void parser();

void parser_next_token();

parser_node_t* parse_parent();

parser_node_t* parse_expr();

parser_node_t* parse_brace();

parser_node_t* parsing();

#endif
