CC = gcc
CFLAGS = -g3 -O0
LIB = -lm

all: LIST LEXER ./obj/main.o
	$(CC) ./obj/data.o ./obj/lexer.o ./obj/main.o ./obj/list.o -o ./bin/compile $(CFLAGS) $(LIB)

./obj/main.o: ./src/main.c
	$(CC) -c ./src/main.c -o ./obj/main.o

LEXER: ./obj/data.o ./obj/lexer.o

./obj/lexer.o: ./src/lexer.c
	$(CC) -c ./src/lexer.c -o ./obj/lexer.o

./obj/data.o: ./src/data.c
	$(CC) -c ./src/data.c -o ./obj/data.o

LIST: ./obj/list.o

./obj/list.o: ./src/list.c
	$(CC) -c ./src/list.c -o ./obj/list.o

PARSER: ./obj/parser.o

./obj/parser.o: ./src/parser.c
	$(CC) -c ./src/parser.c -o ./obj/parser.o

clean:
	rm -f ./obj/*.o
