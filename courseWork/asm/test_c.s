	.file	"test_c.c"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$5, -4(%rbp)
	orl	$2, -4(%rbp)
#APP
# 6 "test_c.c" 1
	
	
# 0 "" 2
#NO_APP
	cmpl	$0, -4(%rbp)
	jne	.L2
	addl	$2, -4(%rbp)
.L2:
#APP
# 10 "test_c.c" 1
	
	
# 0 "" 2
#NO_APP
	movl	$0, %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.5) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
