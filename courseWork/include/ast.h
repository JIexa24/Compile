#ifndef AST_H
#define AST_H

struct ast {
  int type;
  char *key;
  struct ast* left;
  struct ast* middle;
  struct ast* right;
};

#define P_WHILE_T 1
#define P_COND_T 2

struct ast* ast_createNode(int type, char* key, struct ast* l, struct ast* m, struct ast* r);

#endif
