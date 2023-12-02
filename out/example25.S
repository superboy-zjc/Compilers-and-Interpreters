/*x is stored, at the offset of 0 */
/*y is stored, at the offset of 4 */
/* points is stored in the 0, at the offset of 0 */
/* i is stored in the 1, at the offset of 10 */
/* count is stored in the 1, at the offset of 11 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $24 */
	movq     %rsp, %rbp
	subq     $400, %rsp
	movl     $11, -376(%rbp)     /* mov_l    vr12, $11 */
	movl     -376(%rbp), %r10d   /* mov_l    vr11, vr12 */
	movl     %r10d, -384(%rbp)
	movl     $0, -368(%rbp)      /* mov_l    vr13, $0 */
	movl     -368(%rbp), %r11d   /* mov_l    vr10, vr13 */
	movl     %r11d, -392(%rbp)
	jmp      .L1                 /* jmp      .L1 */
.L0:
	leaq     -24(%rbp), %r10     /* localaddr vr14, $0 */
	movq     %r10, -360(%rbp)
	movl     -392(%rbp), %r10d   /* sconv_lq vr15, vr10 */
	movslq   %r10d, %r10
	movq     %r10, -352(%rbp)
	movq     -352(%rbp), %r11    /* mul_q    vr16, vr15, $8 */
	imulq    $8, %r11
	movq     %r11, -344(%rbp)
	movq     -360(%rbp), %r10    /* add_q    vr17, vr14, vr16 */
	addq     -344(%rbp), %r10
	movq     %r10, -336(%rbp)
	movq     $0, -328(%rbp)      /* mov_q    vr18, $0 */
	movq     -336(%rbp), %r11    /* add_q    vr19, vr17, vr18 */
	addq     -328(%rbp), %r11
	movq     %r11, -320(%rbp)
	movq     -320(%rbp), %r10    /* mov_l    (vr19), vr11 */
	movl     -384(%rbp), %r11d
	movl     %r11d, (%r10)
	movl     $1, -312(%rbp)      /* mov_l    vr20, $1 */
	movl     -384(%rbp), %r10d   /* add_l    vr21, vr11, vr20 */
	addl     -312(%rbp), %r10d
	movl     %r10d, -304(%rbp)
	movl     -304(%rbp), %r11d   /* mov_l    vr11, vr21 */
	movl     %r11d, -384(%rbp)
	leaq     -24(%rbp), %r10     /* localaddr vr22, $0 */
	movq     %r10, -296(%rbp)
	movl     -392(%rbp), %r10d   /* sconv_lq vr23, vr10 */
	movslq   %r10d, %r10
	movq     %r10, -288(%rbp)
	movq     -288(%rbp), %r11    /* mul_q    vr24, vr23, $8 */
	imulq    $8, %r11
	movq     %r11, -280(%rbp)
	movq     -296(%rbp), %r10    /* add_q    vr25, vr22, vr24 */
	addq     -280(%rbp), %r10
	movq     %r10, -272(%rbp)
	movq     $4, -264(%rbp)      /* mov_q    vr26, $4 */
	movq     -272(%rbp), %r11    /* add_q    vr27, vr25, vr26 */
	addq     -264(%rbp), %r11
	movq     %r11, -256(%rbp)
	movq     -256(%rbp), %r10    /* mov_l    (vr27), vr11 */
	movl     -384(%rbp), %r11d
	movl     %r11d, (%r10)
	movl     $1, -248(%rbp)      /* mov_l    vr28, $1 */
	movl     -384(%rbp), %r10d   /* add_l    vr29, vr11, vr28 */
	addl     -248(%rbp), %r10d
	movl     %r10d, -240(%rbp)
	movl     -240(%rbp), %r11d   /* mov_l    vr11, vr29 */
	movl     %r11d, -384(%rbp)
	movl     $1, -232(%rbp)      /* mov_l    vr30, $1 */
	movl     -392(%rbp), %r10d   /* add_l    vr31, vr10, vr30 */
	addl     -232(%rbp), %r10d
	movl     %r10d, -224(%rbp)
	movl     -224(%rbp), %r11d   /* mov_l    vr10, vr31 */
	movl     %r11d, -392(%rbp)
.L1:
	movl     $3, -216(%rbp)      /* mov_l    vr32, $3 */
	movl     -392(%rbp), %r10d   /* cmplt_l  vr33, vr10, vr32 */
	cmpl     -216(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -208(%rbp)
	cmpl     $0, -208(%rbp)      /* cjmp_t   vr33, .L0 */
	jne      .L0
	movl     $2, -200(%rbp)      /* mov_l    vr34, $2 */
	movl     -200(%rbp), %r11d   /* mov_l    vr10, vr34 */
	movl     %r11d, -392(%rbp)
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -24(%rbp), %r10     /* localaddr vr35, $0 */
	movq     %r10, -192(%rbp)
	movl     -392(%rbp), %r10d   /* sconv_lq vr36, vr10 */
	movslq   %r10d, %r10
	movq     %r10, -184(%rbp)
	movq     -184(%rbp), %r11    /* mul_q    vr37, vr36, $8 */
	imulq    $8, %r11
	movq     %r11, -176(%rbp)
	movq     -192(%rbp), %r10    /* add_q    vr38, vr35, vr37 */
	addq     -176(%rbp), %r10
	movq     %r10, -168(%rbp)
	movq     $0, -160(%rbp)      /* mov_q    vr39, $0 */
	movq     -168(%rbp), %r11    /* add_q    vr40, vr38, vr39 */
	addq     -160(%rbp), %r11
	movq     %r11, -152(%rbp)
	movq     -152(%rbp), %r10    /* mov_l    vr1, (vr40) */
	movl     (%r10), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	leaq     -24(%rbp), %r10     /* localaddr vr43, $0 */
	movq     %r10, -128(%rbp)
	movl     -392(%rbp), %r11d   /* sconv_lq vr44, vr10 */
	movslq   %r11d, %r11
	movq     %r11, -120(%rbp)
	movq     -120(%rbp), %r10    /* mul_q    vr45, vr44, $8 */
	imulq    $8, %r10
	movq     %r10, -112(%rbp)
	movq     -128(%rbp), %r11    /* add_q    vr46, vr43, vr45 */
	addq     -112(%rbp), %r11
	movq     %r11, -104(%rbp)
	movq     $4, -96(%rbp)       /* mov_q    vr47, $4 */
	movq     -104(%rbp), %r10    /* add_q    vr48, vr46, vr47 */
	addq     -96(%rbp), %r10
	movq     %r10, -88(%rbp)
	movq     -88(%rbp), %r11     /* mov_l    vr1, (vr48) */
	movl     (%r11), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $1, -64(%rbp)       /* mov_l    vr51, $1 */
	movl     -392(%rbp), %r10d   /* sub_l    vr52, vr10, vr51 */
	subl     -64(%rbp), %r10d
	movl     %r10d, -56(%rbp)
	movl     -56(%rbp), %r11d    /* mov_l    vr10, vr52 */
	movl     %r11d, -392(%rbp)
.L3:
	movl     $0, -48(%rbp)       /* mov_l    vr53, $0 */
	movl     -392(%rbp), %r10d   /* cmpgte_l vr54, vr10, vr53 */
	cmpl     -48(%rbp), %r10d
	setge    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -40(%rbp)
	cmpl     $0, -40(%rbp)       /* cjmp_t   vr54, .L2 */
	jne      .L2
	movl     $0, -32(%rbp)       /* mov_l    vr55, $0 */
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr55 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $400, %rsp          /* leave    $24 */
	popq     %rbp
	ret                          /* ret       */
