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
	subq $28, %rsp
	movl $1, %eax
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	movl $2, %eax
	andl $65535, %eax
	movl %eax, -8(%rbp)
	
	
	movl $3, %eax
	andl $65535, %eax
	movl %eax, -12(%rbp)
	
	
	movl $4, %eax
	andl $65535, %eax
	movl %eax, -16(%rbp)
	
	
	movl $0, -20(%rbp)
	
	movl $INT, %edi
	leaq -4(%rbp), %rax
	movq %rax, %rsi
	movl $0, %eax
	call __isoc99_scanf
	
	
	xorl %eax, %eax
	movl $2, %eax
	addl -4(%rbp), %eax
	andl $65535, %eax
	movl %eax, -20(%rbp)
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -4(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -8(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -12(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -16(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -20(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	addq $28, %rsp
	movl $1, %eax
	movl $0, %ebx
	popq %rbp
	int $0x80
	
	
