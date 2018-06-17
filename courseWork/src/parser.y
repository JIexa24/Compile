%{
  #include <stdio.h>
  #include "./../include/hash.h"
  #include "./../include/ast.h"
  extern FILE *yyin;
  extern int yylineno;
  extern int ch;
  extern char *yytext;
  extern int debuginfo;
  extern int optimization;

  extern struct listnode* hashtab[];
  extern int yylex();
  void yyerror(char *);
  int errcount = 0;
  int var_counter = 0;
  int return_col = 0;
%}

%union {
  char *str;
  struct ast* ast_tree;
}

%token <str> IF THEN ELSE WHILE DO ID RETURN PRINT SCAN MAIN DONE
%token <str> TYPEVAR
%token <str> INUM DNUM CNUM
%token <str> ASSIGN
%token <str> CMP
%token <str> SEMCOL LOW BIG EQ PLUS MINUS MUL DIV MOD AND OR XOR LB RB NOT NO LF RF
%type <str> CONST
%type <ast_tree> VAR COND  STATE START  ID_TOK BODY STATELIST WHILELOOP
%type <ast_tree> IFF  ID_TOK1 PROG DEFVAR DEFVAR1 DEFVAR2 EXPR

%%

PROG: START {
    if (debuginfo == 1) {
    print_ast($1, 0);
      hashtab_print(hashtab);
  }
  free_ast($1);

};

START: START STATE {$$ = ast_createNode(P_NODE_T, NULL, $1, $2, NULL);}
       | STATE {$$ = $1;};

STATE: error SEMCOL {errcount = errcount + 1;
  yyerror("Some error deteceted~");};

STATE: DEFVAR { $$ = $1; printf("-----");}
       | DEFVAR1 { $$ = $1;}
       | DEFVAR2 { $$ = $1;}
       | WHILELOOP { $$ = $1;}

WHILELOOP: WHILE COND LB BODY RB DONE SEMCOL {
  $$ = ast_createNode(P_WHILE_T, $1, $2, $4, NULL);
}

BODY: STATE {$$ = $1;}
      | STATELIST {$$ = $1;};

STATELIST: STATE BODY {$$ = ast_createNode(P_NODE_T, NULL, $1, $2, NULL);};

/*int v = 5 + b;*/
DEFVAR: TYPEVAR ID_TOK ASSIGN EXPR SEMCOL {
  struct ast* tmpast = $2;
  struct listnode* tmphash = hashtab_lookup(hashtab, tmpast->key);
  tmphash->type = !strcmp($1, "int") ? 0 : 1;
  tmpast = $4;
  if (tmpast->type == P_CONST_T || tmpast->type == P_CONSTC_T) {
    tmphash->num = atoi(tmpast->key);
  }
  if (optimization == 1) {
    optimize(tmpast);
  }
  $$ = ast_createNode(P_DEF_T, $1, tmpast, $2, NULL);
};

/*v = 5 + b;*/
DEFVAR1: ID_TOK1 ASSIGN EXPR SEMCOL {
  struct ast* tmpast = $1;
  struct listnode* tmphash = hashtab_lookup(hashtab, tmpast->key);
  tmpast = $3;
  tmphash->scan = 1;
  if (tmpast->type == P_CONST_T || tmpast->type == P_CONSTC_T) {
    tmphash->num = atoi(tmpast->key);
  }
  if (optimization == 1) {
    optimize(tmpast);
  }
  $$ = ast_createNode(P_DEF1_T, $2, tmpast, $1, NULL);
};

EXPR: VAR {$$ = $1;}

/*int v;*/
DEFVAR2: TYPEVAR ID_TOK SEMCOL {
  struct ast* tmpast = $2;
  struct listnode* tmphash = hashtab_lookup(hashtab, tmpast->key);
  tmphash->type = !strcmp($1, "int") ? 0 : (!strcmp($1, "char") ? 1 : 2);
  $$ = ast_createNode(P_DEF2_T, $1, $2, NULL, NULL);
};

COND:  VAR {
  struct ast* tmpast = ast_createNode(P_CONST_T, strdup("1"), NULL, NULL, NULL);
  $$ = ast_createNode(P_COND_T, strdup("=="), $1, tmpast, NULL);}
       | VAR LOW VAR {
  $$ = ast_createNode(P_COND_T, $2, $1, $3, NULL);
}
       | VAR BIG VAR {
  $$ = ast_createNode(P_COND_T, $2, $1, $3, NULL);
}
       | VAR EQ VAR {
  $$ = ast_createNode(P_COND_T, $2, $1, $3, NULL);
};

ID_TOK: ID {
  if (hashtab_lookup(hashtab, $1) != NULL){
    ++errcount;
    yyerror("Redefinition var~");
  }
  hashtab_add(hashtab, $1, var_counter++);
  $$ = ast_createNode(P_ID_T, $1, NULL, NULL, NULL);
};

ID_TOK1: ID {
  if (hashtab_lookup(hashtab, $1) == NULL){
    ++errcount;
    yyerror("Undefined var~");
  }
  $$ = ast_createNode(P_ID_T, $1, NULL, NULL, NULL);
};

VAR:    CONST {
  char *tmp = $1;
  if (tmp[0] == '\''){
    int n;
    char buf[256];
    if (tmp[1] == '\\'){
      if (tmp[2] == '0') {
        n = 0;
      } else if (tmp[2] == 'n') {
        n = 10;
      } else if (tmp[2] == 'r') {
        n = 13;
      } else if (tmp[2] == 'a') {
        n = 7;
      } else if (tmp[2] == 't') {
        n = 9;
      } else n = 0;
    } else {
      n = tmp[1] - '\0';
    }
    swriteInt(buf, n, 10, -1);
    $$ = ast_createNode(P_CONSTC_T, strdup(buf), NULL, NULL, NULL);
  }
  else
  $$ = ast_createNode(P_CONST_T, $1, NULL, NULL, NULL);
}
        | ID_TOK1 {
  $$ = $1;
};

CONST:  INUM
        | DNUM
        | CNUM;

%%
void yyerror(char *errmsg)
{
  fprintf(stderr, "Error: %s (%d, %d): %s\n", errmsg, yylineno, ch, yytext);
}
