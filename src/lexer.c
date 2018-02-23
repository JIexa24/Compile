#include "../include/compile.h"

extern char operator_list[operator_size][buffer_size];
extern char lexem_list[lexem_size][buffer_size];
token_t* tokens;
static int fd = 0;
static char ch = ' ';
static int token_counter = 0;
static char error_msg[buffer_size];

void open_fd(char* filename) {
  if ((fd = open(filename, O_RDONLY)) == -1) {
    sprintf(error_msg, "Can't open file : %s\nRead from stdin", filename);
    lexer_error(error_msg);
    fd = 0;
  }
}

void close_fd() {
  if (fd != 0) {
    close(fd);
  }
}

int get_ch() {
//  scanf("%c", &ch);
  return read(fd, &ch, 1);
}

int is_digit() {
  if (('0' <= ch) && (ch <= '9')) {
    return 1;
  } else return 0;
}

int is_space() {
  if (ch == ' ') return 1;
  else return 0;
}

int is_nl() {
  if (ch == '\n') return 1;
  else return 0;
}

int is_char() {
  if (('a' <= ch) && (ch <= 'z') || ('A' <= ch) && (ch <= 'Z')) {
    return 1;
  } else return 0;
}

int search_operator(char* ident) {
  int i;
  for (i = 0; i < operator_size; ++i) {
    if (!strcmp(operator_list[i], ident)) {
      return i;
    }
  }
  return -1;
}

int search_lexem(char* ident) {
  int i = 0;
  for (i = 0; i < lexem_size; ++i) {
    if (!strcmp(lexem_list[i], ident)) {
      return i;
    }
  }
  return -1;
}

int next_token() {
  double value = 0;
  int position_ident = 0;
  int i = -1;
  int j = 0;
  int expform = 0;
  int expradix = 0;
  int type = NONE_T;
  char signexp = '+';
  char tmp = '\0';
  char* identifier = (char*)malloc(buffer_size * sizeof(char));

  ch = ' ';

  while (type == NONE_T) {
    i = -1;
    j = 0;
    expform = 0;
    position_ident = 0;
    identifier[position_ident] = '\0';
    value = 0;

    if (ch == '\0' || ch == EOF/*EOF*/) {
      type = EOF_T;
      break;
    } else if (is_space() || is_nl()) {
      if (get_ch() == 0) type = EOF_T;
      continue;
    } else if (is_digit()) {
      while (is_digit() || ch == 'E' || ch =='e' || ch == '-' || ch == '+') {
        identifier[position_ident++] = ch;
        if (ch == 'E' || ch =='e'){
          expform = 1;
          get_ch();
          continue;
        }
        if (expform == 0) {
          value = value * 10 + (ch - '0');
        } else {
          if (ch == '-' || ch == '+') {
            signexp = ch;
          } else {
            expradix = expradix * 10 + (ch - '0');
          }
        }
        get_ch();
      }
      expradix = (signexp == '-') ? (-expradix) : expradix;
      identifier[position_ident] = '\0';
      value = value * pow(10, expradix);
      type = NUM_T;
    } else if (is_char()) {
      while (is_char() || is_digit()) {
        identifier[position_ident++] = ch;
        get_ch();
      }
      identifier[position_ident] = '\0';
      /*Search in Lexems*/
      if ((i = search_lexem(identifier)) != -1) {
        type = LEXEM_T;
      } else {
        type = IDENT_T;
      }
    } else if ((is_char() == 0) && (is_digit() == 0) && (is_nl() == 0)) {
      position_ident = 0;
      while ((is_char() == 0) && (is_digit() == 0 && is_space() == 0) && (is_nl() == 0)) {
        identifier[position_ident++] = ch;
        get_ch();
      }
      identifier[position_ident] = '\0';
      /*Search in Operators*/
      if (position_ident <= 1) {
        if ((i = search_operator(identifier)) != -1) {
          type = OP_T;
//          fprintf(stdout, "[op : %s]\n", operator_list[i]);
          tokens = list_addend(tokens, type, value, operator_list[i], i, NOT_ID);
        } else {
          sprintf(error_msg, "Unknown operator: %s", identifier);
          lexer_msg(error_msg);
          type = EOF_T;
       }
      } else if (position_ident > 1) {
        while (j < position_ident) {
          tmp = identifier[j + 2];
          identifier[j + 2] = '\0';
          if ((i = search_operator((&identifier[j]))) != -1) {
            j = j + 2;
            identifier[j] = tmp;
            type = OP_T;
//            fprintf(stdout, "[op : %s]\n", operator_list[i]);
            tokens = list_addend(tokens, type, value, operator_list[i], i, NOT_ID);
            continue;
          }

          identifier[j + 2] = tmp;
          tmp = identifier[j + 1];
          identifier[j + 1] = '\0';
          if ((i = search_operator((&identifier[j]))) != -1) {
            j = j + 1;
            identifier[j] = tmp;
            type = OP_T;
//            fprintf(stdout, "[op : %s]\n", operator_list[i]);
            tokens = list_addend(tokens, type, value, operator_list[i], i, NOT_ID);
            continue;
          }
          sprintf(error_msg, "Unknown operator: %s", identifier);
          lexer_msg(error_msg);
          type = EOF_T;
        }
      }
    } else {
      sprintf(error_msg, "Unknown symbol: %c", ch);
      lexer_error(error_msg);
      get_ch();
    }
    if (type == OP_T) {

    } else if (type == LEXEM_T) {
//      fprintf(stdout, "[lexem : %s]\n", identifier);
      tokens = list_addend(tokens, type, value, identifier, i, token_counter++);
    } else if (type == NUM_T) {
//      fprintf(stdout, "[num : %d]\n", value);
      tokens = list_addend(tokens, type, value, identifier, NOT_ID, NOT_ID);
    } else if (type == IDENT_T) {
//      fprintf(stdout, "[id : %s]\n", identifier);
      tokens = list_addend(tokens, type, value, identifier, NOT_ID, token_counter++);
    }

    if (ch != '\n') {
    //      fprintf(stdout, "[ch : %c]\n", ch);
    } else {
    //  fprintf(stdout, "[newline]\n");
    }

    if (ch != ' ') {
      type = NONE_T;
    }
  }
  return type;
}

void lexer() {
  int type = NONE_T;
  while (type != EOF_T) {
    printf("--------------------------------\n");
    type = next_token();
  }
  list_print(tokens);
}
