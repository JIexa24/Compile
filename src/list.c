#include "../include/compile.h"

token_t* list_createnode(int type, double val, char* ident, int id) {
  token_t* p;
  p = (token_t*)malloc(sizeof(*p));

  if (p != NULL) {
    p->type_token = type;
    p->value = val;
    p->next = NULL;
    p->id = id;
    strcpy(p->identifier, ident);
  }

  return p;
}

token_t* list_addend(token_t* head, int type, double val, char* ident, int id) {
  token_t* cursor = head;
  token_t* p = list_createnode(type, val, ident, id);

  if (head == NULL) return p;

  while (cursor->next != NULL) {
    cursor = cursor->next;
  }

  cursor->next = p;

  return head;
}

void list_print(token_t* head) {
  token_t* p =  head;
  while (p != NULL) {
    printf("-----------token----------------\n");
    if (p->type_token == OP_T) {
      fprintf(stdout, "[op : %s]\n", p->identifier);
    } else if (p->type_token == LEXEM_T) {
      fprintf(stdout, "[lexem : %s | id : %d]\n", p->identifier, p->id);
    } else if (p->type_token == NUM_T) {
      fprintf(stdout, "[num : %.4lf]\n", p->value);
    } else if (p->type_token == IDENT_T) {
      fprintf(stdout, "[ident : %s | id : %d]\n", p->identifier, p->id);
    }
    p = p->next;
  }
}
