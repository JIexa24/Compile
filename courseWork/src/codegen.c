#include <stdio.h>
#include "./../include/hash.h"
#include "./../include/ast.h"

extern struct listnode* hashtab[];
static int labelcount = 0;
static int varcount = 0;
static int exprLoad = 0;
static int exprLastOpr = -1;
/*& ^ | + - * / % ! ~*/
static void gen(struct ast* t);
static void genExpr(struct ast* t);

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
      case P_DEF_T:
      case P_DEF1_T:
        gen(t->left);
        gen(t->middle);
      break;
      case P_ID_T:
        tmp = hashtab_lookup(hashtab, t->key);
        if (tmp != NULL){
          printf("movl %%eax, %d(%%rbp)\n\t", -4*(tmp->value) - 4);
        }
        tmp = NULL;
      break;
      case P_CONST_T:
        printf("movl $%s, %%eax\n\t", t->key);
      break;
      case P_OP_T:
        genExpr(t);
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
static void genExpr(struct ast* t) {
  struct listnode* tmp = NULL;
  int load = exprLoad;
  if (t != NULL) {
    tmp = hashtab_lookup(hashtab, t->key);
    genExpr(t->left);
    switch (t->type) {
      case P_VAR_T:
          if (exprLoad == 0) {
            printf("movl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            exprLoad = 1;
          }
      break;
      case P_OP_T:
        tmp = hashtab_lookup(hashtab, t->middle->key);
        switch (t->key[0]) {
          case '+':
            if (tmp != NULL)
              printf("addl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              printf("addl $%s, %%eax\n\t", t->middle->key);
          break;
        }
      break;
      default: break;
    }

  }
}
