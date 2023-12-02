/* arr is stored in the 1, at the offset of 10 */ 
/* i is stored in the 1, at the offset of 11 */
/* a is stored in the 0, at the offset of 0 */
/* b is stored in the 0, at the offset of 2000000 */
/* c is stored in the 0, at the offset of 4000000 */
/* M is stored in the 1, at the offset of 10 */
/* NELTS is stored in the 1, at the offset of 11 */
/* SZ is stored in the 1, at the offset of 12 */
/* i is stored in the 1, at the offset of 13 */
/* j is stored in the 1, at the offset of 14 */
/* k is stored in the 1, at the offset of 15 */
/* r is stored in the 1, at the offset of 16 */
/* val is stored in the 1, at the offset of 17 */
	.section .text

	.globl read_m500x500
read_m500x500:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $96, %rsp
	movq     %rdi, -88(%rbp)     /* mov_q    vr10, vr1 */
	movl     $0, -72(%rbp)       /* mov_l    vr12, $0 */
	movl     -72(%rbp), %r10d    /* mov_l    vr11, vr12 */
	movl     %r10d, -80(%rbp)
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     -80(%rbp), %r11d    /* sconv_lq vr13, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -64(%rbp)
	movq     -64(%rbp), %r10     /* mul_q    vr14, vr13, $8 */
	imulq    $8, %r10
	movq     %r10, -56(%rbp)
	movq     -88(%rbp), %r11     /* add_q    vr15, vr10, vr14 */
	addq     -56(%rbp), %r11
	movq     %r11, -48(%rbp)
	call     read_i64            /* call     read_i64 */
	movq     %rax, -40(%rbp)     /* mov_q    vr16, vr0 */
	movq     -48(%rbp), %r10     /* mov_q    (vr15), vr16 */
	movq     -40(%rbp), %r11
	movq     %r11, (%r10)
	movl     $1, -32(%rbp)       /* mov_l    vr17, $1 */
	movl     -80(%rbp), %r10d    /* add_l    vr18, vr11, vr17 */
	addl     -32(%rbp), %r10d
	movl     %r10d, -24(%rbp)
	movl     -24(%rbp), %r11d    /* mov_l    vr11, vr18 */
	movl     %r11d, -80(%rbp)
