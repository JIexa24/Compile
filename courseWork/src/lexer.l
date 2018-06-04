
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
%x COMM
%%

"/*" { ch += yyleng; BEGIN COMM; }
<COMM>. { ch += yyleng; continue; }
<COMM>\n { ch += yyleng; continue; }
<COMM>"*/" { ch += yyleng; BEGIN INITIAL; }
<COMM><<EOF>> { ch += yyleng; yyerror("Unterminated comment"); BEGIN INITIAL; }
\/\/(.)*(\n|$) { ch += yyleng; }

";" {
  yylval.str = strdup(yytext);
  return SEMCOL;
}
"+" {
  yylval.str = strdup(yytext);
  return PLUS;
}
"-" {
  yylval.str = strdup(yytext);
  return MINUS;
}
"*" {
  yylval.str = strdup(yytext);
  return MUL;
}
"/" {
  yylval.str = strdup(yytext);
  return DIV;
}
"%" {
  yylval.str = strdup(yytext);
  return MOD;
}
"&" {
  yylval.str = strdup(yytext);
  return AND;
}
"|" {
  yylval.str = strdup(yytext);
  return OR;
}
"^" {
  yylval.str = strdup(yytext);
  return XOR;
}
"!" {
  yylval.str = strdup(yytext);
  return NO;
}
"~" {
  yylval.str = strdup(yytext);
  return NOT;
}
"(" {
  yylval.str = strdup(yytext);
  return LB;
}
")" {
  yylval.str = strdup(yytext);
  return RB;
}
"{" {
  yylval.str = strdup(yytext);
  return LF;
}
"}" {
  yylval.str = strdup(yytext);
  return RF;
}
"<" {
  yylval.str = strdup(yytext);
  return LOW;
}
">" {
  yylval.str = strdup(yytext);
  return BIG;
}
"==" {
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

"int"|"float" {
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

"then" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return THEN;
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

"print" {
	//printf("KEYWORD (%d, %d): %s\n", yylineno, ch, yytext);
 	ch += yyleng;
  yylval.str = strdup(yytext);
  return PRINT;
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
