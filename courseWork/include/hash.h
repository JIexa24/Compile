#ifndef HASH_H
#define HASH_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define HASHTAB_MUL 31
#define HASHTAB_SIZE 250

struct listnode
{
	char *key;
	int value;
	struct listnode *next;
	struct listnode *coll;
};

void hashtab_init(struct listnode **hashtab);
unsigned int hashtab_hash(char *key);
void hashtab_add(struct listnode **hashtab, char *key, int value);
struct listnode *hashtab_lookup(struct listnode **hashtab, char *key);
void hashtab_delete(struct listnode **hashtab);
void hashtab_print(struct listnode **hashtab);

#endif
