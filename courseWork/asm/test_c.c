#include <stdio.h>

int main () {
  int a = 10;
  int b = 2;
  float c = 2.3;
  asm volatile ("\n\t":::);
  printf("%d\n", a);
  asm volatile ("\n\t":::);
  return 0;
}
