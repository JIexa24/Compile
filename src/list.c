#include "../include/compile.h"

token_t* list_createnode(int type, int val, char* ident) {
  token_t* p;
  p = (token_t*)malloc(sizeof(*p));

  if (p != NULL) {
    p->type_token = type;
    p->value = val;
    p->next = NULL;
    strcpy(p->identifier, ident);
  }

  return p;
}

token_t* list_addend(token_t* head, int type, int val, char* ident) {
  token_t* cursor = head;
  token_t* p = list_createnode(type, val, ident);

  if (head == NULL) return p;

  while (cursor->next != NULL) {
    cursor = cursor->next;
  }

  cursor->next = p;

  return head;
}
