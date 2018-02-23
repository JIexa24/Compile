#ifndef LEXER_H
#define LEXER_H

#define lexer_error(msg) fprintf(stderr, "\E[31mLexer error\E[39m: %s\n", msg)
#define lexer_msg(msg) fprintf(stdout, "\E[32mLexer message\E[39m: %s\n", msg)
#define print_ch(ch) fprintf(stdout, "[symb : %c]\n", ch)

#define  L_EOF_T  0
#define  L_NONE_T 1
#define  L_NUM_T  2
#define  L_OP_T   3
#define  L_IDENT_T   4
#define  L_LEXEM_T   5

#define  lexem_size 3
#define  operator_size 15
#define  buffer_size 100

#define NOT_ID -1

typedef struct token_s {
  int type_token;
  int id;
  int index;
  double value;
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

int lexer_next_token();

void lexer();

#endif
