	.section .rodata
INT:
	.string "%d"
INTN:
	.string "%d\n"
	.text
	.globl main
	.type main, @function

main:
	pushq %rbp
	movq %rsp, %rbp
	subq $24, %rsp
	movl $10, %eax
	movl %eax, -4(%rbp)
	
	movl $3, %eax
	movl %eax, -8(%rbp)
	
	
	movl $4, %eax
	movl %eax, -12(%rbp)
	
	
	movl $0, -16(%rbp)
	
	leaq -16(%rbp), %rax
	movq %rax, %rsi
	movl $INT, %edi
	movl $0, %eax
	call __isoc99_scanf
	
	
	xorl %eax, %eax
	movl -16(%rbp), %eax
	mull -8(%rbp)
	addl $16, %eax
	addl $3, %eax
	movl %eax, -4(%rbp)
	
	
	movl $0, %eax
	movl $INTN, %edi
	xorq %rsi, %rsi
	movq -4(%rbp), %rsi
	call printf
	
	
	movl $0, %eax
	movl $INTN, %edi
	xorq %rsi, %rsi
	movq -8(%rbp), %rsi
	call printf
	
	
	movl $0, %eax
	movl $INTN, %edi
	xorq %rsi, %rsi
	movq -12(%rbp), %rsi
	call printf
	
	
	movl $0, %eax
	movl $INTN, %edi
	xorq %rsi, %rsi
	movq -16(%rbp), %rsi
	call printf
	
	
	addq $24, %rsp
	movl $0, %eax
	popq %rbp
	ret
	
	
