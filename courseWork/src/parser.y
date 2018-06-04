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
%}

%union {
    char *str;
    struct ast* ast_tree;
}

%token <str> IF THEN ELSE WHILE DO ID
%token <str> TYPEVAR
%token <str> INUM DNUM
%token <str> ASSIGN
%token <str> CMP
%token <str> SEMCOL SPACE LOW BIG EQ PLUS MINUS MUL DIV MOD AND OR XOR LB RB NOT NO LF RF
%type <str> CONST
%type <ast_tree> PROG DEFVAR DEFVAR1 DEFVAR2 EXPR EXPR0 EXPR1 EXPR2 VAR COND WHILELOOP BODY STATE START STATELIST ID_TOK
%%

PROG: START {print_ast($1, 0);codeGen($1);free_ast($1);};

START: START STATE {$$ = ast_createNode(P_NODE_T, NULL, $2, $1, NULL);}
       | STATE {$$ = $1;};

STATE: error SEMCOL {errcount = errcount + 1;};

STATE: DEFVAR { printf("def0\n");$$ = $1;}
       | DEFVAR1 { printf("def1\n");$$ = $1;}
       | DEFVAR2  { printf("def2\n");}
       | WHILELOOP  { printf("whileloop\n");$$ = $1;}

/*int v = 5 + b;*/
DEFVAR: TYPEVAR ID_TOK ASSIGN EXPR SEMCOL {
  $$ = ast_createNode(P_DEF_T, $1, $2, $4, NULL);
};

/*v = 5 + b;*/
DEFVAR1: ID ASSIGN EXPR SEMCOL {
  $$ = ast_createNode(P_DEF1_T, $1, $3, NULL, NULL);
};

EXPR: EXPR0 {$$ = $1;}
      | EXPR0 AND EXPR {$$ = NULL;}
      | EXPR0 XOR EXPR {$$ = NULL;}
      | EXPR0 OR EXPR {$$ = NULL;};

EXPR0:   EXPR1 {$$ = $1;}
        | EXPR1 PLUS EXPR0
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
};

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
  hashtab_add(hashtab, $1, ch * 10);
  $$ = ast_createNode(P_VAR_T, $1, NULL, NULL, NULL);
};

VAR:    CONST {
  $$ = ast_createNode(P_VAR_T, $1, NULL, NULL, NULL);
}
        | ID {
  $$ = ast_createNode(P_VAR_T, $1, NULL, NULL, NULL);
};

CONST:  INUM
        | DNUM;

%%
void yyerror(char *errmsg)
{
	fprintf(stderr, "%s (%d, %d): %s\n", errmsg, yylineno, ch, yytext);
}
