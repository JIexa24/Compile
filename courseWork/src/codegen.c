#include <stdio.h>
#include "./../include/hash.h"
#include "./../include/ast.h"

extern struct listnode* hashtab[];
static int labelcount = 0;
static int varcount = 0;
static void gen(struct ast* t);

int codeGen(struct ast* t) {

  /*strings print*/
  printf("-------------GENERATE ASM-------------\n");

  printf(".section .text\n");
  printf(".type main, @function\n");
  printf(".globl main\n\n");
  printf("main:\n\t");
  printf("pushq %%rbp\n\t");
  printf("movq %%rsp, %%rbp\n\t");
  printf("------------------------------\n\t");

  /*generate*/
  gen(t);
  printf("------------------------------\n\t");

  return 0;
}

static void gen(struct ast* t) {
  if (t != NULL) {

    struct listnode* tmp;
    switch (t->type) {
      case P_NODE_T:
        gen(t->left);
        gen(t->middle);
        break;
      case P_DEF_T:
        gen(t->left);
        gen(t->middle);
      break;
      case P_VAR_T:
        tmp = hashtab_lookup(hashtab, t->key);
        if (tmp != NULL){
          printf("movl %%eax, %d(%%rbp)\n\t", -4*(tmp->value) - 4);
        } else {
          printf("movl $%s, %%eax\n\t", t->key);
        }
      break;
      case P_RET_T:
          printf("mov $%s, %%eax\n\t", t->key);
          printf("popq %%rbp\n\t");
          printf("ret\n\t");
      break;
      default: break;
    }
  }

}
