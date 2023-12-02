/* a is stored in the 1, at the offset of 10 */ 
/* n is stored in the 1, at the offset of 11 */ 
/* i is stored in the 1, at the offset of 12 */
/* sum is stored in the 1, at the offset of 13 */
/* arr is stored in the 0, at the offset of 0 */
/* result is stored in the 1, at the offset of 10 */
	.section .text

	.globl sum
sum:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $112, %rsp
	movq     %rdi, -112(%rbp)    /* mov_q    vr10, vr1 */
	movl     %esi, -104(%rbp)    /* mov_l    vr11, vr2 */
	movl     $0, -88(%rbp)       /* mov_l    vr13, $0 */
	movl     $0, -96(%rbp)       /* mov_l    vr12, $0 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     -96(%rbp), %r10d    /* sconv_lq vr16, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -64(%rbp)
	movq     -64(%rbp), %r11     /* mul_q    vr17, vr16, $4 */
	imulq    $4, %r11
	movq     %r11, -56(%rbp)
	movq     -112(%rbp), %r10    /* add_q    vr18, vr10, vr17 */
	addq     -56(%rbp), %r10
	movq     %r10, -48(%rbp)
	movq     -48(%rbp), %r11     /* mov_l    vr20, (vr18) */
	movl     (%r11), %r10d
	movl     %r10d, -32(%rbp)
	movl     -88(%rbp), %r11d    /* add_l    vr19, vr13, vr20 */
	addl     -32(%rbp), %r11d
	movl     %r11d, -40(%rbp)
	movl     -40(%rbp), %r10d    /* mov_l    vr13, vr19 */
	movl     %r10d, -88(%rbp)
	addl     $1, -96(%rbp)       /* add_l    vr22, vr12, $1 */
	movl     -96(%rbp), %r11d
	movl     %r11d, -16(%rbp)
	movl     -16(%rbp), %r10d    /* mov_l    vr12, vr22 */
	movl     %r10d, -96(%rbp)
.L1:
	movl     -96(%rbp), %r11d    /* cmplt_l  vr23, vr12, vr11 */
	cmpl     -104(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -8(%rbp)
	cmpl     $0, -8(%rbp)        /* cjmp_t   vr23, .L0 */
	jne      .L0
	movl     -88(%rbp), %eax     /* mov_l    vr0, vr13 */
	jmp      .Lsum_return        /* jmp      .Lsum_return */
.Lsum_return:
	addq     $112, %rsp          /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $12 */
	movq     %rsp, %rbp
	subq     $192, %rsp
	leaq     -16(%rbp), %r10     /* localaddr vr11, $0 */
	movq     %r10, -184(%rbp)
	addq     $0, -184(%rbp)      /* add_q    vr15, vr11, $0 */
	movq     -184(%rbp), %r10
	movq     %r10, -152(%rbp)
	movq     -152(%rbp), %r11    /* mov_l    (vr15), $1 */
	movl     $1, (%r11)
	addq     $4, -184(%rbp)      /* add_q    vr21, vr11, $4 */
	movq     -184(%rbp), %r10
	movq     %r10, -104(%rbp)
	movq     -104(%rbp), %r11    /* mov_l    (vr21), $2 */
	movl     $2, (%r11)
	addq     $8, -184(%rbp)      /* add_q    vr27, vr11, $8 */
	movq     -184(%rbp), %r10
	movq     %r10, -56(%rbp)
	movq     -56(%rbp), %r11     /* mov_l    (vr27), $3 */
	movl     $3, (%r11)
	movq     -184(%rbp), %rdi    /* mov_q    vr1, vr11 */
	movl     $3, %esi            /* mov_l    vr2, $3 */
	call     sum                 /* call     sum */
	movl     %eax, %eax          /* mov_l    vr0, vr0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $192, %rsp          /* leave    $12 */
	popq     %rbp
	ret                          /* ret       */
