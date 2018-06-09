int main () {
int a := 10;
int b := 3;
int c := 4;
int d := 9;


a := (a + b) * c;
write(a);

a := a + b * c + c * d  + c * a;
write(a);

write(b);
write(c);
write(d);
return 0;
}
