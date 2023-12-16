	.section .rodata

_str0: .string "Hello, world\n"
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	movq     $_str0, %r9         /* mov_q    vr10<%r9>, $_str0 */
	movq     %r9, %rdi           /* mov_q    vr1, vr10<%r9> */
	call     print_str           /* call     print_str */
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	popq     %rbp                /* leave    $0 */
	ret                          /* ret       */
