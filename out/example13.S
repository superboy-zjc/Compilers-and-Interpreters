/*x is stored, at the offset of 0 */
/*y is stored, at the offset of 4 */
/* p is stored in the 0, at the offset of 0 */
/* q is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $8 */
	movq     %rsp, %rbp
	subq     $128, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr11, $0 */
	movq     %r10, -120(%rbp)
	movq     -120(%rbp), %r10    /* mov_q    vr10, vr11 */
	movq     %r10, -128(%rbp)
	movq     $0, -112(%rbp)      /* mov_q    vr12, $0 */
	movq     -128(%rbp), %r11    /* add_q    vr13, vr10, vr12 */
	addq     -112(%rbp), %r11
	movq     %r11, -104(%rbp)
	movl     $2, -96(%rbp)       /* mov_l    vr14, $2 */
	movq     -104(%rbp), %r10    /* mov_l    (vr13), vr14 */
	movl     -96(%rbp), %r11d
	movl     %r11d, (%r10)
	movq     $4, -88(%rbp)       /* mov_q    vr15, $4 */
	movq     -128(%rbp), %r10    /* add_q    vr16, vr10, vr15 */
	addq     -88(%rbp), %r10
	movq     %r10, -80(%rbp)
	movl     $3, -72(%rbp)       /* mov_l    vr17, $3 */
	movq     -80(%rbp), %r11     /* mov_l    (vr16), vr17 */
	movl     -72(%rbp), %r10d
	movl     %r10d, (%r11)
	movq     $0, -64(%rbp)       /* mov_q    vr18, $0 */
	movq     -128(%rbp), %r11    /* add_q    vr19, vr10, vr18 */
	addq     -64(%rbp), %r11
	movq     %r11, -56(%rbp)
	movq     $4, -48(%rbp)       /* mov_q    vr20, $4 */
	movq     -128(%rbp), %r10    /* add_q    vr21, vr10, vr20 */
	addq     -48(%rbp), %r10
	movq     %r10, -40(%rbp)
	movq     -56(%rbp), %r11     /* mov_l    vr23, (vr19) */
	movl     (%r11), %r10d
	movl     %r10d, -24(%rbp)
	movq     -40(%rbp), %r11     /* mov_l    vr24, (vr21) */
	movl     (%r11), %r10d
	movl     %r10d, -16(%rbp)
	movl     -24(%rbp), %r11d    /* add_l    vr22, vr23, vr24 */
	addl     -16(%rbp), %r11d
	movl     %r11d, -32(%rbp)
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr22 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $128, %rsp          /* leave    $8 */
	popq     %rbp
	ret                          /* ret       */
