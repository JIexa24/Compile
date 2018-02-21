#ifndef LEXER_H
#define LEXER_H

#define lexer_error(msg) fprintf(stderr, "\E[31mLexer error\E[39m: %s\n", msg)
#define lexer_msg(msg) fprintf(stdout, "\E[32mLexer message\E[39m: %s\n", msg)
#define print_ch(ch) fprintf(stdout, "[symb : %c]\n", ch)

#define  EOF_T  0
#define  NONE_T 1
#define  NUM_T  2
#define  OP_T   3
#define  IDENT_T   4
#define  LEXEM_T   5

#define  lexem_size 3
#define  operator_size 15
#define  buffer_size 100

#define NOT_ID -1

typedef struct token_s {
  int type_token;
  double value;
  int id;
  struct token_s *next;
  char identifier[buffer_size];
} token_t;

void open_fd(char* filename);

void close_fd();

int get_ch();

int is_digit();

int is_char();

int is_space();

int is_nl();

int search_operator();

int search_lexem(char* ident);

int next_token();

void lexer();

#endif
