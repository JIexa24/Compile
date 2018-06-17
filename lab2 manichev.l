
%option noyywrap yylineno

%{
#include <stdio.h>
#include <string.h>
extern void yyerror (char *);

int ch;
int value = 10;
%}

DIGIT[0-9]
LETTER[a-zA-Z]
DELIM[();{},:]
WS[ \n\t]
SP[ntabr]
OPER [-+*/<>|?!%=~]
SIGN [-+]
CAW [']
BCSL [\\]
%x COMM
%%

"<" {
    printf("DOUBLE NUM (%d, %d): %s\n", yylineno, ch, yytext);
  ch += yyleng;

}
">" {
  ch += yyleng;
    printf("DOUBLE NUM (%d, %d): %s\n", yylineno, ch, yytext);
}



{SIGN}?({DIGIT}+\.{DIGIT}+|{DIGIT}+\.|{DIGIT}+)([eE]{SIGN}?{DIGIT}+)? {
  ch += yyleng;
  printf("DOUBLE NUM (%d, %d): %s\n", yylineno, ch, yytext);
  //return DNUM;
}

"done" {
  ch += yyleng;
  	printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
}

":=" {
	printf("OPERATION (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  //return ASSIGN;
}

"while" {
	printf("OPERATION (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;

}

("_"|{LETTER})("_"|{LETTER}|{DIGIT})* {
	printf("IDENTIFIER (%d, %d): %s\n", yylineno, ch, yytext);
  //hashtab_add(hashtab, yytext, value*ch);
  //yylval.str = strdup(yytext);
	ch += yyleng;
//  return ID;
}

"=" {
	printf("OPERATION (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
//  return ROVNO;
}


. {
	printf("Unknown character (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
}

%%

void yyerror(char *errmsg)
{
  fprintf(stderr, "Error: %s (%d, %d): %s\n", errmsg, yylineno, ch, yytext);
}

int main(int argc, char **argv)
{
	if(argc < 2)
	{
		printf("\nNot enough arguments. Please specify filename.\n");
		return -1;
	}
	if((yyin = fopen(argv[1], "r")) == NULL)
	{
		printf("\nCannot open file %s.\n", argv[1]);
		return -1;
	}
	ch = 1;
	yylineno = 1;


	yylex();

	fclose(yyin);

	return 0;
}
