STRING:
.string "b\n"
.type main, @function
.globl main
main:
  pushq %rbp
  movq %rsp, %rbp
  movl $0, %eax
  movl $STRING, %edi
  call printf
  movl $1, %eax
  popq %rbp
