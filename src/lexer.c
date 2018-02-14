#include "../include/compile.h"

extern char operator_list[12];
extern char lexem_list[3][100];
static int lexem_size = 3;
static int operator_size = 12;
static char ch = ' ';

void get_ch(int* k) {
  *k = read(0, &ch, 1);
}

int is_digit() {
  if (('0' <= ch) && (ch <= '9')) {
    return 1;
  } else return 0;
}

int is_char() {
  if (('a' <= ch) && (ch <= 'z')) {
    return 1;
  } else return 0;
}

int search_operator() {
  int i;
  for (i = 0; i < operator_size; ++i) {
//    printf("[cmp : %c %c]\n", operator_list[i], ch);
    if (ch == operator_list[i]) {
      return i;
    }
  }
  return -1;
}

int search_lexem(char* ident) {
  int i = 0;
  for (i = 0; i < lexem_size; ++i) {
//    printf("[strcmp : %s %s]\n", lexem_list[i], ident);
    if (!strcmp(lexem_list[i], ident)) {
      return i;
    }
  }
  return -1;
}

void next_token() {
  int value = 0;
  int position_ident = 0;
  int i = -1;
  int type = NONE_T;
  int count = -1;
  char* identifier = (char*)malloc(256 * sizeof(char));
  char* error_msg  = (char*)malloc(256 * sizeof(char));

  ch = ' ';

  while (type == NONE_T) {
    i = -1;
//    print_ch(ch);
    if (ch == '\0' || ch == '\n' || ch == EOF/*EOF*/) {
      type = EOF_T;
      break;
    } else if (ch == ' ') {
      get_ch(&count);
      continue;
    } else if (is_digit()) {
      value = 0;
      while (is_digit()) {
        value = value * 10 + (ch - '0');
        get_ch(&count);
      }
      type = NUM_T;
    } else if (is_char()) {
      position_ident = 0;
      while (is_char()) {
        identifier[position_ident++] = ch;
        get_ch(&count);
//        printf("[ident : %c]\n", identifier[position_ident - 1]);
      }
      identifier[position_ident] = '\0';
      /*Search in Lexems*/
      if ((i = search_lexem(identifier)) != -1) {
         type = ID_T;
      } else {
        sprintf(error_msg, "May be variable: %s", identifier);
        lexer_msg(error_msg);
        type = EOF_T;
      }
    } else if ((i = search_operator()) != -1) {
    /*Search in Operators*/
      type = OP_T;
      get_ch(&count);
    } else {
      sprintf(error_msg, "Unknown symbol: %c", ch);
      lexer_error(error_msg);
      type = EOF_T;
    }
    if (ch != '\n') {
//      fprintf(stdout, "[ch : %c]\n", ch);
    } else {
      fprintf(stdout, "[newline]\n");
    }
//    fprintf(stdout, "[type : %d]\n", type);
    if (type == OP_T) {
      fprintf(stdout, "[op : %c]\n", operator_list[i]);
    } else if (type == ID_T) {
      fprintf(stdout, "[id : %s]\n", lexem_list[i]);
    } else if (type == NUM_T) {
      fprintf(stdout, "[num : %d]\n", value);
    }

    if (ch != ' ') {
      type = NONE_T;
    }
  }
}

void lexer() {
  while (1) {
    printf("--------------------------------\n");
    next_token();
  }
}
