#include "../include/hash.h"
#include <stdio.h>

extern FILE *yyin;
extern int yylineno;
extern int ch;
extern char *yytext;
extern void yyparse();
struct listnode* hashtab[HASHTAB_SIZE];

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
  yylineno = 1;
  hashtab_init(hashtab);
  hashtab_add(hashtab, "ab", 67);
  hashtab_add(hashtab, "ab", 66);
  yyparse();
  return 0;
}
