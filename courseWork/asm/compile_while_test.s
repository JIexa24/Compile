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
	
	
	movl $23, %eax
	andl $65535, %eax
	movl %eax, -16(%rbp)
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -4(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -12(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	jmp .L002
.L001:
	xorl %eax, %eax
	movl $1, %eax
	addl -4(%rbp), %eax
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	xorl %eax, %eax
	movl $1, %eax
	addl -12(%rbp), %eax
	andl $65535, %eax
	movl %eax, -12(%rbp)
	
	
	.L002:
	cmpl $22, -4(%rbp)
	js .L001
	xorl %edx, %edx
	
	
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
	
	
