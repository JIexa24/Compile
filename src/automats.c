#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

static char ch = 0;
static char lastch = 0;
static char fd = 0;

void open_fd(char* filename) {
  if ((fd = open(filename, O_RDONLY)) == -1) {
    printf("Can't open file : %s\nRead from stdin", filename);
    fd = 0;
  }
}

static int is_d(char c) {
  return (('0' <= c) && (c <= '9'));
}

static int is_e(char c) {
  return ((c == 'e') || (c == 'E'));
}

static int is_z(char c) {
  return ((c == '+') || (c == '-'));
}

static int r_ch() {
    int res = 0;
    if (lastch == '\n') return 0;
  	res = read(fd, &ch, sizeof(char));
    lastch = ch;
//    printf("ch = %d\n", ch);
    res = (ch == '\n') ? 0 : 1;
    return res;
}

int automat_1() {
  ch = '\0';

  A1_INIT:
    if(r_ch() == 0)
      goto A1_ERROR;
    if (is_d(ch))
      goto A1_DIG;
    else if (ch == '.')
      goto A1_DOT;
    else
      goto A1_ERROR;

  A1_DIG:
    if(r_ch() == 0)
      goto A1_END;
    if (is_d(ch))
      goto A1_DIG;
    else if (ch == '.')
      goto A1_DOT;
    else if (is_e(ch))
      goto A1_EXP;
    else
      goto A1_ERROR;

  A1_DOT:
    if(r_ch() == 0)
      goto A1_ERROR;
    if (is_d(ch))
      goto A1_F;
    else
      goto A1_ERROR;

  A1_F:
    if(r_ch() == 0)
      goto A1_END;
    if (is_d(ch))
      goto A1_F;
    else if (is_e(ch))
      goto A1_EXP;
    else
      goto A1_ERROR;

  A1_EXP:
    if(r_ch() == 0)
      goto A1_ERROR;
    if (is_d(ch))
      goto A1_FIN;
    else if (is_z(ch))
      goto A1_Z;
    else
      goto A1_ERROR;

  A1_Z:
    if(r_ch() == 0)
      goto A1_ERROR;
    if (is_d(ch))
      goto A1_FIN;
    else
      goto A1_ERROR;

  A1_FIN:
    if(r_ch() == 0)
      goto A1_END;
    if (is_d(ch))
      goto A1_FIN;
    else
      goto A1_ERROR;

  A1_ERROR:
    while (r_ch());
    return 1;
  A1_END:
  	return 0;
}

int automat_2() {

}

int automat_3() {

}

int automat_4() {

}

int automat_5() {

}

int main (int argc, char** argv) {
  if (automat_1() == 0) {
  	printf("true\n");
  } else {
  	printf("false\n");
  }
  return 0;
}
