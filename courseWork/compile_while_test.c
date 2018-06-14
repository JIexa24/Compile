int main () {
  int a := 10;
  int b := 3;
  int c := 4;
  int d := 23;


  write(a);
  write(c);
  while (a < 22) {
    a := a + 1;
   c:= c + 1;
  }
  write(a);

  write(b);
  write(c);
  write(d);
  return 0;
}
