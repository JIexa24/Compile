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
  ch = '\0';

  A2_INIT:
    if(r_ch() == 0)
      goto A2_ERROR;
    if (ch == 'a')
      goto A2_A;
    else
      goto A2_ERROR;

  A2_A:
    if(r_ch() == 0)
      goto A2_ERROR;
    if (ch == 'a')
      goto A2_A;
    else if (ch == 'e')
      goto A2_E;
    else
      goto A2_ERROR;

  A2_E:
    if(r_ch() == 0)
      goto A2_ERROR;
    if (ch == 'e')
      goto A2_E;
    else if (ch == 'i')
      goto A2_I;
    else
      goto A2_ERROR;

  A2_I:
    if(r_ch() == 0)
      goto A2_ERROR;
    if (ch == 'i')
      goto A2_I;
    else if (ch == 'o')
      goto A2_O;
    else
      goto A2_ERROR;

  A2_O:
    if(r_ch() == 0)
      goto A2_ERROR;
    if (ch == 'o')
      goto A2_O;
    else if (ch == 'u')
      goto A2_U;
    else
      goto A2_ERROR;

  A2_U:
    if(r_ch() == 0)
      goto A2_END;
    if (ch == 'u')
      goto A2_U;
    else
      goto A2_ERROR;

  A2_ERROR:
    while (r_ch());
    return 1;
  A2_END:
  	return 0;
}

int automat_3_read() {
  char a_3_ch = ch;
  int a_3_result = 0;
  while(r_ch()) {
    if (ch < a_3_ch) {
      a_3_result = 1;
    }
    a_3_ch = ch;
  }
  return a_3_result;
}

int automat_3() {
  ch = '\0';

  A3_INIT:
    if(r_ch() == 0)
      goto A3_ERROR;
    if ('a' <= ch && ch <= 'z' )
      if(automat_3_read() == 0) goto A3_END;
      else goto A3_ERROR;
    else
      goto A3_ERROR;

  A3_ERROR:
    while (r_ch());
    return 1;
  A3_END:
  	return 0;

}

int automat_4() {
  ch = '\0';

  A4_INIT:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FA1;
    else if (ch == 'b')
      goto A4_FB1;
    else
      goto A4_ERROR;
  A4_FA1:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FA3;
    else if (ch == 'b')
      goto A4_FB2;
    else
      goto A4_ERROR;
  A4_FA2:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FB1;
    else if (ch == 'b')
      goto A4_FAT;
    else
      goto A4_ERROR;
  A4_FA3:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FA4;
    else if (ch == 'b')
      goto A4_FB1;
    else
      goto A4_ERROR;
  A4_FA4:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FA3;
    else if (ch == 'b')
      goto A4_FA2;
    else
      goto A4_ERROR;
  A4_FB1:
    if(r_ch() == 0)
      goto A4_END;
    if (ch == 'a')
      goto A4_FA2;
    else if (ch == 'b')
      goto A4_FBT;
    else
      goto A4_ERROR;
  A4_FB2:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FB1;
    else if (ch == 'b')
      goto A4_FB3;
    else
      goto A4_ERROR;

  A4_FB3:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FA3;
    else if (ch == 'b')
      goto A4_FB2;
    else
      goto A4_ERROR;

  A4_FBT:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FAT;
    else if (ch == 'b')
      goto A4_FB1;
    else
      goto A4_ERROR;
  A4_FAT:
    if(r_ch() == 0)
      goto A4_ERROR;
    if (ch == 'a')
      goto A4_FB1;
    else if (ch == 'b')
      goto A4_FA2;
    else
      goto A4_ERROR;
  A4_ERROR:
    while (r_ch());
    return 1;
  A4_END:
  	return 0;

}

int automat_5() {
  ch = '\0';

  A5_INIT:
    if(r_ch() == 0)
      goto A5_ERROR;
    if (ch == 'a')
      goto A5_FA1;
    else if (ch == 'b')
      goto A5_FB1;
    else
      goto A5_ERROR;

  A5_FA1:
    if(r_ch() == 0)
      goto A5_END;
    if (ch == 'a')
      goto A5_FA1;
    else if (ch == 'b')
      goto A5_FB2;
    else
      goto A5_ERROR;

  A5_FB1:
    if(r_ch() == 0)
      goto A5_END;
    if (ch == 'a')
      goto A5_FA1;
    else if (ch == 'b')
      goto A5_FB1;
    else
      goto A5_ERROR;

  A5_FB2:
    if(r_ch() == 0)
      goto A5_END;
    if (ch == 'a')
      goto A5_FA1;
    else
      goto A5_ERROR;

  A5_ERROR:
    while (r_ch());
    return 1;
  A5_END:
  	return 0;

}


int automat_6() {
  ch = '\0';

  A6_INIT:
    if(r_ch() == 0)
      goto A6_ERROR;
    if (ch == 'a')
      goto A6_FA1;
    else if (ch == 'b')
      goto A6_FBN;
    else
      goto A6_ERROR;

  A6_FA1:
    if(r_ch() == 0)
      goto A6_END;
    if (ch == 'a')
      goto A6_FA1;
    else if (ch == 'b')
      goto A6_FB1;
    else
      goto A6_ERROR;

  A6_FB1:
    if(r_ch() == 0)
      goto A6_END;
    if (ch == 'a')
      goto A6_FB1;
    else
      goto A6_ERROR;

  A6_FBN:
    if(r_ch() == 0)
      goto A6_END;
    if (ch == 'a')
      goto A6_FA1;
    else if (ch == 'b')
      goto A6_FBN;
    else
      goto A6_ERROR;

  A6_ERROR:
    while (r_ch());
    return 1;
  A6_END:
  	return 0;

}

int main (int argc, char** argv) {
  if (argc < 2) return 0;
  int a = argv[1][0] - '0';
  if (a == 1) goto AU1;
  else if (a == 2) goto AU2;
  else if (a == 3) goto AU3;
  else if (a == 4) goto AU4;
  else if (a == 5) goto AU5;
  else if (a == 6) goto AU6;
  else goto AU_E;
  AU1:
  if (automat_1() == 0) {
  	printf("true\n");
  } else {
  	printf("false\n");
  }
  goto AU_E;
  AU2:
  if (automat_2() == 0) {
  	printf("true\n");
  } else {
  	printf("false\n");
  }
  goto AU_E;
  AU3:
  if (automat_3() == 0) {
  	printf("true\n");
  } else {
  	printf("false\n");
  }
  goto AU_E;
  AU4:
  if (automat_4() == 0) {
  	printf("true\n");
  } else {
  	printf("false\n");
  }
  goto AU_E;
  AU5:
  if (automat_5() == 0) {
  	printf("true\n");
  } else {
  	printf("false\n");
  }
  goto AU_E;
  AU6:
  if (automat_6() == 0) {
  	printf("true\n");
  } else {
  	printf("false\n");
  }
  goto AU_E;
  AU_E:
  return 0;
}
