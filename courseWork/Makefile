CC = gcc
LEX = flex
PARSE = bison
CFLAGS = -g3 -O0
LIB = -lm

all: COMPILE

COMPILE: PARSER LEXER MAIN

MAIN: ./obj/main.o
	$(CC) ./obj/main.o ./obj/lexer.yy.o ./obj/parser.tab.o ./obj/hash.o -o ./bin/tlpcc

./obj/main.o: ./src/main.c
	$(CC) -c ./src/main.c -o ./obj/main.o

LEXER: HASH ./src/lexer.l
	$(LEX) -o ./src/lexer.yy.c ./src/lexer.l
	$(CC) -c ./src/lexer.yy.c -o ./obj/lexer.yy.o

HASH: ./src/hash.c
	$(CC) -c ./src/hash.c -o ./obj/hash.o

PARSER: ./src/parser.y
	$(PARSE) -o ./src/parser.tab.c ./src/parser.y -dy
	$(CC) -c ./src/parser.tab.c -o ./obj/parser.tab.o
	mv ./src/parser.tab.h ./include/parser.tab.h

clean:
	rm -f ./obj/*.o
	rm -f ./src/lexer.yy.c
	rm -f ./src/parser.tab.c
	rm -f ./include/parser.tab.h
