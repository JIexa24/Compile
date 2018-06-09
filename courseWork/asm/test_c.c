#include <stdio.h>

int main () {
  int a = 10;
  asm volatile ("\n\t":::);
  a = a / 5;
  asm volatile ("\n\t":::);
  return 0;
}
