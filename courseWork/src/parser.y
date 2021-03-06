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

%token <str> IF THEN ELSE WHILE DO ID RETURN PRINT SCAN MAIN
%token <str> TYPEVAR
%token <str> INUM DNUM CNUM
%token <str> ASSIGN
%token <str> CMP
%token <str> SEMCOL LOW BIG EQ PLUS MINUS MUL DIV MOD AND OR XOR LB RB NOT NO LF RF
%type <str> CONST
%type <ast_tree> EXPR1 EXPR2 VAR COND WHILELOOP BODY STATE START STATELIST ID_TOK
%type <ast_tree> IFF IN OUT ID_TOK1 RET PROG DEFVAR DEFVAR1 DEFVAR2 EXPR EXPR0
%type <ast_tree> FUNC

%%

PROG: FUNC {
  if (errcount > 0) {
    if (return_col == 0) {
      yyerror("Expected return");
    }
    yyerror("Err~");
  } else {
    //print_ast($1, 0);
    codeGen($1);
    free_ast($1);
    if (debuginfo == 1)
      hashtab_print(hashtab);
  }
};

FUNC: TYPEVAR MAIN LB RB LF START RET RF {$$ = ast_createNode(P_NODE_T, NULL, $6, $7, NULL);}
      | TYPEVAR MAIN LB RB LF RET RF {$$ = $6;}

START: START STATE {$$ = ast_createNode(P_NODE_T, NULL, $1, $2, NULL);}
       | STATE {$$ = $1;};

STATE: error SEMCOL {errcount = errcount + 1;
  yyerror("Some error deteceted~");};

STATE: DEFVAR { $$ = $1;}
       | DEFVAR1 { $$ = $1;}
       | DEFVAR2 { $$ = $1;}
       | WHILELOOP  { $$ = $1;}
       | RET { $$ = $1;}
       | OUT { $$ = $1;}
       | IN { $$ = $1;}
       | IFF { $$ = $1;}

IFF: IF LB COND RB LF BODY RF {
  $$ = ast_createNode(P_IF_T, $1, $3, $6, NULL);
}
     | IF LB COND RB LF BODY RF ELSE LF BODY RF {
  $$ = ast_createNode(P_IF_T, $1, $3, $6, $10);
}
     | IF LB COND RB LF BODY RF ELSE STATE {
  $$ = ast_createNode(P_IF_T, $1, $3, $6, $9);
}
     | IF LB COND RB STATE {
  $$ = ast_createNode(P_IF_T, $1, $3, $5, NULL);
}
     | IF LB COND RB STATE ELSE STATE {
  $$ = ast_createNode(P_IF_T, $1, $3, $5, $7);
}
     | IF LB COND RB STATE ELSE LF BODY RF {
  $$ = ast_createNode(P_IF_T, $1, $3, $5, $8);
}

OUT: PRINT LB VAR RB SEMCOL {
  $$ = ast_createNode(P_OUT_T, $1, $3, NULL, NULL);
};

IN: SCAN LB ID_TOK1 RB SEMCOL {
  struct ast* tmpast = $3;
  struct listnode* tmphash = hashtab_lookup(hashtab, tmpast->key);
  tmphash->scan = 1;
  $$ = ast_createNode(P_IN_T, $1, $3, NULL, NULL);
};

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

EXPR: EXPR0 {$$ = $1;}
      | EXPR0 AND EXPR {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);}
      | EXPR0 XOR EXPR {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);}
      | EXPR0 OR EXPR {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);};

EXPR0:   EXPR1 {$$ = $1;}
        | EXPR1 PLUS EXPR0 {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);}
        | EXPR1 MINUS EXPR0 {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);};

EXPR1:  EXPR2 {$$ = $1;}
        | EXPR2 MUL EXPR1 {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);}
        | EXPR2 DIV EXPR1 {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);}
        | EXPR2 MOD EXPR1 {$$ = ast_createNode(P_OP_T, $2, $3, $1, NULL);};

EXPR2:  VAR {$$ = $1;}
        | LB EXPR RB {$$ = $2;}
        | NOT EXPR {$$ = ast_createNode(P_OP_T, $1, $2, NULL, NULL);}
        | NO EXPR {$$ = ast_createNode(P_OP_T, $1, $2, NULL, NULL);};

/*int v;*/
DEFVAR2: TYPEVAR ID_TOK SEMCOL {
  struct ast* tmpast = $2;
  struct listnode* tmphash = hashtab_lookup(hashtab, tmpast->key);
  tmphash->type = !strcmp($1, "int") ? 0 : 1;
  $$ = ast_createNode(P_DEF2_T, $1, $2, NULL, NULL);
};

RET: RETURN CONST SEMCOL {
  $$ = ast_createNode(P_RET_T, $2, NULL, NULL, NULL);
  return_col++;
}
BODY: STATE {$$ = $1;}
      | STATELIST {$$ = $1;};

STATELIST: STATE BODY {$$ = ast_createNode(P_NODE_T, NULL, $1, $2, NULL);};

WHILELOOP: WHILE LB COND RB LF BODY RF {
  $$ = ast_createNode(P_WHILE_T, $1, $3, $6, NULL);
}
           | WHILE LB COND RB STATE {
  $$ = ast_createNode(P_WHILE_T, $1, $3, $5, NULL);
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
