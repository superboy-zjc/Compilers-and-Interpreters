/* n is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $80, %rsp
	movl     $10, -64(%rbp)      /* mov_l    vr11, $10 */
	movl     -64(%rbp), %r10d    /* mov_l    vr10, vr11 */
	movl     %r10d, -72(%rbp)
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     -72(%rbp), %edi     /* mov_l    vr1, vr10 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $1, -40(%rbp)       /* mov_l    vr14, $1 */
	movl     -72(%rbp), %r11d    /* sub_l    vr15, vr10, vr14 */
	subl     -40(%rbp), %r11d
	movl     %r11d, -32(%rbp)
	movl     -32(%rbp), %r10d    /* mov_l    vr10, vr15 */
	movl     %r10d, -72(%rbp)
.L1:
	movl     $0, -24(%rbp)       /* mov_l    vr16, $0 */
	movl     -72(%rbp), %r11d    /* cmpgt_l  vr17, vr10, vr16 */
	cmpl     -24(%rbp), %r11d
	setg     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -16(%rbp)
	cmpl     $0, -16(%rbp)       /* cjmp_t   vr17, .L0 */
	jne      .L0
	movl     $0, -8(%rbp)        /* mov_l    vr18, $0 */
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr18 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $80, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
