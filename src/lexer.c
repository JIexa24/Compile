#include "../include/compile.h"

extern char operator_list[operator_size][buffer_size];
extern char lexem_list[lexem_size][buffer_size];
token_t* tokens;
static int token_counter = 0;
static int fd = 0;
static char ch = ' ';
static char error_msg[buffer_size];

static int get_ch() {
//  scanf("%c", &ch);
  int res = read(fd, &ch, 1);
  ch = (res == 0) ? -1 : ch; 
  return res;
}

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

int is_digit(char* sym) {
  if (('0' <= *sym) && (*sym <= '9')) {
    return 1;
  } else return 0;
}

int is_delim(char* sym) {
  if (*sym == '\n' || *sym == ' ' || *sym == '\t')
    return 1;
  else return 0;
}

int is_space(char* sym) {
  if (*sym == ' ') return 1;
  else return 0;
}

int is_nl(char* sym) {
  if (*sym == '\n') return 1;
  else return 0;
}

int is_char(char* sym) {
  if (('a' <= *sym) && (*sym <= 'z') || ('A' <= *sym) && (*sym <= 'Z')) {
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

int lexer_next_token() {
  double value = 0;
  int position_ident = 0;
  int i = -1;
  int j = 0;
  int expform = 0;
  int expradix = 0;
  int type = L_NONE_T;
  char signexp = '+';
  char signe = 0;
  char tmp = '\0';
  char* identifier = (char*)malloc(buffer_size * sizeof(char));

  ch = ' ';

  while (type == L_NONE_T) {
    i = -1;
    j = 0;
    expform = 0;
    expradix = 0;
    signexp = '+';
    signe = 0;
    position_ident = 0;
    identifier[position_ident] = '\0';
    value = 0;

    if (ch == '\0' || ch == EOF/*EOF*/) {
      type = L_EOF_T;
      break;
    } else if (is_delim(&ch) && type == L_NONE_T) {
      if (get_ch() == 0) type = L_EOF_T;
      continue;
    } else if (is_digit(&ch) && type == L_NONE_T) {
      while (is_digit(&ch) || ch == 'E' || ch =='e' || ch == '-' || ch == '+') {
        if ((ch == '+' || ch == '-') && expform == 0) {break;}
          identifier[position_ident++] = ch;
        if ((ch == 'E' || ch =='e') && expform == 0){ 
          expform = 1;
          get_ch();
          continue;
        }
        if (expform == 0) {
          value = value * 10 + (ch - '0');
        } else if (expform == 1) {
          if (ch == '-' || ch == '+' && signe == 0) {
            expform = 2;
            signe = 1;
            signexp = ch;
          }
        } else if (expform == 2) {
          expradix = expradix * 10 + (ch - '0');
        }
        get_ch();
      }
      expradix = (signexp == '-') ? (-expradix) : expradix;
      identifier[position_ident] = '\0';
      value = value * pow(10, expradix);
      type = L_NUM_T;
    } else if (is_char(&ch) && type == L_NONE_T) {
      while (is_char(&ch) || is_digit(&ch)) {
        identifier[position_ident++] = ch;
        get_ch();
      }
      identifier[position_ident] = '\0';
      /*Search in Lexems*/
      if ((i = search_lexem(identifier)) != -1) {
        type = L_LEXEM_T;
      } else {
        type = L_IDENT_T;
      }
    } else if ((is_char(&ch) == 0) && (is_digit(&ch) == 0) && (is_delim(&ch) == 0) && type == L_NONE_T) {
      position_ident = 0;
      while ((is_char(&ch) == 0) && (is_digit(&ch) == 0) && (is_delim(&ch) == 0)) {
        identifier[position_ident++] = ch;
        get_ch();
      }
      identifier[position_ident] = '\0';
      /*Search in Operators*/
      if (position_ident <= 1) {
        if ((i = search_operator(identifier)) != -1) {
          type = L_OP_T;
//          fprintf(stdout, "[op : %s]\n", operator_list[i]);
          tokens = list_lexer_addend(tokens, type, value, operator_list[i], i, NOT_ID);
        } else {
          sprintf(error_msg, "Unknown operator: %s", identifier);
          lexer_msg(error_msg);
          type = L_EOF_T;
       }
      } else if (position_ident > 1) {
        while (j < position_ident) {
          tmp = identifier[j + 2];
          identifier[j + 2] = '\0';
          if ((i = search_operator((&identifier[j]))) != -1) {
            j = j + 2;
            identifier[j] = tmp;
            type = L_OP_T;
//            fprintf(stdout, "[op : %s]\n", operator_list[i]);
            tokens = list_lexer_addend(tokens, type, value, operator_list[i], i, NOT_ID);
            continue;
          }

          identifier[j + 2] = tmp;
          tmp = identifier[j + 1];
          identifier[j + 1] = '\0';
          if ((i = search_operator((&identifier[j]))) != -1) {
            j = j + 1;
            identifier[j] = tmp;
            type = L_OP_T;
//            fprintf(stdout, "[op : %s]\n", operator_list[i]);
            tokens = list_lexer_addend(tokens, type, value, operator_list[i], i, NOT_ID);
            continue;
          }
          sprintf(error_msg, "Unknown operator: %s", identifier);
          lexer_msg(error_msg);
          type = L_EOF_T;
        }
      }
    } else {
      sprintf(error_msg, "Unknown symbol: %c", ch);
      lexer_error(error_msg);
      get_ch();
    }
    if (type == L_OP_T) {

    } else if (type == L_LEXEM_T) {
//      fprintf(stdout, "[lexem : %s]\n", identifier);
      tokens = list_lexer_addend(tokens, type, value, identifier, i, NOT_ID);
    } else if (type == L_NUM_T) {
//      fprintf(stdout, "[num : %d]\n", value);
      tokens = list_lexer_addend(tokens, type, value, identifier, NOT_ID, NOT_ID);
    } else if (type == L_IDENT_T) {
//      fprintf(stdout, "[id : %s]\n", identifier);
      tokens = list_lexer_addend(tokens, type, value, identifier, NOT_ID, token_counter++);
    }

    if (ch != '\n') {
    //  fprintf(stdout, "[ch : %c]\n", ch);
    //  fprintf(stdout, "[s : %d]\n", type);
    } else {
    // fprintf(stdout, "[newline]\n");
    }

    if (ch != ' ') {
      type = L_NONE_T;
    }
  }
  return type;
}

void lexer() {
  int type = L_NONE_T;
  while (type != L_EOF_T) {
//    printf("--------------------------------\n");
    type = lexer_next_token();
  }
  list_lexer_print(tokens);
}
