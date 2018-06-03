%{
  #include <stdio.h>
  #include "./../include/ast.h"
  extern FILE *yyin;
  extern int yylineno;
  extern int ch;
  extern char *yytext;
	extern int yylex();
	void yyerror(char *);
  int errcount = 0;
%}

%union {
    char *str;
    struct ast *ast_tree;
}

%token IF THEN ELSE WHILE DO ID
%token TYPEVAR
%token INUM DNUM
%token ASSIGN
%token CMP
%token NEWLINE SEMCOL SPACE LOW BIG EQ PLUS MINUS MUL DIV MOD AND OR XOR LB RB NOT NO LF RF

%%

START: START STATE {struct ast* tmp = $1; tmp->m = $2;}
       | STATE {$$ = $1;};

STATE: error SEMCOL;

STATE: DEFVAR { printf("\ndef0\n");}
       | DEFVAR1 { printf("\ndef1\n");}
       | DEFVAR2  { printf("\ndef2\n");}
       | WHILELOOP  { printf("\nwhileloop\n");}
       | NEWLINE  { printf("\nnl\n");};

/*int v = 5 + b;*/
DEFVAR: TYPEVAR ID_TOK ASSIGN EXPR SEMCOL;

/*v = 5 + b;*/
DEFVAR1: ID_TOK ASSIGN EXPR SEMCOL;

EXPR: EXPR0
      | EXPR0 AND EXPR
      | EXPR0 XOR EXPR
      | EXPR0 OR EXPR;

EXPR0:   EXPR1
        | EXPR1 PLUS EXPR0
        | EXPR1 MINUS EXPR0;

EXPR1:  EXPR2
        | EXPR2 MUL EXPR1
        | EXPR2 DIV EXPR1
        | EXPR2 MOD EXPR1;

EXPR2:  VAR
        | LB EXPR RB
        | NOT EXPR
        | NO EXPR;

/*int v;*/
DEFVAR2: TYPEVAR ID SEMCOL;

BODY: LF STATELIST RF
      | STATE;

STATELIST: STATE
           | STATE BODY;

WHILELOOP: WHILE LB COND RB BODY {$$ = ast_createNode(P_WHILE_T, NULL, $3, $5, NULL);};

COND:  VAR {$$ = ast_createNode(P_COND_T, NULL, $1, NULL, NULL)}
       | VAR LOW COND {$$ = ast_createNode(P_COND_T, strdub("<"), $3, $1, NULL);}
       | VAR BIG COND {$$ = ast_createNode(P_COND_T, strdub(">"), $3, $1, NULL);}
       | VAR EQ COND {$$ = ast_createNode(P_COND_T, strdub("=="), $3, $1, NULL);};

VAR:    CONST
        | ID_TOK;

ID_TOK: ID;

CONST:  INUM
        | DNUM;

%%
void yyerror(char *errmsg)
{
	fprintf(stderr, "%s (%d, %d): %s\n", errmsg, yylineno, ch, yytext);
}
