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
	subq $12, %rsp
	movl $97, %eax
	andl $65535, %eax
	andl $255, %eax
	movl %eax, -4(%rbp)
	
	movl $CHARN, %edi
	xorq %rsi, %rsi
	movl -4(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	xorl %eax, %eax
	movl $2, %eax
	addl -4(%rbp), %eax
	andl $65535, %eax
	andl $255, %eax
	movl %eax, -4(%rbp)
	
	
	movl $CHARN, %edi
	xorq %rsi, %rsi
	movl -4(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	movl $CHARN, %edi
	xorq %rsi, %rsi
	movl $107, %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	
	addq $12, %rsp
	movl $1, %eax
	movl $0, %ebx
	popq %rbp
	int $0x80
	
	
