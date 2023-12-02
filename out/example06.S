/* a is stored in the 1, at the offset of 10 */
/* b is stored in the 1, at the offset of 11 */
/* c is stored in the 1, at the offset of 12 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $80, %rsp
	movl     $2, -56(%rbp)       /* mov_l    vr13, $2 */
	movl     -56(%rbp), %r10d    /* mov_l    vr10, vr13 */
	movl     %r10d, -80(%rbp)
	movl     $3, -48(%rbp)       /* mov_l    vr14, $3 */
	movl     -48(%rbp), %r11d    /* mov_l    vr11, vr14 */
	movl     %r11d, -72(%rbp)
	movl     $1, -40(%rbp)       /* mov_l    vr15, $1 */
	movl     -40(%rbp), %r10d    /* mov_l    vr12, vr15 */
	movl     %r10d, -64(%rbp)
	movl     $1, -32(%rbp)       /* mov_l    vr16, $1 */
	movl     -80(%rbp), %r11d    /* add_l    vr17, vr10, vr16 */
	addl     -32(%rbp), %r11d
	movl     %r11d, -24(%rbp)
	movl     -24(%rbp), %r10d    /* cmpeq_l  vr18, vr17, vr11 */
	cmpl     -72(%rbp), %r10d
	sete     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -16(%rbp)
	cmpl     $0, -16(%rbp)       /* cjmp_f   vr18, .L0 */
	je       .L0
	movl     $0, -8(%rbp)        /* mov_l    vr19, $0 */
	movl     -8(%rbp), %r11d     /* mov_l    vr12, vr19 */
	movl     %r11d, -64(%rbp)
.L0:
	movl     -64(%rbp), %eax     /* mov_l    vr0, vr12 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $80, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
