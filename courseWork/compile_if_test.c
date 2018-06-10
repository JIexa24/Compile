int main () {
  int a := 0;
  int b := 1;
  int c := 2;
  int e := 3;
  int d;

  read(d);

  if (d < 10)
    write(a);
  else
    write(e);

  if (d == 10) {
    write(b);
  }

  if (10 < d)
    write(c);

  return 0;
}
