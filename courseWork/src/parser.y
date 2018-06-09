%{
  #include <stdio.h>
  #include "./../include/hash.h"
  #include "./../include/ast.h"
  extern FILE *yyin;
  extern int yylineno;
  extern int ch;
  extern char *yytext;
  extern struct listnode* hashtab[];
  extern int yylex();
  void yyerror(char *);
  int errcount = 0;
  int var_counter = 0;
%}

%union {
  char *str;
  struct ast* ast_tree;
}

%token <str> IF THEN ELSE WHILE DO ID RETURN PRINT SCAN MAIN
%token <str> TYPEVAR
%token <str> INUM DNUM
%token <str> ASSIGN
%token <str> CMP
%token <str> SEMCOL SPACE LOW BIG EQ PLUS MINUS MUL DIV MOD AND OR XOR LB RB NOT NO LF RF
%type <str> CONST
%type <ast_tree> EXPR1 EXPR2 VAR COND WHILELOOP BODY STATE START STATELIST ID_TOK
%type <ast_tree> IFF IN OUT ID_TOK1 RET PROG DEFVAR DEFVAR1 DEFVAR2 EXPR EXPR0
%type <ast_tree> FUNC

%%

PROG: FUNC {
  if (errcount > 0)
    yyerror("Err~");
  else {
    //print_ast($1, 0);
    codeGen($1);
    free_ast($1);
    hashtab_print(hashtab);
  }
};

FUNC: TYPEVAR MAIN LB RB LF START RF {$$ = $6;}

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
  if (tmpast->type == P_CONST_T) {
    tmphash->num = atoi(tmpast->key);
  }
  $$ = ast_createNode(P_DEF_T, $1, $4, $2, NULL);
};

/*v = 5 + b;*/
DEFVAR1: ID_TOK1 ASSIGN EXPR SEMCOL {
  struct ast* tmpast = $1;
  struct listnode* tmphash = hashtab_lookup(hashtab, tmpast->key);
  tmpast = $3;
  if (tmpast->type == P_CONST_T) {
    tmphash->num = atoi(tmpast->key);
  }
  $$ = ast_createNode(P_DEF1_T, $2, $3, $1, NULL);
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

RET: RETURN CONST SEMCOL {$$ = ast_createNode(P_RET_T, $2, NULL, NULL, NULL);}
BODY: STATE
      | STATELIST;

STATELIST: STATE BODY;

WHILELOOP: WHILE LB COND RB LF BODY RF {
  $$ = ast_createNode(P_WHILE_T, $1, $3, $6, NULL);
}
           | WHILE LB COND RB STATE {
  $$ = ast_createNode(P_WHILE_T, $1, $3, $5, NULL);
};

COND:  VAR {$$ = $1;}
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
  $$ = ast_createNode(P_CONST_T, $1, NULL, NULL, NULL);
}
        | ID_TOK1 {
  $$ = $1;
};

CONST:  INUM
        | DNUM;

%%
void yyerror(char *errmsg)
{
  fprintf(stderr, "Error: %s (%d, %d): %s\n", errmsg, yylineno, ch, yytext);
}
