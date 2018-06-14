	.data
INT:
	.string "%d"
INTN:
	.string "%d\n"
CHAR:
	.string "%c"
CHARN:
	.string "%c\n"
	.text
	.globl main
	.type main, @function

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $8, %rsp
	addq $8, %rsp
	movl $1, %eax
	movl $0, %ebx
	popq %rbp
	int $0x80
	
