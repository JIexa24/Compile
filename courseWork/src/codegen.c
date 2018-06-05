#include <stdio.h>
#include "./../include/hash.h"
#include "./../include/ast.h"

extern struct listnode* hashtab[];
extern int var_counter;
static int labelcount = 0;
static int exprLoad = 0;
static int stackOffset = 0;

static void gen(struct ast* t);
static void genExpr(struct ast* t);
static void genCond(struct ast* t, int inv, int label);

int codeGen(struct ast* t) {
  stackOffset = var_counter * 4 + 8;
  /*strings print*/
//-------------GENERATE ASM-------------
  printf("\t.section .rodata\n");
  printf("INT:\n\t.string \"%%d\"\n");
  printf("INTN:\n\t.string \"%%d\\n\"\n");
  printf("\t.text\n");
  printf("\t.globl main\n");
  printf("\t.type main, @function\n\n");
  printf("main:\n\t");
  printf("pushq %%rbp\n\t");
  printf("movq %%rsp, %%rbp\n\t");
  printf("subq $%d, %%rsp\n\t", stackOffset);
//------------------------------
  /*generate*/
  gen(t);
//------------------------------
  printf("\n");
//--------------------------------------
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
        printf("\n\t");
      break;
      case P_WHILE_T:
        printf("jmp .L%03d\n\t", labelcount + 2);
        printf("\r.L%03d:\n\t", ++labelcount);
        gen(t->middle);
        printf("\r.L%03d:\n\t", ++labelcount);
        genCond(t->left, 1, labelcount - 1);
        printf("\n\t");
      break;
      case P_IF_T:
        genCond(t->left, 0, labelcount + 1);
        gen(t->middle);
        printf("\r.L%03d:\n\t", ++labelcount);
        if (t->right != NULL) {
          genCond(t->left, 1, labelcount + 1);
          gen(t->right);
          printf("\r.L%03d:\n\t", ++labelcount);
        }
        printf("\n\t");
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
      case P_DEF2_T:
        tmp = hashtab_lookup(hashtab, t->left->key);
        if (tmp != NULL){
          printf("movl $0, %d(%%rbp)\n\t", -4*(tmp->value) - 4);
        }
      break;
      case P_OP_T:
        genExpr(t);
        exprLoad = 0;
      break;
      case P_RET_T:
          printf("addq $%d, %%rsp\n\t", stackOffset);
          if (t->left == NULL)
          printf("movl $%s, %%eax\n\t", t->key);
          printf("popq %%rbp\n\t");
          printf("ret\n\t");
      break;
      case P_OUT_T:
          tmp = hashtab_lookup(hashtab, t->left->key);
          if (tmp != NULL) {
            printf("movl $0, %%eax\n\t");
            if (tmp->type == 0)
            printf("movl $INTN, %%edi\n\t");
            printf("xorq %%rsi, %%rsi\n\t");
            printf("movq %d(%%rbp), %%rsi\n\t", -4*(tmp->value) - 4);
            printf("call printf\n\t");
            printf("\n\t");
          }
      break;
      case P_IN_T:
          tmp = hashtab_lookup(hashtab, t->left->key);
          if (tmp != NULL) {
            if (tmp->type == 0)
            printf("leaq %d(%%rbp), %%rax\n\t", -4*(tmp->value) - 4);
            printf("movq %%rax, %%rsi\n\t");
            printf("movl $INT, %%edi\n\t");
            printf("movl $0, %%eax\n\t");
            printf("call __isoc99_scanf\n\t");
            printf("\n\t");
          }
      break;
      default: break;
    }
  }
}

static void genCond(struct ast* t, int inv, int label) {
  struct listnode* tmp1 = NULL;
  struct listnode* tmp2 = NULL;
  int invert = 0;
  if (t != NULL) {
    tmp1 = hashtab_lookup(hashtab, t->left->key);
    tmp2 = hashtab_lookup(hashtab, t->middle->key);
    if (tmp1 != NULL && tmp2 == NULL) {
      printf("cmpl $%s, %d(%%rbp)\n\t", t->middle->key,-4*(tmp1->value) - 4);
      invert = 1;
    } else if (tmp1 == NULL && tmp2 != NULL) {
      printf("cmpl $%s, %d(%%rbp)\n\t", t->left->key,-4*(tmp2->value) - 4);
      invert = 0;
    }
    switch (t->key[0]) {
      case '>':
        if (invert != inv )
        printf("jle .L%03d\n\t", label);
        else
        printf("jg .L%03d\n\t", label);
      break;
      case '<':
        if (invert != inv )
        printf("jns .L%03d\n\t", label);
        else
        printf("js .L%03d\n\t", label);
      break;
      case '=':
        if (inv == 0)
          printf("jne .L%03d\n\t", label);
        if (inv == 1)
          printf("je .L%03d\n\t", label);
      break;
    }
  }
}

static void genExpr(struct ast* t) {
  struct listnode* tmp = NULL;
  if (t != NULL) {
    genExpr(t->left);
    tmp = hashtab_lookup(hashtab, t->key);
    switch (t->type) {
      case P_ID_T:
      case P_CONST_T:
          if (exprLoad == 0) {
            printf("xorl %%eax, %%eax\n\t");
            if (tmp != NULL)
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
          case '-':
            if (tmp != NULL)
              printf("subl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              printf("subl $%s, %%eax\n\t", t->middle->key);
          break;
          case '*':
            if (tmp != NULL)
              printf("mull %d(%%rbp)6\n\t", -4*(tmp->value) - 4);
            else
              printf("mull $%s, %%eax\n\t", t->middle->key);
          break;
          case '/':
          case '%':
            if (tmp != NULL)
              printf("divl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              printf("divl $%s, %%eax\n\t", t->middle->key);
          break;
          case '&':
            if (tmp != NULL)
              printf("andl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              printf("andl $%s, %%eax\n\t", t->middle->key);
          break;
          case '|':
            if (tmp != NULL)
              printf("orl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              printf("orl $%s, %%eax\n\t", t->middle->key);
          break;
          case '^':
            if (tmp != NULL)
              printf("xorl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              printf("xorl $%s, %%eax\n\t", t->middle->key);
          break;
          case '!':
          case '~':
            tmp = hashtab_lookup(hashtab, t->left->key);
            if (tmp != NULL)
              printf("notl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              printf("notl $%s, %%eax\n\t", t->left->key);
          break;
        }
      break;
      default: break;
    }

  }
}