.L1:
	movl     $250000, -16(%rbp)  /* mov_l    vr19, $250000 */
	movl     -80(%rbp), %r10d    /* cmplt_l  vr20, vr11, vr19 */
	cmpl     -16(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -8(%rbp)
	cmpl     $0, -8(%rbp)        /* cjmp_t   vr20, .L0 */
	jne      .L0
	jmp      .Lread_m500x500_return /* jmp      .Lread_m500x500_return */
.Lread_m500x500_return:
	addq     $96, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $6000000 */
	movq     %rsp, %rbp
	subq     $6000592, %rsp
	movl     $500, -6000528(%rbp) /* mov_l    vr18, $500 */
	movl     -6000528(%rbp), %r10d /* mov_l    vr10, vr18 */
	movl     %r10d, -6000592(%rbp)
	movl     $250000, -6000520(%rbp) /* mov_l    vr19, $250000 */
	movl     -6000520(%rbp), %r11d /* mov_l    vr11, vr19 */
	movl     %r11d, -6000584(%rbp)
	leaq     -6000000(%rbp), %r10 /* localaddr vr20, $0 */
	movq     %r10, -6000512(%rbp)
	movq     -6000512(%rbp), %rdi /* mov_q    vr1, vr20 */
	call     read_m500x500       /* call     read_m500x500 */
	leaq     -4000000(%rbp), %r10 /* localaddr vr22, $2000000 */
	movq     %r10, -6000496(%rbp)
	movq     -6000496(%rbp), %rdi /* mov_q    vr1, vr22 */
	call     read_m500x500       /* call     read_m500x500 */
	movl     $0, -6000480(%rbp)  /* mov_l    vr24, $0 */
	movl     -6000480(%rbp), %r10d /* mov_l    vr13, vr24 */
	movl     %r10d, -6000568(%rbp)
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -2000000(%rbp), %r10 /* localaddr vr25, $4000000 */
	movq     %r10, -6000472(%rbp)
	movl     -6000568(%rbp), %r11d /* sconv_lq vr26, vr13 */
	movslq   %r11d, %r11
	movq     %r11, -6000464(%rbp)
	movq     -6000464(%rbp), %r10 /* mul_q    vr27, vr26, $8 */
	imulq    $8, %r10
	movq     %r10, -6000456(%rbp)
	movq     -6000472(%rbp), %r11 /* add_q    vr28, vr25, vr27 */
	addq     -6000456(%rbp), %r11
	movq     %r11, -6000448(%rbp)
	movq     $0, -6000440(%rbp)  /* mov_q    vr29, $0 */
	movq     -6000448(%rbp), %r10 /* mov_q    (vr28), vr29 */
	movq     -6000440(%rbp), %r11
	movq     %r11, (%r10)
	movl     $1, -6000432(%rbp)  /* mov_l    vr30, $1 */
	movl     -6000568(%rbp), %r10d /* add_l    vr31, vr13, vr30 */
	addl     -6000432(%rbp), %r10d
	movl     %r10d, -6000424(%rbp)
	movl     -6000424(%rbp), %r11d /* mov_l    vr13, vr31 */
	movl     %r11d, -6000568(%rbp)
.L3:
	movl     -6000568(%rbp), %r10d /* cmplt_l  vr32, vr13, vr11 */
	cmpl     -6000584(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000416(%rbp)
	cmpl     $0, -6000416(%rbp)  /* cjmp_t   vr32, .L2 */
	jne      .L2
	movl     $0, -6000408(%rbp)  /* mov_l    vr33, $0 */
	movl     -6000408(%rbp), %r11d /* mov_l    vr15, vr33 */
	movl     %r11d, -6000552(%rbp)
	jmp      .L5                 /* jmp      .L5 */
.L4:
	movl     $0, -6000400(%rbp)  /* mov_l    vr34, $0 */
	movl     -6000400(%rbp), %r10d /* mov_l    vr13, vr34 */
	movl     %r10d, -6000568(%rbp)
	jmp      .L7                 /* jmp      .L7 */
.L6:
	leaq     -6000000(%rbp), %r10 /* localaddr vr35, $0 */
	movq     %r10, -6000392(%rbp)
	movl     -6000592(%rbp), %r11d /* mul_l    vr36, vr13, vr10 */
	movl     -6000568(%rbp), %r10d
	imull    %r11d, %r10d
	movl     %r10d, -6000384(%rbp)
	movl     -6000384(%rbp), %r11d /* add_l    vr37, vr36, vr15 */
	addl     -6000552(%rbp), %r11d
	movl     %r11d, -6000376(%rbp)
	movl     -6000376(%rbp), %r10d /* sconv_lq vr38, vr37 */
	movslq   %r10d, %r10
	movq     %r10, -6000368(%rbp)
	movq     -6000368(%rbp), %r11 /* mul_q    vr39, vr38, $8 */
	imulq    $8, %r11
	movq     %r11, -6000360(%rbp)
	movq     -6000392(%rbp), %r10 /* add_q    vr40, vr35, vr39 */
	addq     -6000360(%rbp), %r10
	movq     %r10, -6000352(%rbp)
	movq     -6000352(%rbp), %r11 /* mov_q    vr16, (vr40) */
	movq     (%r11), %r10
	movq     %r10, -6000544(%rbp)
	movl     $0, -6000344(%rbp)  /* mov_l    vr41, $0 */
	movl     -6000344(%rbp), %r11d /* mov_l    vr14, vr41 */
	movl     %r11d, -6000560(%rbp)
	jmp      .L9                 /* jmp      .L9 */
.L8:
	leaq     -2000000(%rbp), %r10 /* localaddr vr42, $4000000 */
	movq     %r10, -6000336(%rbp)
	movl     -6000592(%rbp), %r10d /* mul_l    vr43, vr13, vr10 */
	movl     -6000568(%rbp), %r11d
	imull    %r10d, %r11d
	movl     %r11d, -6000328(%rbp)
	movl     -6000328(%rbp), %r10d /* add_l    vr44, vr43, vr14 */
	addl     -6000560(%rbp), %r10d
	movl     %r10d, -6000320(%rbp)
	movl     -6000320(%rbp), %r11d /* sconv_lq vr45, vr44 */
	movslq   %r11d, %r11
	movq     %r11, -6000312(%rbp)
	movq     -6000312(%rbp), %r10 /* mul_q    vr46, vr45, $8 */
	imulq    $8, %r10
	movq     %r10, -6000304(%rbp)
	movq     -6000336(%rbp), %r11 /* add_q    vr47, vr42, vr46 */
	addq     -6000304(%rbp), %r11
	movq     %r11, -6000296(%rbp)
	movq     -6000296(%rbp), %r10 /* mov_q    vr17, (vr47) */
	movq     (%r10), %r11
	movq     %r11, -6000536(%rbp)
	leaq     -4000000(%rbp), %r10 /* localaddr vr48, $2000000 */
	movq     %r10, -6000288(%rbp)
	movl     -6000592(%rbp), %r10d /* mul_l    vr49, vr15, vr10 */
	movl     -6000552(%rbp), %r11d
	imull    %r10d, %r11d
	movl     %r11d, -6000280(%rbp)
	movl     -6000280(%rbp), %r10d /* add_l    vr50, vr49, vr14 */
	addl     -6000560(%rbp), %r10d
	movl     %r10d, -6000272(%rbp)
	movl     -6000272(%rbp), %r11d /* sconv_lq vr51, vr50 */
	movslq   %r11d, %r11
	movq     %r11, -6000264(%rbp)
	movq     -6000264(%rbp), %r10 /* mul_q    vr52, vr51, $8 */
	imulq    $8, %r10
	movq     %r10, -6000256(%rbp)
	movq     -6000288(%rbp), %r11 /* add_q    vr53, vr48, vr52 */
	addq     -6000256(%rbp), %r11
	movq     %r11, -6000248(%rbp)
	movq     -6000248(%rbp), %r10 /* mov_q    vr55, (vr53) */
	movq     (%r10), %r11
	movq     %r11, -6000232(%rbp)
	movq     -6000232(%rbp), %r10 /* mul_q    vr54, vr16, vr55 */
	movq     -6000544(%rbp), %r11
	imulq    %r10, %r11
	movq     %r11, -6000240(%rbp)
	movq     -6000536(%rbp), %r10 /* add_q    vr56, vr17, vr54 */
	addq     -6000240(%rbp), %r10
	movq     %r10, -6000224(%rbp)
	movq     -6000224(%rbp), %r11 /* mov_q    vr17, vr56 */
	movq     %r11, -6000536(%rbp)
	leaq     -2000000(%rbp), %r10 /* localaddr vr57, $4000000 */
	movq     %r10, -6000216(%rbp)
	movl     -6000592(%rbp), %r10d /* mul_l    vr58, vr13, vr10 */
	movl     -6000568(%rbp), %r11d
	imull    %r10d, %r11d
	movl     %r11d, -6000208(%rbp)
	movl     -6000208(%rbp), %r10d /* add_l    vr59, vr58, vr14 */
	addl     -6000560(%rbp), %r10d
	movl     %r10d, -6000200(%rbp)
	movl     -6000200(%rbp), %r11d /* sconv_lq vr60, vr59 */
	movslq   %r11d, %r11
	movq     %r11, -6000192(%rbp)
	movq     -6000192(%rbp), %r10 /* mul_q    vr61, vr60, $8 */
	imulq    $8, %r10
	movq     %r10, -6000184(%rbp)
	movq     -6000216(%rbp), %r11 /* add_q    vr62, vr57, vr61 */
	addq     -6000184(%rbp), %r11
	movq     %r11, -6000176(%rbp)
	movq     -6000176(%rbp), %r10 /* mov_q    (vr62), vr17 */
	movq     -6000536(%rbp), %r11
	movq     %r11, (%r10)
	movl     $1, -6000168(%rbp)  /* mov_l    vr63, $1 */
	movl     -6000560(%rbp), %r10d /* add_l    vr64, vr14, vr63 */
	addl     -6000168(%rbp), %r10d
	movl     %r10d, -6000160(%rbp)
	movl     -6000160(%rbp), %r11d /* mov_l    vr14, vr64 */
	movl     %r11d, -6000560(%rbp)
.L9:
	movl     -6000560(%rbp), %r10d /* cmplt_l  vr65, vr14, vr10 */
	cmpl     -6000592(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000152(%rbp)
	cmpl     $0, -6000152(%rbp)  /* cjmp_t   vr65, .L8 */
	jne      .L8
	movl     $1, -6000144(%rbp)  /* mov_l    vr66, $1 */
	movl     -6000568(%rbp), %r11d /* add_l    vr67, vr13, vr66 */
	addl     -6000144(%rbp), %r11d
	movl     %r11d, -6000136(%rbp)
	movl     -6000136(%rbp), %r10d /* mov_l    vr13, vr67 */
	movl     %r10d, -6000568(%rbp)
.L7:
	movl     -6000568(%rbp), %r11d /* cmplt_l  vr68, vr13, vr10 */
	cmpl     -6000592(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -6000128(%rbp)
	cmpl     $0, -6000128(%rbp)  /* cjmp_t   vr68, .L6 */
	jne      .L6
	movl     $1, -6000120(%rbp)  /* mov_l    vr69, $1 */
	movl     -6000552(%rbp), %r10d /* add_l    vr70, vr15, vr69 */
	addl     -6000120(%rbp), %r10d
	movl     %r10d, -6000112(%rbp)
	movl     -6000112(%rbp), %r11d /* mov_l    vr15, vr70 */
	movl     %r11d, -6000552(%rbp)
.L5:
	movl     -6000552(%rbp), %r10d /* cmplt_l  vr71, vr15, vr10 */
	cmpl     -6000592(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000104(%rbp)
	cmpl     $0, -6000104(%rbp)  /* cjmp_t   vr71, .L4 */
	jne      .L4
	movl     $0, -6000096(%rbp)  /* mov_l    vr72, $0 */
	movl     -6000096(%rbp), %r11d /* mov_l    vr13, vr72 */
	movl     %r11d, -6000568(%rbp)
	jmp      .L11                /* jmp      .L11 */
.L10:
	leaq     -2000000(%rbp), %r10 /* localaddr vr73, $4000000 */
	movq     %r10, -6000088(%rbp)
	movl     -6000568(%rbp), %r10d /* sconv_lq vr74, vr13 */
	movslq   %r10d, %r10
	movq     %r10, -6000080(%rbp)
	movq     -6000080(%rbp), %r11 /* mul_q    vr75, vr74, $8 */
	imulq    $8, %r11
	movq     %r11, -6000072(%rbp)
	movq     -6000088(%rbp), %r10 /* add_q    vr76, vr73, vr75 */
	addq     -6000072(%rbp), %r10
	movq     %r10, -6000064(%rbp)
	movq     -6000064(%rbp), %r11 /* mov_q    vr1, (vr76) */
	movq     (%r11), %rdi
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     $1, -6000040(%rbp)  /* mov_l    vr79, $1 */
	movl     -6000568(%rbp), %r10d /* add_l    vr80, vr13, vr79 */
	addl     -6000040(%rbp), %r10d
	movl     %r10d, -6000032(%rbp)
	movl     -6000032(%rbp), %r11d /* mov_l    vr13, vr80 */
	movl     %r11d, -6000568(%rbp)
.L11:
	movl     $250000, -6000024(%rbp) /* mov_l    vr81, $250000 */
	movl     -6000568(%rbp), %r10d /* cmplt_l  vr82, vr13, vr81 */
	cmpl     -6000024(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000016(%rbp)
	cmpl     $0, -6000016(%rbp)  /* cjmp_t   vr82, .L10 */
	jne      .L10
	movl     $0, -6000008(%rbp)  /* mov_l    vr83, $0 */
	movl     -6000008(%rbp), %eax /* mov_l    vr0, vr83 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $6000592, %rsp      /* leave    $6000000 */
	popq     %rbp
	ret                          /* ret       */
