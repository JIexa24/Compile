#include <stdio.h>
#include "./../include/hash.h"
#include "./../include/ast.h"

static int labelcount = 0;

int codeGen(struct ast* t) {

  /*strings print*/

  printf(".section .text\n");
  printf(".type main, @function\n");
  printf(".globl main\n\n");
  printf("main:\n\t");
  printf("pushq %%rbp\n\t");
  printf("movq %%rsp, %%rbp\n\t");

  /*generate*/

  printf("popq %%rbp\n\t");
  printf("ret\n");

  return 0;
}
