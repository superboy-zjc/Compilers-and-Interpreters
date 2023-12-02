/* a is stored in the 1, at the offset of 10 */
/* b is stored in the 1, at the offset of 11 */
/* c is stored in the 1, at the offset of 12 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $48, %rsp
	movl     $7, -24(%rbp)       /* mov_l    vr13, $7 */
	movl     -24(%rbp), %r10d    /* mov_l    vr10, vr13 */
	movl     %r10d, -48(%rbp)
	movl     $11, -16(%rbp)      /* mov_l    vr14, $11 */
	movl     -16(%rbp), %r11d    /* mov_l    vr11, vr14 */
	movl     %r11d, -40(%rbp)
	movl     -40(%rbp), %r10d    /* mul_l    vr15, vr10, vr11 */
	movl     -48(%rbp), %r11d
	imull    %r10d, %r11d
	movl     %r11d, -8(%rbp)
	movl     -8(%rbp), %r10d     /* mov_l    vr12, vr15 */
	movl     %r10d, -32(%rbp)
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr12 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $48, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
