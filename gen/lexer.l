
%option noyywrap yylineno

%{
#include <stdio.h>
#include <string.h>
#include "hash.h"
#include "y.tab.h"
extern void yyerror (char *);

int ch;
int value = 10;
%}

DIGIT[0-9]
LETTER[a-zA-Z]
DELIM[();{},:]
WS[ \t]
ID ("_"|{LETTER})("_"|{LETTER}|{DIGIT})*
OPER [-+*/<>|?!%=~]
SIGN [-+]

%%

"\n" return NEWLINE;
";" return SEMCOL;
"+" return PLUS;
"-" return MINUS;
"*" return MUL;
"/" return DIV;
"%" return MOD;
"&" return AND;
"|" return OR;
"^" return XOR;
"!" return NO;
"~" return NOT;
"(" return LB;
")" return RB;
"{" return LF;
"}" return RF;
"<" return LOW;
">" return BIG;
"==" return EQ;

{SIGN}?{DIGIT}+ {
    ch += yyleng;
    yylval = atoi(yytext);
    //printf("INT NUM (%d, %d): %s %d\n", yylineno, ch, yytext, yylval);
    return INUM;
}

{SIGN}?({DIGIT}+\.{DIGIT}+|{DIGIT}+\.|{DIGIT}+)([eE]{SIGN}?{DIGIT}+)? {
    ch += yyleng;
    //printf("DOUBLE NUM (%d, %d): %s\n", yylineno, ch, yytext);
    return DNUM;
}

"int" {
	//printf("KEYWORD_INT (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return INT;
}

"double" {
	//printf("KEYWORD_DOUBLE (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return DOUBLE;
}

"do" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return DO;
}

"while" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return WHILE;
}

"if" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return IF;
}

"then" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return THEN;
}

"else" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return ELSE;
}

("_"|{LETTER})("_"|{LETTER}|{DIGIT})* {
	 //printf("IDENTIFIER (%d, %d): %s\n", yylineno, ch, yytext);
   hashtab_add(hashtab, yytext, value*ch);
	 ch += yyleng;
   return ID;
}

{OPER} {
	//printf("OPERATION (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
	return CMP;
}

":=" {
	//printf("OPERATION (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return ASSIGN;
}

{DELIM} {
	//printf("DELIMITER (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
}

{WS}+ {
	ch += yyleng;
}

. {
	printf("Unknown character (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
}
%%
