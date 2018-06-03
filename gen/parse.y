%{
	#include <stdio.h>
	extern FILE *yyin;
	extern int yylineno;
	extern int ch;
	extern char *yytext;
	void yyerror(char *);
	struct listnode *hashtab;
	struct tree* head;
%}

%token IF THEN ELSE WHILE DO ID
%token INT DOUBLE
%token INUM DNUM
%token ASSIGN
%token CMP
%token NEWLINE SEMCOL SPACE LOW BIG EQ PLUS MINUS MUL DIV MOD AND OR XOR LB RB NOT NO LF RF

%%

START: START STATE | STATE;

STATE: error SEMCOL;

STATE: DEFVAR { printf("\ndef0\n");}
       | DEFVAR1 { printf("\ndef1\n");}
       | UNDEFVAR  { printf("\ndef2\n");}
       | WHILELOOP  { printf("\nwhileloop\n");}
       | NEWLINE  { printf("\nnl\n");};

DEFVAR: TYPE ID_TOK ASSIG EXPR SEMCOL;

DEFVAR1: ID_TOK ASSIG EXPR SEMCOL;

ASSIG: ASSIGN;

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

UNDEFVAR: TYPE ID;

BODY: STATELIST;

STATELIST: STATE
           | STATE BODY;

WHILELOOP: WHIL LB COND RB LF BODY RF;

WHIL: WHILE;

COND:  VAR
       | VAR LOW COND
       | VAR BIG COND
       | VAR EQ COND

VAR:    CONST
        | ID_TOK;

ID_TOK: ID;

CONST:  INUM
        | DNUM;

TYPE: INT
      | DOUBLE;

%%
void yyerror(char *errmsg)
{
	fprintf(stderr, "%s (%d, %d): %s\n", errmsg, yylineno, ch, yytext);
}

int main(int argc, char **argv)
{
	if(argc < 2) {
		printf("\nNot enough arguments. Please specify filename. \n");
		return -1;
	}
	if((yyin = fopen(argv[1], "r")) == NULL) {
		printf("\nCannot open file %s.\n", argv[1]);
		return -1;
	}
	ch = 1;
	head = (struct tree*)malloc(sizeof(head));
	yylineno = 1;
	hashtab_init(&hashtab);
	yyparse();
	hashtab_print(&hashtab);
	return 0;
}
