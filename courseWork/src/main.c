#include "../include/hash.h"
#include <stdio.h>

extern FILE *yyin;
extern int yylineno;
extern int ch;
extern char *yytext;
extern void yyparse();
/*file descriptor in|out*/
static int fdi = -1;
static int fdo = -1;
struct listnode* hashtab[HASHTAB_SIZE];
FILE *fileout;

int main(int argc, char **argv)
{
  int i = 0;
  char *tmp;
  char outfilename[256];
  printf("Arguments count: %d\n\n", argc);
  if(argc < 2) {
    printf("Not enough arguments. Please specify filename. \n");
    return 1;
  }
  for (i = 1; i < argc; ++i) {
    if (strcmp("-o", argv[i]) == 0) {
      if (i + 1 >= argc) {
        printf("Expected output file name. Please specify filename. \n");
        return 1;
      }
      fdo = ++i;
    }
    if (i != fdo && (i != (fdo - 1))) {
      fdi = i;
    }
  }

  if (fdi == -1) {
    printf("Expected input file name. Please specify filename. \n");
    return -1;
  }

  if (fdo == -1) {
    strcpy(outfilename, argv[fdi]);
    for (i = strlen(outfilename); i >= 0; --i) {
      if (outfilename[i] == '.') {
        outfilename[i + 1] = 's';
        outfilename[i + 2] = 0;
        break;
      }
    }
  } else {
    strcpy(outfilename, argv[fdo]);
  }

  tmp = strchr(argv[fdi], '.');
  if (strcmp(tmp, ".c") != 0) {
    printf("Format input file unknown\n");
    return 1;
  }


  tmp = strchr(outfilename, '.');
  if (strcmp(tmp, ".s") != 0) {
    printf("Format output file unknown\n");
    return 1;
  }

  printf("File descriptors:\nin: %d\nout: %d\n\n", fdi, fdo);
  printf("File names:\nin: %s\nout: %s\n\n",
        argv[fdi], fdo == -1 ? outfilename : argv[fdo]);
  if((yyin = fopen(argv[fdi], "r")) == NULL) {
    printf("Cannot open file %s.\n", argv[fdi]);
    return 1;
  }
  if (fdo != -1) {
    if((fileout = fopen(argv[fdo], "w")) == NULL) {
      printf("Cannot open file %s.\n", argv[fdo]);
      return 1;
    }
  } else {
    if((fileout = fopen("a.out", "w")) == NULL) {
      printf("Cannot open file a.out.\n");
      return 1;
    }
  }

  ch = 1;
  yylineno = 1;
  hashtab_init(hashtab);
  yyparse();

  fclose(fileout);
  return 0;
}
