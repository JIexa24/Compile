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
	movl $0, %eax
	andl $65535, %eax
	movl %eax, -4(%rbp)
	
	movl $1, %eax
	andl $65535, %eax
	movl %eax, -8(%rbp)
	
	
	movl $2, %eax
	andl $65535, %eax
	movl %eax, -12(%rbp)
	
	
	movl $3, %eax
	andl $65535, %eax
	movl %eax, -16(%rbp)
	
	
	movl $0, -20(%rbp)
	
	movl $INT, %edi
	leaq -20(%rbp), %rax
	movq %rax, %rsi
	movl $0, %eax
	call __isoc99_scanf
	
	
	cmpl $10, -20(%rbp)
	jns .L001
	xorl %edx, %edx
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -4(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	.L001:
	cmpl $10, -20(%rbp)
	js .L002
	xorl %edx, %edx
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -16(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	.L002:
	
	
	cmpl $10, -20(%rbp)
	jne .L003
	xorl %edx, %edx
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -8(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	.L003:
	
	
	xorl %edx, %edx
	movl $10, %edx
	cmpl -20(%rbp), %edx
	jns .L004
	xorl %edx, %edx
	movl $INTN, %edi
	xorq %rsi, %rsi
	movl -12(%rbp), %eax
	movl %eax, %esi
	movl $0, %eax
	call printf
	
	.L004:
	
	
	addq $28, %rsp
	movl $1, %eax
	movl $0, %ebx
	popq %rbp
	int $0x80
	
	
