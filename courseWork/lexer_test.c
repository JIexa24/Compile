int main () {
int a := 10;
int b := 3;
int c := 4;
int d;

read(d);

a := a + d * c;

while (a < 20) {
  a := a + 1;
}

write(a);
write(b);
write(c);
write(d);
return 0;
}
