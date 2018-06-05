#include <stdio.h>

int main () {
  int a = 5;
  a = a | 2;
  asm volatile ("\n\t":::);
    while (a > 5) {
      a = a | 2;
    }
  asm volatile ("\n\t":::);
  return 0;
}
