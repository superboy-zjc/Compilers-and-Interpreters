/*name is stored, at the offset of 0 */
/*age is stored, at the offset of 20 */
/* p is stored in the 0, at the offset of 0 */
/* s is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $24 */
	movq     %rsp, %rbp
	subq     $544, %rsp
	leaq     -24(%rbp), %r10     /* localaddr vr11, $0 */
	movq     %r10, -528(%rbp)
	movq     $0, -520(%rbp)      /* mov_q    vr12, $0 */
	movq     -528(%rbp), %r10    /* add_q    vr13, vr11, vr12 */
	addq     -520(%rbp), %r10
	movq     %r10, -512(%rbp)
	movl     $0, -504(%rbp)      /* mov_l    vr14, $0 */
	movl     -504(%rbp), %r11d   /* sconv_lq vr15, vr14 */
	movslq   %r11d, %r11
	movq     %r11, -496(%rbp)
	movq     -496(%rbp), %r10    /* mul_q    vr16, vr15, $1 */
	imulq    $1, %r10
	movq     %r10, -488(%rbp)
	movq     -512(%rbp), %r11    /* add_q    vr17, vr13, vr16 */
	addq     -488(%rbp), %r11
	movq     %r11, -480(%rbp)
	movb     $65, -472(%rbp)     /* mov_b    vr18, $65 */
	movq     -480(%rbp), %r10    /* mov_b    (vr17), vr18 */
	movb     -472(%rbp), %r11b
	movb     %r11b, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr19, $0 */
	movq     %r10, -464(%rbp)
	movq     $0, -456(%rbp)      /* mov_q    vr20, $0 */
	movq     -464(%rbp), %r10    /* add_q    vr21, vr19, vr20 */
	addq     -456(%rbp), %r10
	movq     %r10, -448(%rbp)
	movl     $1, -440(%rbp)      /* mov_l    vr22, $1 */
	movl     -440(%rbp), %r11d   /* sconv_lq vr23, vr22 */
	movslq   %r11d, %r11
	movq     %r11, -432(%rbp)
	movq     -432(%rbp), %r10    /* mul_q    vr24, vr23, $1 */
	imulq    $1, %r10
	movq     %r10, -424(%rbp)
	movq     -448(%rbp), %r11    /* add_q    vr25, vr21, vr24 */
	addq     -424(%rbp), %r11
	movq     %r11, -416(%rbp)
	movb     $108, -408(%rbp)    /* mov_b    vr26, $108 */
	movq     -416(%rbp), %r10    /* mov_b    (vr25), vr26 */
	movb     -408(%rbp), %r11b
	movb     %r11b, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr27, $0 */
	movq     %r10, -400(%rbp)
	movq     $0, -392(%rbp)      /* mov_q    vr28, $0 */
	movq     -400(%rbp), %r10    /* add_q    vr29, vr27, vr28 */
	addq     -392(%rbp), %r10
	movq     %r10, -384(%rbp)
	movl     $2, -376(%rbp)      /* mov_l    vr30, $2 */
	movl     -376(%rbp), %r11d   /* sconv_lq vr31, vr30 */
	movslq   %r11d, %r11
	movq     %r11, -368(%rbp)
	movq     -368(%rbp), %r10    /* mul_q    vr32, vr31, $1 */
	imulq    $1, %r10
	movq     %r10, -360(%rbp)
	movq     -384(%rbp), %r11    /* add_q    vr33, vr29, vr32 */
	addq     -360(%rbp), %r11
	movq     %r11, -352(%rbp)
	movb     $105, -344(%rbp)    /* mov_b    vr34, $105 */
	movq     -352(%rbp), %r10    /* mov_b    (vr33), vr34 */
	movb     -344(%rbp), %r11b
	movb     %r11b, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr35, $0 */
	movq     %r10, -336(%rbp)
	movq     $0, -328(%rbp)      /* mov_q    vr36, $0 */
	movq     -336(%rbp), %r10    /* add_q    vr37, vr35, vr36 */
	addq     -328(%rbp), %r10
	movq     %r10, -320(%rbp)
	movl     $3, -312(%rbp)      /* mov_l    vr38, $3 */
	movl     -312(%rbp), %r11d   /* sconv_lq vr39, vr38 */
	movslq   %r11d, %r11
	movq     %r11, -304(%rbp)
	movq     -304(%rbp), %r10    /* mul_q    vr40, vr39, $1 */
	imulq    $1, %r10
	movq     %r10, -296(%rbp)
	movq     -320(%rbp), %r11    /* add_q    vr41, vr37, vr40 */
	addq     -296(%rbp), %r11
	movq     %r11, -288(%rbp)
	movb     $99, -280(%rbp)     /* mov_b    vr42, $99 */
	movq     -288(%rbp), %r10    /* mov_b    (vr41), vr42 */
	movb     -280(%rbp), %r11b
	movb     %r11b, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr43, $0 */
	movq     %r10, -272(%rbp)
	movq     $0, -264(%rbp)      /* mov_q    vr44, $0 */
	movq     -272(%rbp), %r10    /* add_q    vr45, vr43, vr44 */
	addq     -264(%rbp), %r10
	movq     %r10, -256(%rbp)
	movl     $4, -248(%rbp)      /* mov_l    vr46, $4 */
	movl     -248(%rbp), %r11d   /* sconv_lq vr47, vr46 */
	movslq   %r11d, %r11
	movq     %r11, -240(%rbp)
	movq     -240(%rbp), %r10    /* mul_q    vr48, vr47, $1 */
	imulq    $1, %r10
	movq     %r10, -232(%rbp)
	movq     -256(%rbp), %r11    /* add_q    vr49, vr45, vr48 */
	addq     -232(%rbp), %r11
	movq     %r11, -224(%rbp)
	movb     $101, -216(%rbp)    /* mov_b    vr50, $101 */
	movq     -224(%rbp), %r10    /* mov_b    (vr49), vr50 */
	movb     -216(%rbp), %r11b
	movb     %r11b, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr51, $0 */
	movq     %r10, -208(%rbp)
	movq     $0, -200(%rbp)      /* mov_q    vr52, $0 */
	movq     -208(%rbp), %r10    /* add_q    vr53, vr51, vr52 */
	addq     -200(%rbp), %r10
	movq     %r10, -192(%rbp)
	movl     $5, -184(%rbp)      /* mov_l    vr54, $5 */
	movl     -184(%rbp), %r11d   /* sconv_lq vr55, vr54 */
	movslq   %r11d, %r11
	movq     %r11, -176(%rbp)
	movq     -176(%rbp), %r10    /* mul_q    vr56, vr55, $1 */
	imulq    $1, %r10
	movq     %r10, -168(%rbp)
	movq     -192(%rbp), %r11    /* add_q    vr57, vr53, vr56 */
	addq     -168(%rbp), %r11
	movq     %r11, -160(%rbp)
	movl     $0, -152(%rbp)      /* mov_l    vr58, $0 */
	movq     -160(%rbp), %r10    /* mov_b    (vr57), vr58 */
	movb     -152(%rbp), %r11b
	movb     %r11b, (%r10)
	leaq     -24(%rbp), %r10     /* localaddr vr59, $0 */
	movq     %r10, -144(%rbp)
	movq     $20, -136(%rbp)     /* mov_q    vr60, $20 */
	movq     -144(%rbp), %r10    /* add_q    vr61, vr59, vr60 */
	addq     -136(%rbp), %r10
	movq     %r10, -128(%rbp)
	movl     $43, -120(%rbp)     /* mov_l    vr62, $43 */
	movq     -128(%rbp), %r11    /* mov_l    (vr61), vr62 */
	movl     -120(%rbp), %r10d
	movl     %r10d, (%r11)
	leaq     -24(%rbp), %r10     /* localaddr vr63, $0 */
	movq     %r10, -112(%rbp)
	movq     $0, -104(%rbp)      /* mov_q    vr64, $0 */
	movq     -112(%rbp), %r11    /* add_q    vr65, vr63, vr64 */
	addq     -104(%rbp), %r11
	movq     %r11, -96(%rbp)
	movq     -96(%rbp), %r10     /* mov_q    vr10, vr65 */
	movq     %r10, -536(%rbp)
	movq     -536(%rbp), %rdi    /* mov_q    vr1, vr10 */
	call     print_str           /* call     print_str */
	call     print_nl            /* call     print_nl */
	leaq     -24(%rbp), %r10     /* localaddr vr68, $0 */
	movq     %r10, -72(%rbp)
	movq     $20, -64(%rbp)      /* mov_q    vr69, $20 */
	movq     -72(%rbp), %r11     /* add_q    vr70, vr68, vr69 */
	addq     -64(%rbp), %r11
	movq     %r11, -56(%rbp)
	movq     -56(%rbp), %r10     /* mov_l    vr1, (vr70) */
	movl     (%r10), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, -32(%rbp)       /* mov_l    vr73, $0 */
	movl     -32(%rbp), %eax     /* mov_l    vr0, vr73 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $544, %rsp          /* leave    $24 */
	popq     %rbp
	ret                          /* ret       */
