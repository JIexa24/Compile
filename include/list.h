#ifndef LIST_H
#define LIST_H

token_t* list_createnode(int type, double val, char* ident, int count);
token_t* list_addend(token_t* head, int type, double val, char* ident, int count);
void list_print(token_t* head);

#endif
