/* arr is stored in the 0, at the offset of 0 */ 
/* i is stored in the 1, at the offset of 10 */ 
/* j is stored in the 1, at the offset of 11 */ 
/* tmp is stored in the 1, at the offset of 12 */
/* arr is stored in the 0, at the offset of 0 */ 
/* n is stored in the 1, at the offset of 10 */ 
/* i is stored in the 1, at the offset of 11 */
/* tmp is stored in the 1, at the offset of 12 */
/* a is stored in the 0, at the offset of 0 */
/* i is stored in the 1, at the offset of 10 */
	.section .text

	.globl swap
swap:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $160, %rsp
	movl     %esi, -152(%rbp)    /* mov_l    vr10, vr2 */
	movl     %edx, -144(%rbp)    /* mov_l    vr11, vr3 */
	leaq     0(%rbp), %r10       /* localaddr vr13, $0 */
	movq     %r10, -128(%rbp)
	movl     -152(%rbp), %r10d   /* sconv_lq vr14, vr10 */
	movslq   %r10d, %r10
	movq     %r10, -120(%rbp)
	movq     -120(%rbp), %r11    /* mul_q    vr15, vr14, $4 */
	imulq    $4, %r11
	movq     %r11, -112(%rbp)
	movq     -128(%rbp), %r10    /* add_q    vr16, vr13, vr15 */
	addq     -112(%rbp), %r10
	movq     %r10, -104(%rbp)
	movq     -104(%rbp), %r11    /* mov_l    vr12, (vr16) */
	movl     (%r11), %r10d
	movl     %r10d, -136(%rbp)
	leaq     0(%rbp), %r10       /* localaddr vr17, $0 */
	movq     %r10, -96(%rbp)
	movl     -152(%rbp), %r11d   /* sconv_lq vr18, vr10 */
	movslq   %r11d, %r11
	movq     %r11, -88(%rbp)
	movq     -88(%rbp), %r10     /* mul_q    vr19, vr18, $4 */
	imulq    $4, %r10
	movq     %r10, -80(%rbp)
	movq     -96(%rbp), %r11     /* add_q    vr20, vr17, vr19 */
	addq     -80(%rbp), %r11
	movq     %r11, -72(%rbp)
	leaq     0(%rbp), %r10       /* localaddr vr21, $0 */
	movq     %r10, -64(%rbp)
	movl     -144(%rbp), %r10d   /* sconv_lq vr22, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -56(%rbp)
	movq     -56(%rbp), %r11     /* mul_q    vr23, vr22, $4 */
	imulq    $4, %r11
	movq     %r11, -48(%rbp)
	movq     -64(%rbp), %r10     /* add_q    vr24, vr21, vr23 */
	addq     -48(%rbp), %r10
	movq     %r10, -40(%rbp)
	movq     -40(%rbp), %r11     /* mov_l    (vr20), (vr24) */
	movq     -72(%rbp), %r10
	movl     (%r11), %r11d
	movl     %r11d, (%r10)
	leaq     0(%rbp), %r10       /* localaddr vr25, $0 */
	movq     %r10, -32(%rbp)
	movl     -144(%rbp), %r10d   /* sconv_lq vr26, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -24(%rbp)
	movq     -24(%rbp), %r11     /* mul_q    vr27, vr26, $4 */
	imulq    $4, %r11
	movq     %r11, -16(%rbp)
	movq     -32(%rbp), %r10     /* add_q    vr28, vr25, vr27 */
	addq     -16(%rbp), %r10
	movq     %r10, -8(%rbp)
	movq     -8(%rbp), %r11      /* mov_l    (vr28), vr12 */
	movl     -136(%rbp), %r10d
	movl     %r10d, (%r11)
	jmp      .Lswap_return       /* jmp      .Lswap_return */
.Lswap_return:
	addq     $160, %rsp          /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl bubble
bubble:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $192, %rsp
	movl     %esi, -192(%rbp)    /* mov_l    vr10, vr2 */
	movl     $1, -168(%rbp)      /* mov_l    vr13, $1 */
	movl     -168(%rbp), %r10d   /* mov_l    vr11, vr13 */
	movl     %r10d, -184(%rbp)
	jmp      .L1                 /* jmp      .L1 */
