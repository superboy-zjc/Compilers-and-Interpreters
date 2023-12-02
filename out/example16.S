	.section .rodata

_str0: .string "Hello, world\n"
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	movq     $_str0, -24(%rbp)   /* mov_q    vr10, $_str0 */
	movq     -24(%rbp), %rdi     /* mov_q    vr1, vr10 */
	call     print_str           /* call     print_str */
	movl     $0, -8(%rbp)        /* mov_l    vr12, $0 */
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr12 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $32, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
