/* arr is stored in the 0, at the offset of 0 */
/* sum is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $4 */
	movq     %rsp, %rbp
	subq     $128, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr11, $0 */
	movq     %r10, -120(%rbp)
	movl     $0, -112(%rbp)      /* mov_l    vr12, $0 */
	movl     -112(%rbp), %r10d   /* sconv_lq vr13, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -104(%rbp)
	movq     -104(%rbp), %r11    /* mul_q    vr14, vr13, $4 */
	imulq    $4, %r11
	movq     %r11, -96(%rbp)
	movq     -120(%rbp), %r10    /* add_q    vr15, vr11, vr14 */
	addq     -96(%rbp), %r10
	movq     %r10, -88(%rbp)
	movl     $2, -80(%rbp)       /* mov_l    vr16, $2 */
	movq     -88(%rbp), %r11     /* mov_l    (vr15), vr16 */
	movl     -80(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -8(%rbp), %r10      /* localaddr vr17, $0 */
	movq     %r10, -72(%rbp)
	movl     $0, -64(%rbp)       /* mov_l    vr18, $0 */
	movl     -64(%rbp), %r11d    /* sconv_lq vr19, vr18 */
	movslq   %r11d, %r11
	movq     %r11, -56(%rbp)
	movq     -56(%rbp), %r10     /* mul_q    vr20, vr19, $4 */
	imulq    $4, %r10
	movq     %r10, -48(%rbp)
	movq     -72(%rbp), %r11     /* add_q    vr21, vr17, vr20 */
	addq     -48(%rbp), %r11
	movq     %r11, -40(%rbp)
	movl     $1, -32(%rbp)       /* mov_l    vr22, $1 */
	movq     -40(%rbp), %r10     /* mov_l    vr24, (vr21) */
	movl     (%r10), %r11d
	movl     %r11d, -16(%rbp)
	movl     -16(%rbp), %r10d    /* add_l    vr23, vr24, vr22 */
	addl     -32(%rbp), %r10d
	movl     %r10d, -24(%rbp)
	movl     -24(%rbp), %r11d    /* mov_l    vr10, vr23 */
	movl     %r11d, -128(%rbp)
	movl     -128(%rbp), %eax    /* mov_l    vr0, vr10 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $128, %rsp          /* leave    $4 */
	popq     %rbp
	ret                          /* ret       */
