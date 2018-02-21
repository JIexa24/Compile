#include "../include/compile.h"

int main (int argc, char** argv) {
  if (argc > 1) {
    open_fd(argv[1]);
  }

  lexer();

  close_fd();
  return 0;
}
