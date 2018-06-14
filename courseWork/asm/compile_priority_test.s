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
	subq $24, %rsp
	movl $10, %eax
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	movl $3, %eax
	andl $65535, %eax
	movl %eax, -8(%rbp)
	
	
	movl $4, %eax
	andl $65535, %eax
	movl %eax, -12(%rbp)
	
	
	movl $9, %eax
	andl $65535, %eax
	movl %eax, -16(%rbp)
	
	
	xorl %eax, %eax
	movl -12(%rbp), %eax
	movl %eax, %ecx
	xorl %eax, %eax
	movl -8(%rbp), %eax
	addl -4(%rbp), %eax
	mull %ecx
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -4(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	xorl %eax, %eax
	movl -4(%rbp), %eax
	mull -12(%rbp)
	movl %eax, %ecx
	xorl %eax, %eax
	movl -16(%rbp), %eax
	mull -12(%rbp)
	addl %ecx, %eax
	movl %eax, %ecx
	xorl %eax, %eax
	movl -12(%rbp), %eax
	mull -8(%rbp)
	addl %ecx, %eax
	addl -4(%rbp), %eax
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	
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
	
	
	addq $24, %rsp
	movl $1, %eax
	movl $0, %ebx
	popq %rbp
	int $0x80
	
	
