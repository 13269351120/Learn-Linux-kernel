_g:                                     ## @g
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%eax
	movl	8(%ebp), %eax
	movl	8(%ebp), %ecx
	addl	$10, %ecx
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	movl	%ecx, %eax
	addl	$4, %esp
	popl	%ebp
	retl
                                        ## -- End function
_f:                                     ## @f
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	8(%ebp), %ecx
	movl	%ecx, (%esp)
	movl	%eax, -4(%ebp)          ## 4-byte Spill
	calll	_g
	addl	$8, %esp
	popl	%ebp
	retl
                                        ## -- End function
_main:                                  ## @main
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$20, %eax
	movl	$0, -4(%ebp)
	movl	$20, (%esp)
	movl	%eax, -8(%ebp)          ## 4-byte Spill
	calll	_f
	addl	$8, %eax
	addl	$24, %esp
	popl	%ebp
	retl
                                        ## -- End function

