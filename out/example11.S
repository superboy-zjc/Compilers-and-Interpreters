/* a is stored in the 0, at the offset of 0 */
/* p is stored in the 0, at the offset of 8 */
/* pp is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $16 */
	movq     %rsp, %rbp
	subq     $80, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr11, $8 */
	movq     %r10, -64(%rbp)
	leaq     -16(%rbp), %r10     /* localaddr vr12, $0 */
	movq     %r10, -56(%rbp)
	movq     -64(%rbp), %r10     /* mov_q    (vr11), vr12 */
	movq     -56(%rbp), %r11
	movq     %r11, (%r10)
	leaq     -8(%rbp), %r10      /* localaddr vr13, $8 */
	movq     %r10, -48(%rbp)
	movq     -48(%rbp), %r10     /* mov_q    vr10, vr13 */
	movq     %r10, -72(%rbp)
	movq     -72(%rbp), %r11     /* mov_q    vr14, (vr10) */
	movq     (%r11), %r10
	movq     %r10, -40(%rbp)
	movl     $17, -32(%rbp)      /* mov_l    vr15, $17 */
	movq     -40(%rbp), %r11     /* mov_l    (vr14), vr15 */
	movl     -32(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -16(%rbp), %r10     /* localaddr vr16, $0 */
	movq     %r10, -24(%rbp)
	movq     -24(%rbp), %r11     /* mov_l    vr0, (vr16) */
	movl     (%r11), %eax
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $80, %rsp           /* leave    $16 */
	popq     %rbp
	ret                          /* ret       */
