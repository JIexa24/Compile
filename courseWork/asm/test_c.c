#include <stdio.h>

int main () {
  int a = 5;
  a = a | 2;
  asm volatile ("\n\t":::);
  if (a == 0) {
    a = a+ 2;
  }

  if (a <= 0) {
    a = a+ 2;
  }

  if (a >= 0) {
    a = a+ 2;
  }
  asm volatile ("\n\t":::);
  return 0;
}
