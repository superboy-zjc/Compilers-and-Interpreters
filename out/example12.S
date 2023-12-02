/*x is stored, at the offset of 0 */
/*y is stored, at the offset of 4 */
/* p is stored in the 0, at the offset of 0 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $8 */
	movq     %rsp, %rbp
	subq     $144, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr10, $0 */
	movq     %r10, -144(%rbp)
	movq     $0, -136(%rbp)      /* mov_q    vr11, $0 */
	movq     -144(%rbp), %r10    /* add_q    vr12, vr10, vr11 */
	addq     -136(%rbp), %r10
	movq     %r10, -128(%rbp)
	movl     $2, -120(%rbp)      /* mov_l    vr13, $2 */
	movq     -128(%rbp), %r11    /* mov_l    (vr12), vr13 */
	movl     -120(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -8(%rbp), %r10      /* localaddr vr14, $0 */
	movq     %r10, -112(%rbp)
	movq     $4, -104(%rbp)      /* mov_q    vr15, $4 */
	movq     -112(%rbp), %r11    /* add_q    vr16, vr14, vr15 */
	addq     -104(%rbp), %r11
	movq     %r11, -96(%rbp)
	movl     $3, -88(%rbp)       /* mov_l    vr17, $3 */
	movq     -96(%rbp), %r10     /* mov_l    (vr16), vr17 */
	movl     -88(%rbp), %r11d
	movl     %r11d, (%r10)
	leaq     -8(%rbp), %r10      /* localaddr vr18, $0 */
	movq     %r10, -80(%rbp)
	movq     $0, -72(%rbp)       /* mov_q    vr19, $0 */
	movq     -80(%rbp), %r10     /* add_q    vr20, vr18, vr19 */
	addq     -72(%rbp), %r10
	movq     %r10, -64(%rbp)
	leaq     -8(%rbp), %r10      /* localaddr vr21, $0 */
	movq     %r10, -56(%rbp)
	movq     $4, -48(%rbp)       /* mov_q    vr22, $4 */
	movq     -56(%rbp), %r11     /* add_q    vr23, vr21, vr22 */
	addq     -48(%rbp), %r11
	movq     %r11, -40(%rbp)
	movq     -64(%rbp), %r10     /* mov_l    vr25, (vr20) */
	movl     (%r10), %r11d
	movl     %r11d, -24(%rbp)
	movq     -40(%rbp), %r10     /* mov_l    vr26, (vr23) */
	movl     (%r10), %r11d
	movl     %r11d, -16(%rbp)
	movl     -24(%rbp), %r10d    /* add_l    vr24, vr25, vr26 */
	addl     -16(%rbp), %r10d
	movl     %r10d, -32(%rbp)
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr24 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $144, %rsp          /* leave    $8 */
	popq     %rbp
	ret                          /* ret       */
