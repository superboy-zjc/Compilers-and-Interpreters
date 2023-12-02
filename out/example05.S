/* a is stored in the 1, at the offset of 10 */ 
/* b is stored in the 1, at the offset of 11 */ 
/* result is stored in the 1, at the offset of 12 */
/* x is stored in the 1, at the offset of 10 */
/* y is stored in the 1, at the offset of 11 */
/* z is stored in the 1, at the offset of 12 */
	.section .text

	.globl sum
sum:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	movl     %edi, -32(%rbp)     /* mov_l    vr10, vr1 */
	movl     %esi, -24(%rbp)     /* mov_l    vr11, vr2 */
	movl     -32(%rbp), %r10d    /* add_l    vr13, vr10, vr11 */
	addl     -24(%rbp), %r10d
	movl     %r10d, -8(%rbp)
	movl     -8(%rbp), %r11d     /* mov_l    vr12, vr13 */
	movl     %r11d, -16(%rbp)
	movl     -16(%rbp), %eax     /* mov_l    vr0, vr12 */
	jmp      .Lsum_return        /* jmp      .Lsum_return */
.Lsum_return:
	addq     $32, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $48, %rsp
	movl     $2, -24(%rbp)       /* mov_l    vr13, $2 */
	movl     -24(%rbp), %r10d    /* mov_l    vr10, vr13 */
	movl     %r10d, -48(%rbp)
	movl     $3, -16(%rbp)       /* mov_l    vr14, $3 */
	movl     -16(%rbp), %r11d    /* mov_l    vr11, vr14 */
	movl     %r11d, -40(%rbp)
	movl     -48(%rbp), %edi     /* mov_l    vr1, vr10 */
	movl     -40(%rbp), %esi     /* mov_l    vr2, vr11 */
	call     sum                 /* call     sum */
	movl     %eax, -8(%rbp)      /* mov_l    vr15, vr0 */
	movl     -8(%rbp), %r10d     /* mov_l    vr12, vr15 */
	movl     %r10d, -32(%rbp)
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr12 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $48, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
