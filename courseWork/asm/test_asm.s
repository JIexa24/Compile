.file	"test_c.c"
.section	.rodata
.LC0:
.string	"%d"
.text
.globl	main
.type	main, @function

main:

pushq	%rbp
movq	%rsp, %rbp
subq $16, %rsp


	leaq	-12(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	__isoc99_scanf

  movl $0, %eax
	movl $.LC0, %edi
	movq -12(%rbp), %rsi
	call printf

movl	$0, %eax
popq	%rbp
addq $16, %rsp
ret
