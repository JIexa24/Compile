
%option noyywrap yylineno

%{
#include <stdio.h>
#include <string.h>
#include "./../include/hash.h"
#include "./../include/ast.h"
#include "./../include/parser.tab.h"
extern struct listnode* hashtab[];
extern void yyerror (char *);

int ch;
int value = 10;
%}

DIGIT[0-9]
LETTER[a-zA-Z]
DELIM[();{},:]
WS[ \n\t]
OPER [-+*/<>|?!%=~]
SIGN [-+]
CAW [']
%x COMM
%%

"/*" { ch += yyleng; BEGIN COMM; }
<COMM>. { ch += yyleng; continue; }
<COMM>\n { ch += yyleng; continue; }
<COMM>"*/" { ch += yyleng; BEGIN INITIAL; }
<COMM><<EOF>> { ch += yyleng; yyerror("Unterminated comment"); BEGIN INITIAL; }
\/\/(.)*(\n|$) { ch += yyleng; }

"main" {
  ch += yyleng;
  hashtab_add(hashtab, "main", 256);
  yylval.str = strdup(yytext);
  return MAIN;
}

{CAW}{LETTER}{CAW} {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return CNUM;
}

";" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return SEMCOL;
}
"+" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return PLUS;
}
"-" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return MINUS;
}
"*" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return MUL;
}
"&" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return AND;
}
"|" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return OR;
}
"^" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return XOR;
}
"!" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return NO;
}
"~" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return NOT;
}
"(" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return LB;
}
")" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return RB;
}
"{" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return LF;
}
"}" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return RF;
}
"<" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return LOW;
}
">" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return BIG;
}
"==" {
  ch += yyleng;
  yylval.str = strdup(yytext);
  return EQ;
}

{SIGN}?{DIGIT}+ {
  ch += yyleng;
  yylval.str = strdup(yytext);
  //yylval = atoi(yytext);
  //printf("INT NUM (%d, %d): %s %d\n", yylineno, ch, yytext, yylval);
  return INUM;
}

{SIGN}?({DIGIT}+\.{DIGIT}+|{DIGIT}+\.|{DIGIT}+)([eE]{SIGN}?{DIGIT}+)? {
  ch += yyleng;
  yylval.str = strdup(yytext);
  //printf("DOUBLE NUM (%d, %d): %s\n", yylineno, ch, yytext);
  return DNUM;
}

"int"|"char" {
	//printf("KEYWORD_TYPE (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return TYPEVAR;
}

"do" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return DO;
}

"while" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return WHILE;
}

"if" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return IF;
}

"else" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return ELSE;
}

"return" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return RETURN;
}

"write" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return PRINT;
}

"read" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return SCAN;
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
  yylval.str = strdup(yytext);
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
