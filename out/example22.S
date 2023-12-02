/* a is stored in the 1, at the offset of 10 */
/* b is stored in the 1, at the offset of 11 */
/* c is stored in the 1, at the offset of 12 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $96, %rsp
	movq     $14642, -64(%rbp)   /* mov_q    vr13, $14642 */
	movq     -64(%rbp), %r10     /* mov_q    vr10, vr13 */
	movq     %r10, -88(%rbp)
	movq     $341491, -56(%rbp)  /* mov_q    vr14, $341491 */
	movq     -56(%rbp), %r11     /* mul_q    vr15, vr10, vr14 */
	movq     -88(%rbp), %r10
	imulq    %r11, %r10
	movq     %r10, -48(%rbp)
	movq     -48(%rbp), %r11     /* mov_q    vr10, vr15 */
	movq     %r11, -88(%rbp)
	movq     $29, -40(%rbp)      /* mov_q    vr16, $29 */
	movq     -40(%rbp), %r10     /* mov_q    vr11, vr16 */
	movq     %r10, -80(%rbp)
	movq     -80(%rbp), %r11     /* mul_q    vr17, vr10, vr11 */
	movq     -88(%rbp), %r10
	imulq    %r11, %r10
	movq     %r10, -32(%rbp)
	movq     -32(%rbp), %r11     /* mov_q    vr12, vr17 */
	movq     %r11, -72(%rbp)
	movq     -72(%rbp), %rdi     /* mov_q    vr1, vr12 */
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     $0, -8(%rbp)        /* mov_l    vr20, $0 */
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr20 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $96, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
