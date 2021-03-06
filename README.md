# Learn-Linux-kernel
## Learn Linux Kernel

### 1.反汇编一个简单的C程序
* 汇编：main.c是一个简单的C程序，使用 `gcc -S -o main.s main.c -m32` 汇编生成main.s 使用-S是生成汇编代码，使用-m32是使用32位机器，因为汇编代码和平台的位数息息相关。
* 整理：main.s是汇编代码，但是里面有一些复杂的以'.'开头的语句，这些语句是在链接的时候用到的标识，为了清晰明白的看到汇编的逻辑，需要将这些行暂时删除一下。使用`cat main.s | grep -v "\." > main.ss` 这里用到了\.是因为.是可以匹配任意的字符，需要用\来转义。
---
#### 阅读汇编代码
```c
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

```
##### 汇编代码阅读个人总结
* 在进入一个函数的时候，需要建立函数的堆栈框架，也就是要产生属于本函数自身的堆栈。具体的：call指令首先将eip（call的下一条指令位置）压入栈，接下来就是构造一个全新的调用栈空间，需要两步骤：1.需要将ebp（Base Pointer堆栈基指针）的值push到栈里面，2.将ebp置为esp，第一步就是将前一层函数的堆栈基地址保存下来，第二步就是重新开始一个全新的『空的』堆栈（ebp=esp），所以在退出调用函数的时候，可能此时这个堆栈空间还有一些量，所以需要将esp置成ebp，还原成一个空栈，然后将ebp还原成调用前的位置（所以之前记录是必要的），最后ret，ret内部其实就是将栈pop给eip。调用一个函数前后ebp和esp不应该发生任何的变化。
* 在调用函数之前就会将需要传入的参数push到esp中。 然后在调用的函数里面通过`变址寻址`的方式找到这个传入的参数
`movl	8(%ebp), %eax`
* eax寄存器默认是作为返回值的存储的。
* call 实际的含义是 将`pushl %eip` 然后设置新的eip。

---
#### 总结"计算机是如何工作的"
计算机的工作原理其实就是不断地通过eip寻址执行，并且随时把有用的信息push入堆栈里，不断地维护这个堆栈。

