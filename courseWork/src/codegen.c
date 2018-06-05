#include <stdio.h>
#include "./../include/hash.h"
#include "./../include/ast.h"

extern struct listnode* hashtab[];
extern int var_counter;
extern FILE* fileout;

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
  fprintf(fileout, "\t.section .rodata\n");
  fprintf(fileout, "INT:\n\t.string \"%%d\"\n");
  fprintf(fileout, "INTN:\n\t.string \"%%d\\n\"\n");
  fprintf(fileout, "\t.text\n");
  fprintf(fileout, "\t.globl main\n");
  fprintf(fileout, "\t.type main, @function\n\n");
  fprintf(fileout, "main:\n\t");
  fprintf(fileout, "pushq %%rbp\n\t");
  fprintf(fileout, "movq %%rsp, %%rbp\n\t");
  fprintf(fileout, "subq $%d, %%rsp\n\t", stackOffset);
//------------------------------
  /*generate*/
  gen(t);
//------------------------------
  fprintf(fileout, "\n");
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
        fprintf(fileout, "\n\t");
      break;
      case P_WHILE_T:
        fprintf(fileout, "jmp .L%03d\n", labelcount + 2);
        fprintf(fileout, "\r.L%03d:\n\t", ++labelcount);
        gen(t->middle);
        fprintf(fileout, "\r.L%03d:\n\t", ++labelcount);
        genCond(t->left, 1, labelcount - 1);
        fprintf(fileout, "\n\t");
      break;
      case P_IF_T:
        genCond(t->left, 0, labelcount + 1);
        gen(t->middle);
        fprintf(fileout, "\r.L%03d:\n\t", ++labelcount);
        if (t->right != NULL) {
          genCond(t->left, 1, labelcount + 1);
          gen(t->right);
          fprintf(fileout, "\r.L%03d:\n\t", ++labelcount);
        }
        fprintf(fileout, "\n\t");
      break;
      case P_ID_T:
        tmp = hashtab_lookup(hashtab, t->key);
        if (tmp != NULL){
          fprintf(fileout, "movl %%eax, %d(%%rbp)\n\t", -4*(tmp->value) - 4);
        }
        tmp = NULL;
      break;
      case P_CONST_T:
        fprintf(fileout, "movl $%s, %%eax\n\t", t->key);
      break;
      case P_DEF2_T:
        tmp = hashtab_lookup(hashtab, t->left->key);
        if (tmp != NULL){
          fprintf(fileout, "movl $0, %d(%%rbp)\n\t", -4*(tmp->value) - 4);
        }
      break;
      case P_OP_T:
        genExpr(t);
        exprLoad = 0;
      break;
      case P_RET_T:
          fprintf(fileout, "addq $%d, %%rsp\n\t", stackOffset);
          if (t->left == NULL)
          fprintf(fileout, "movl $%s, %%eax\n\t", t->key);
          fprintf(fileout, "popq %%rbp\n\t");
          fprintf(fileout, "ret\n\t");
      break;
      case P_OUT_T:
          tmp = hashtab_lookup(hashtab, t->left->key);
          if (tmp != NULL) {
            fprintf(fileout, "movl $0, %%eax\n\t");
            if (tmp->type == 0)
            fprintf(fileout, "movl $INTN, %%edi\n\t");
            fprintf(fileout, "xorq %%rsi, %%rsi\n\t");
            fprintf(fileout, "movq %d(%%rbp), %%rsi\n\t", -4*(tmp->value) - 4);
            fprintf(fileout, "call printf\n\t");
            fprintf(fileout, "\n\t");
          }
      break;
      case P_IN_T:
          tmp = hashtab_lookup(hashtab, t->left->key);
          if (tmp != NULL) {
            if (tmp->type == 0)
            fprintf(fileout, "leaq %d(%%rbp), %%rax\n\t", -4*(tmp->value) - 4);
            fprintf(fileout, "movq %%rax, %%rsi\n\t");
            fprintf(fileout, "movl $INT, %%edi\n\t");
            fprintf(fileout, "movl $0, %%eax\n\t");
            fprintf(fileout, "call __isoc99_scanf\n\t");
            fprintf(fileout, "\n\t");
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
      fprintf(fileout, "cmpl $%s, %d(%%rbp)\n\t", t->middle->key,-4*(tmp1->value) - 4);
      invert = 1;
    } else if (tmp1 == NULL && tmp2 != NULL) {
      fprintf(fileout, "cmpl $%s, %d(%%rbp)\n\t", t->left->key,-4*(tmp2->value) - 4);
      invert = 0;
    }
    switch (t->key[0]) {
      case '>':
        if (invert != inv )
        fprintf(fileout, "jle .L%03d\n\t", label);
        else
        fprintf(fileout, "jg .L%03d\n\t", label);
      break;
      case '<':
        if (invert != inv )
        fprintf(fileout, "jns .L%03d\n\t", label);
        else
        fprintf(fileout, "js .L%03d\n\t", label);
      break;
      case '=':
        if (inv == 0)
          fprintf(fileout, "jne .L%03d\n\t", label);
        if (inv == 1)
          fprintf(fileout, "je .L%03d\n\t", label);
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
            fprintf(fileout, "xorl %%eax, %%eax\n\t");
            if (tmp != NULL)
              fprintf(fileout, "movl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "movl $%s, %%eax\n\t", t->key);
            exprLoad = 1;
          }
      break;
      case P_OP_T:
        tmp = hashtab_lookup(hashtab, t->middle->key);
        switch (t->key[0]) {
          case '+':
            if (tmp != NULL)
              fprintf(fileout, "addl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "addl $%s, %%eax\n\t", t->middle->key);
          break;
          case '-':
            if (tmp != NULL)
              fprintf(fileout, "subl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "subl $%s, %%eax\n\t", t->middle->key);
          break;
          case '*':
            if (tmp != NULL)
              fprintf(fileout, "mull %d(%%rbp)\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "mull $%s, %%eax\n\t", t->middle->key);
          break;
          case '/':
          case '%':
            if (tmp != NULL)
              fprintf(fileout, "divl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "divl $%s, %%eax\n\t", t->middle->key);
          break;
          case '&':
            if (tmp != NULL)
              fprintf(fileout, "andl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "andl $%s, %%eax\n\t", t->middle->key);
          break;
          case '|':
            if (tmp != NULL)
              fprintf(fileout, "orl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "orl $%s, %%eax\n\t", t->middle->key);
          break;
          case '^':
            if (tmp != NULL)
              fprintf(fileout, "xorl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "xorl $%s, %%eax\n\t", t->middle->key);
          break;
          case '!':
          case '~':
            tmp = hashtab_lookup(hashtab, t->left->key);
            if (tmp != NULL)
              fprintf(fileout, "notl %d(%%rbp), %%eax\n\t", -4*(tmp->value) - 4);
            else
              fprintf(fileout, "notl $%s, %%eax\n\t", t->left->key);
          break;
        }
      break;
      default: break;
    }

  }
}
