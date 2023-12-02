/* n is stored in the 1, at the offset of 10 */
/* i is stored in the 1, at the offset of 11 */
/* sum is stored in the 1, at the offset of 12 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $80, %rsp
	movl     $11, -56(%rbp)      /* mov_l    vr13, $11 */
	movl     -56(%rbp), %r10d    /* mov_l    vr10, vr13 */
	movl     %r10d, -80(%rbp)
	movl     $1, -48(%rbp)       /* mov_l    vr14, $1 */
	movl     -48(%rbp), %r11d    /* mov_l    vr11, vr14 */
	movl     %r11d, -72(%rbp)
	movl     $0, -40(%rbp)       /* mov_l    vr15, $0 */
	movl     -40(%rbp), %r10d    /* mov_l    vr12, vr15 */
	movl     %r10d, -64(%rbp)
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     -64(%rbp), %r11d    /* add_l    vr16, vr12, vr11 */
	addl     -72(%rbp), %r11d
	movl     %r11d, -32(%rbp)
	movl     -32(%rbp), %r10d    /* mov_l    vr12, vr16 */
	movl     %r10d, -64(%rbp)
	movl     $1, -24(%rbp)       /* mov_l    vr17, $1 */
	movl     -72(%rbp), %r11d    /* add_l    vr18, vr11, vr17 */
	addl     -24(%rbp), %r11d
	movl     %r11d, -16(%rbp)
	movl     -16(%rbp), %r10d    /* mov_l    vr11, vr18 */
	movl     %r10d, -72(%rbp)
.L1:
	movl     -72(%rbp), %r11d    /* cmplte_l vr19, vr11, vr10 */
	cmpl     -80(%rbp), %r11d
	setle    %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -8(%rbp)
	cmpl     $0, -8(%rbp)        /* cjmp_t   vr19, .L0 */
	jne      .L0
	movl     -64(%rbp), %eax     /* mov_l    vr0, vr12 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $80, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
