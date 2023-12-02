/* c is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $64, %rsp
	movl     $67, -48(%rbp)      /* mov_l    vr11, $67 */
	movl     -48(%rbp), %r10d    /* neg_l    vr12, vr11 */
	movl     $0, -40(%rbp)
	subl     %r10d, -40(%rbp)
	movb     -40(%rbp), %r11b    /* mov_b    vr10, vr12 */
	movb     %r11b, -56(%rbp)
	movb     -56(%rbp), %r10b    /* sconv_bl vr13, vr10 */
	movsbl   %r10b, %r10d
	movl     %r10d, -32(%rbp)
	movl     -32(%rbp), %edi     /* mov_l    vr1, vr13 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, -8(%rbp)        /* mov_l    vr16, $0 */
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr16 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $64, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