.L0:
	leaq     0(%rbp), %r10       /* localaddr vr14, $0 */
	movq     %r10, -160(%rbp)
	movl     -184(%rbp), %r11d   /* sconv_lq vr15, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -152(%rbp)
	movq     -152(%rbp), %r10    /* mul_q    vr16, vr15, $4 */
	imulq    $4, %r10
	movq     %r10, -144(%rbp)
	movq     -160(%rbp), %r11    /* add_q    vr17, vr14, vr16 */
	addq     -144(%rbp), %r11
	movq     %r11, -136(%rbp)
	leaq     0(%rbp), %r10       /* localaddr vr18, $0 */
	movq     %r10, -128(%rbp)
	movl     $1, -120(%rbp)      /* mov_l    vr19, $1 */
	movl     -184(%rbp), %r10d   /* sub_l    vr20, vr11, vr19 */
	subl     -120(%rbp), %r10d
	movl     %r10d, -112(%rbp)
	movl     -112(%rbp), %r11d   /* sconv_lq vr21, vr20 */
	movslq   %r11d, %r11
	movq     %r11, -104(%rbp)
	movq     -104(%rbp), %r10    /* mul_q    vr22, vr21, $4 */
	imulq    $4, %r10
	movq     %r10, -96(%rbp)
	movq     -128(%rbp), %r11    /* add_q    vr23, vr18, vr22 */
	addq     -96(%rbp), %r11
	movq     %r11, -88(%rbp)
	movq     -136(%rbp), %r10    /* mov_l    vr25, (vr17) */
	movl     (%r10), %r11d
	movl     %r11d, -72(%rbp)
	movq     -88(%rbp), %r10     /* mov_l    vr26, (vr23) */
	movl     (%r10), %r11d
	movl     %r11d, -64(%rbp)
	movl     -72(%rbp), %r10d    /* cmplt_l  vr24, vr25, vr26 */
	cmpl     -64(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -80(%rbp)
	cmpl     $0, -80(%rbp)       /* cjmp_f   vr24, .L2 */
	je       .L2
	leaq     0(%rbp), %r10       /* localaddr vr27, $0 */
	movq     %r10, -56(%rbp)
	movl     $1, -48(%rbp)       /* mov_l    vr28, $1 */
	movl     -184(%rbp), %r11d   /* sub_l    vr29, vr11, vr28 */
	subl     -48(%rbp), %r11d
	movl     %r11d, -40(%rbp)
	movq     -56(%rbp), %rdi     /* mov_q    vr1, vr27 */
	movl     -40(%rbp), %esi     /* mov_l    vr2, vr29 */
	movl     -184(%rbp), %edx    /* mov_l    vr3, vr11 */
	call     swap                /* call     swap */
.L2:
	movl     $1, -24(%rbp)       /* mov_l    vr31, $1 */
	movl     -184(%rbp), %r10d   /* add_l    vr32, vr11, vr31 */
	addl     -24(%rbp), %r10d
	movl     %r10d, -16(%rbp)
	movl     -16(%rbp), %r11d    /* mov_l    vr11, vr32 */
	movl     %r11d, -184(%rbp)
.L1:
	movl     -184(%rbp), %r10d   /* cmplt_l  vr33, vr11, vr10 */
	cmpl     -192(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -8(%rbp)
	cmpl     $0, -8(%rbp)        /* cjmp_t   vr33, .L0 */
	jne      .L0
	jmp      .Lbubble_return     /* jmp      .Lbubble_return */
.Lbubble_return:
	addq     $192, %rsp          /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $20 */
	movq     %rsp, %rbp
	subq     $400, %rsp
	leaq     -24(%rbp), %r10     /* localaddr vr11, $0 */
	movq     %r10, -384(%rbp)
	movl     $0, -376(%rbp)      /* mov_l    vr12, $0 */
	movl     -376(%rbp), %r10d   /* sconv_lq vr13, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -368(%rbp)
	movq     -368(%rbp), %r11    /* mul_q    vr14, vr13, $4 */
	imulq    $4, %r11
	movq     %r11, -360(%rbp)
	movq     -384(%rbp), %r10    /* add_q    vr15, vr11, vr14 */
	addq     -360(%rbp), %r10
	movq     %r10, -352(%rbp)
	movl     $52, -344(%rbp)     /* mov_l    vr16, $52 */
	movq     -352(%rbp), %r11    /* mov_l    (vr15), vr16 */
	movl     -344(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -24(%rbp), %r10     /* localaddr vr17, $0 */
	movq     %r10, -336(%rbp)
	movl     $1, -328(%rbp)      /* mov_l    vr18, $1 */
	movl     -328(%rbp), %r11d   /* sconv_lq vr19, vr18 */
	movslq   %r11d, %r11
	movq     %r11, -320(%rbp)
	movq     -320(%rbp), %r10    /* mul_q    vr20, vr19, $4 */
	imulq    $4, %r10
	movq     %r10, -312(%rbp)
	movq     -336(%rbp), %r11    /* add_q    vr21, vr17, vr20 */
	addq     -312(%rbp), %r11
	movq     %r11, -304(%rbp)
	movl     $31, -296(%rbp)     /* mov_l    vr22, $31 */
	movq     -304(%rbp), %r10    /* mov_l    (vr21), vr22 */
	movl     -296(%rbp), %r11d
	movl     %r11d, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr23, $0 */
	movq     %r10, -288(%rbp)
	movl     $2, -280(%rbp)      /* mov_l    vr24, $2 */
	movl     -280(%rbp), %r10d   /* sconv_lq vr25, vr24 */
	movslq   %r10d, %r10
	movq     %r10, -272(%rbp)
	movq     -272(%rbp), %r11    /* mul_q    vr26, vr25, $4 */
	imulq    $4, %r11
	movq     %r11, -264(%rbp)
	movq     -288(%rbp), %r10    /* add_q    vr27, vr23, vr26 */
	addq     -264(%rbp), %r10
	movq     %r10, -256(%rbp)
	movl     $8, -248(%rbp)      /* mov_l    vr28, $8 */
	movq     -256(%rbp), %r11    /* mov_l    (vr27), vr28 */
	movl     -248(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -24(%rbp), %r10     /* localaddr vr29, $0 */
	movq     %r10, -240(%rbp)
	movl     $3, -232(%rbp)      /* mov_l    vr30, $3 */
	movl     -232(%rbp), %r11d   /* sconv_lq vr31, vr30 */
	movslq   %r11d, %r11
	movq     %r11, -224(%rbp)
	movq     -224(%rbp), %r10    /* mul_q    vr32, vr31, $4 */
	imulq    $4, %r10
	movq     %r10, -216(%rbp)
	movq     -240(%rbp), %r11    /* add_q    vr33, vr29, vr32 */
	addq     -216(%rbp), %r11
	movq     %r11, -208(%rbp)
	movl     $41, -200(%rbp)     /* mov_l    vr34, $41 */
	movq     -208(%rbp), %r10    /* mov_l    (vr33), vr34 */
	movl     -200(%rbp), %r11d
	movl     %r11d, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr35, $0 */
	movq     %r10, -192(%rbp)
	movl     $4, -184(%rbp)      /* mov_l    vr36, $4 */
	movl     -184(%rbp), %r10d   /* sconv_lq vr37, vr36 */
	movslq   %r10d, %r10
	movq     %r10, -176(%rbp)
	movq     -176(%rbp), %r11    /* mul_q    vr38, vr37, $4 */
	imulq    $4, %r11
	movq     %r11, -168(%rbp)
	movq     -192(%rbp), %r10    /* add_q    vr39, vr35, vr38 */
	addq     -168(%rbp), %r10
	movq     %r10, -160(%rbp)
	movl     $75, -152(%rbp)     /* mov_l    vr40, $75 */
	movq     -160(%rbp), %r11    /* mov_l    (vr39), vr40 */
	movl     -152(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -24(%rbp), %r10     /* localaddr vr41, $0 */
	movq     %r10, -144(%rbp)
	movl     $5, -136(%rbp)      /* mov_l    vr42, $5 */
	movq     -144(%rbp), %rdi    /* mov_q    vr1, vr41 */
	movl     -136(%rbp), %esi    /* mov_l    vr2, vr42 */
	call     bubble              /* call     bubble */
	movl     $0, -120(%rbp)      /* mov_l    vr44, $0 */
	movl     -120(%rbp), %r11d   /* mov_l    vr10, vr44 */
	movl     %r11d, -392(%rbp)
	jmp      .L5                 /* jmp      .L5 */
.L4:
	leaq     -24(%rbp), %r10     /* localaddr vr45, $0 */
	movq     %r10, -112(%rbp)
	movl     -392(%rbp), %r10d   /* sconv_lq vr46, vr10 */
	movslq   %r10d, %r10
	movq     %r10, -104(%rbp)
	movq     -104(%rbp), %r11    /* mul_q    vr47, vr46, $4 */
	imulq    $4, %r11
	movq     %r11, -96(%rbp)
	movq     -112(%rbp), %r10    /* add_q    vr48, vr45, vr47 */
	addq     -96(%rbp), %r10
	movq     %r10, -88(%rbp)
	movq     -88(%rbp), %r11     /* mov_l    vr1, (vr48) */
	movl     (%r11), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $1, -64(%rbp)       /* mov_l    vr51, $1 */
	movl     -392(%rbp), %r10d   /* add_l    vr52, vr10, vr51 */
	addl     -64(%rbp), %r10d
	movl     %r10d, -56(%rbp)
	movl     -56(%rbp), %r11d    /* mov_l    vr10, vr52 */
	movl     %r11d, -392(%rbp)
.L5:
	movl     $5, -48(%rbp)       /* mov_l    vr53, $5 */
	movl     -392(%rbp), %r10d   /* cmplt_l  vr54, vr10, vr53 */
	cmpl     -48(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -40(%rbp)
	cmpl     $0, -40(%rbp)       /* cjmp_t   vr54, .L4 */
	jne      .L4
	movl     $0, -32(%rbp)       /* mov_l    vr55, $0 */
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr55 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $400, %rsp          /* leave    $20 */
	popq     %rbp
	ret                          /* ret       */
