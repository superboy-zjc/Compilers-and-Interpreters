/* a is stored in the 1, at the offset of 10 */
/* b is stored in the 1, at the offset of 11 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $64, %rsp
	movl     $4, -48(%rbp)       /* mov_l    vr12, $4 */
	movl     -48(%rbp), %r10d    /* mov_l    vr10, vr12 */
	movl     %r10d, -64(%rbp)
	movl     $5, -40(%rbp)       /* mov_l    vr13, $5 */
	movl     -40(%rbp), %r11d    /* mov_l    vr11, vr13 */
	movl     %r11d, -56(%rbp)
	movl     -64(%rbp), %r10d    /* add_l    vr14, vr10, vr11 */
	addl     -56(%rbp), %r10d
	movl     %r10d, -32(%rbp)
	movl     -32(%rbp), %edi     /* mov_l    vr1, vr14 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, -8(%rbp)        /* mov_l    vr17, $0 */
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr17 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $64, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
