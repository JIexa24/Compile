#ifndef LIST_H
#define LIST_H

token_t* list_createnode(int type, int val, char* ident);
token_t* list_addend(token_t* head, int type, int val, char* ident);

#endif
