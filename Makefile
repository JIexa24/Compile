CC = gcc
CFLAGS = -g3 -O0

all: LEXER ./obj/main.o
	$(CC) ./obj/data.o ./obj/lexer.o ./obj/main.o -o ./bin/compile $(CFLAGS)

./obj/main.o: ./src/main.c
	$(CC) -c ./src/main.c -o ./obj/main.o

LEXER : ./obj/data.o ./obj/lexer.o

./obj/lexer.o: ./src/lexer.c
	$(CC) -c ./src/lexer.c -o ./obj/lexer.o

./obj/data.o: ./src/data.c
	$(CC) -c ./src/data.c -o ./obj/data.o

clean:
	rm ./obj/*.o