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
	subq $20, %rsp
	movl $1, %eax
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	movl $0, %eax
	andl $65535, %eax
	movl %eax, -8(%rbp)
	
	
	movl $0, -12(%rbp)
	
	jmp .L002
.L001:
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -8(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	xorl %eax, %eax
	movl -4(%rbp), %eax
	andl $65535, %eax
	movl %eax, -12(%rbp)
	
	xorl %eax, %eax
	movl -8(%rbp), %eax
	addl -4(%rbp), %eax
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	xorl %eax, %eax
	movl -12(%rbp), %eax
	andl $65535, %eax
	movl %eax, -8(%rbp)
	
	
	
	
	.L002:
	cmpl $255, -4(%rbp)
	js .L001
	xorl %edx, %edx
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -8(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	addq $20, %rsp
	movl $1, %eax
	movl $0, %ebx
	popq %rbp
	int $0x80
	
	
