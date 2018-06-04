
%option noyywrap yylineno

%{
#include <stdio.h>
#include <string.h>
#include "./../include/hash.h"
#include "./../include/parser.tab.h"
extern void yyerror (char *);
extern struct listnode* hashtab[];

int ch;
int value = 10;
%}

DIGIT[0-9]
LETTER[a-zA-Z]
DELIM[();{},:]
WS[ \n\t]
OPER [-+*/<>|?!%=~]
SIGN [-+]

%%

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
    //yylval = atoi(yytext);
    //printf("INT NUM (%d, %d): %s %d\n", yylineno, ch, yytext, yylval);
    return INUM;
}

{SIGN}?({DIGIT}+\.{DIGIT}+|{DIGIT}+\.|{DIGIT}+)([eE]{SIGN}?{DIGIT}+)? {
    ch += yyleng;
    //printf("DOUBLE NUM (%d, %d): %s\n", yylineno, ch, yytext);
    return DNUM;
}

"int"|"double" {
	//printf("KEYWORD_TYPE (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  return TYPEVAR;
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
  //hashtab_add(hashtab, yytext, value*ch);
  yylval.str = strdup(yytext);
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
