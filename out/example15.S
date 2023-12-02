/* x is stored in the 1, at the offset of 10 */
/* y is stored in the 1, at the offset of 11 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $48, %rsp
	call     read_i32            /* call     read_i32 */
	movl     %eax, -24(%rbp)     /* mov_l    vr12, vr0 */
	movl     -24(%rbp), %r10d    /* mov_l    vr10, vr12 */
	movl     %r10d, -40(%rbp)
	call     read_i32            /* call     read_i32 */
	movl     %eax, -16(%rbp)     /* mov_l    vr13, vr0 */
	movl     -16(%rbp), %r11d    /* mov_l    vr11, vr13 */
	movl     %r11d, -32(%rbp)
	movl     -40(%rbp), %r10d    /* add_l    vr14, vr10, vr11 */
	addl     -32(%rbp), %r10d
	movl     %r10d, -8(%rbp)
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr14 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $48, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
