STRING:
.string "b\n"
INT:
.string	"%d\n"
.type main, @function
.globl main
main:
  pushq %rbp
  movq %rsp, %rbp
  movl $0, %eax
  movl $STRING, %edi
  call printf

  movl $5, -4(%rbp)
  addl $10, -4(%rbp)
  movl $INT, %edi
  movl -4(%rbp), %eax
  movl %eax, %esi
  call printf
  movl $0, %eax
  popq %rbp
  ret
