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

%token <str> IF THEN ELSE WHILE DO ID RETURN PRINT
%token <str> TYPEVAR
%token <str> INUM DNUM
%token <str> ASSIGN
%token <str> CMP
%token <str> SEMCOL SPACE LOW BIG EQ PLUS MINUS MUL DIV MOD AND OR XOR LB RB NOT NO LF RF
%type <str> CONST
%type <ast_tree> OUT ID_TOK1 RET PROG DEFVAR DEFVAR1 DEFVAR2 EXPR EXPR0 EXPR1 EXPR2 VAR COND WHILELOOP BODY STATE START STATELIST ID_TOK
%%

PROG: START {
  if (errcount > 0)
    yyerror("Err~");
  else {
    print_ast($1, 0);
    codeGen($1);
    free_ast($1);
  	hashtab_print(hashtab);
  }
};

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

OUT: PRINT VAR SEMCOL {
  $$ = ast_createNode(P_OUT_T, $1, $2, NULL, NULL);
};

/*int v = 5 + b;*/
DEFVAR: TYPEVAR ID_TOK ASSIGN EXPR SEMCOL {
  struct ast* tmpast = $2;
  struct listnode* tmphash = hashtab_lookup(hashtab, tmpast->key);
  tmphash->type = !strcmp($1, "int") ? 0 : 1;
  $$ = ast_createNode(P_DEF_T, $1, $4, $2, NULL);
};

/*v = 5 + b;*/
DEFVAR1: ID_TOK1 ASSIGN EXPR SEMCOL {
  $$ = ast_createNode(P_DEF1_T, $2, $3, $1, NULL);
};

EXPR: EXPR0 {$$ = $1;}
      | EXPR0 AND EXPR {$$ = NULL;}
      | EXPR0 XOR EXPR {$$ = NULL;}
      | EXPR0 OR EXPR {$$ = NULL;};

EXPR0:   EXPR1 {$$ = $1;}
        | EXPR1 PLUS EXPR0 {$$ = ast_createNode(P_OP_T, $2, $1, $3, NULL);}
        | EXPR1 MINUS EXPR0 ;

EXPR1:  EXPR2 {$$ = $1;}
        | EXPR2 MUL EXPR1
        | EXPR2 DIV EXPR1
        | EXPR2 MOD EXPR1;

EXPR2:  VAR {$$ = $1;}
        | LB EXPR RB {}
        | NOT EXPR {}
        | NO EXPR {};

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
       | VAR LOW COND {
  $$ = ast_createNode(P_COND_T, $2, $3, $1, NULL);
}
       | VAR BIG COND {
  $$ = ast_createNode(P_COND_T, $2, $3, $1, NULL);
}
       | VAR EQ COND {
  $$ = ast_createNode(P_COND_T, $2, $3, $1, NULL);
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
  $$ = ast_createNode(P_ID_T, $1, NULL, NULL, NULL);
};

VAR:    CONST {
  $$ = ast_createNode(P_CONST_T, $1, NULL, NULL, NULL);
}
        | ID {
  $$ = ast_createNode(P_VAR_T, $1, NULL, NULL, NULL);
};

CONST:  INUM
        | DNUM;

%%
void yyerror(char *errmsg)
{
	fprintf(stderr, "Error: %s (%d, %d): %s\n", errmsg, yylineno, ch, yytext);
}
