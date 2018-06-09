#include <stdio.h>

int main () {
  int a = 10;
  int b = 2;
  float c = 2.3;
  asm volatile ("\n\t":::);
  a = a / 5;
  asm volatile ("\n\t":::);
  a = a / b;
  asm volatile ("\n\t":::);
  c = a + c;
  asm volatile ("\n\t":::);
  a = a + c;
  asm volatile ("\n\t":::);
  return 0;
}
