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
	movl     $0, -80(%rbp)       /* mov_l    vr14, $0 */
	movl     -80(%rbp), %r10d    /* mov_l    vr13, vr14 */
	movl     %r10d, -88(%rbp)
	movl     $0, -72(%rbp)       /* mov_l    vr15, $0 */
	movl     -72(%rbp), %r11d    /* mov_l    vr12, vr15 */
	movl     %r11d, -96(%rbp)
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
	movl     $1, -24(%rbp)       /* mov_l    vr21, $1 */
	movl     -96(%rbp), %r11d    /* add_l    vr22, vr12, vr21 */
	addl     -24(%rbp), %r11d
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
	movl     $0, -176(%rbp)      /* mov_l    vr12, $0 */
	movl     -176(%rbp), %r10d   /* sconv_lq vr13, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -168(%rbp)
	movq     -168(%rbp), %r11    /* mul_q    vr14, vr13, $4 */
	imulq    $4, %r11
	movq     %r11, -160(%rbp)
	movq     -184(%rbp), %r10    /* add_q    vr15, vr11, vr14 */
	addq     -160(%rbp), %r10
	movq     %r10, -152(%rbp)
	movl     $1, -144(%rbp)      /* mov_l    vr16, $1 */
	movq     -152(%rbp), %r11    /* mov_l    (vr15), vr16 */
	movl     -144(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -16(%rbp), %r10     /* localaddr vr17, $0 */
	movq     %r10, -136(%rbp)
	movl     $1, -128(%rbp)      /* mov_l    vr18, $1 */
	movl     -128(%rbp), %r11d   /* sconv_lq vr19, vr18 */
	movslq   %r11d, %r11
	movq     %r11, -120(%rbp)
	movq     -120(%rbp), %r10    /* mul_q    vr20, vr19, $4 */
	imulq    $4, %r10
	movq     %r10, -112(%rbp)
	movq     -136(%rbp), %r11    /* add_q    vr21, vr17, vr20 */
	addq     -112(%rbp), %r11
	movq     %r11, -104(%rbp)
	movl     $2, -96(%rbp)       /* mov_l    vr22, $2 */
	movq     -104(%rbp), %r10    /* mov_l    (vr21), vr22 */
	movl     -96(%rbp), %r11d
	movl     %r11d, (%r10)
	leaq     -16(%rbp), %r10     /* localaddr vr23, $0 */
	movq     %r10, -88(%rbp)
	movl     $2, -80(%rbp)       /* mov_l    vr24, $2 */
	movl     -80(%rbp), %r10d    /* sconv_lq vr25, vr24 */
	movslq   %r10d, %r10
	movq     %r10, -72(%rbp)
	movq     -72(%rbp), %r11     /* mul_q    vr26, vr25, $4 */
	imulq    $4, %r11
	movq     %r11, -64(%rbp)
	movq     -88(%rbp), %r10     /* add_q    vr27, vr23, vr26 */
	addq     -64(%rbp), %r10
	movq     %r10, -56(%rbp)
	movl     $3, -48(%rbp)       /* mov_l    vr28, $3 */
	movq     -56(%rbp), %r11     /* mov_l    (vr27), vr28 */
	movl     -48(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -16(%rbp), %r10     /* localaddr vr29, $0 */
	movq     %r10, -40(%rbp)
	movl     $3, -32(%rbp)       /* mov_l    vr30, $3 */
	movq     -40(%rbp), %rdi     /* mov_q    vr1, vr29 */
	movl     -32(%rbp), %esi     /* mov_l    vr2, vr30 */
	call     sum                 /* call     sum */
	movl     %eax, -24(%rbp)     /* mov_l    vr31, vr0 */
	movl     -24(%rbp), %r11d    /* mov_l    vr10, vr31 */
	movl     %r11d, -192(%rbp)
	movl     -192(%rbp), %eax    /* mov_l    vr0, vr10 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $192, %rsp          /* leave    $12 */
	popq     %rbp
	ret                          /* ret       */
