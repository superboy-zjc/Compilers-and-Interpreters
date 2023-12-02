/* x is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	movl     $1, -24(%rbp)       /* mov_l    vr11, $1 */
	movl     $2, -16(%rbp)       /* mov_l    vr12, $2 */
	movl     -24(%rbp), %r10d    /* add_l    vr13, vr11, vr12 */
	addl     -16(%rbp), %r10d
	movl     %r10d, -8(%rbp)
	movl     -8(%rbp), %r11d     /* mov_l    vr10, vr13 */
	movl     %r11d, -32(%rbp)
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr10 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $32, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
