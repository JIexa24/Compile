int main () {
  int a := 1;
  int b := 0;
  int prev;


  while (a < 255) {
    prev := a;
    a := a + b;
    b := prev;
    write(b);
  }

  return 0;
}
