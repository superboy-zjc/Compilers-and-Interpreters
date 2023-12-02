/* arr is stored in the 1, at the offset of 10 */ 
/* i is stored in the 1, at the offset of 11 */
/* a is stored in the 0, at the offset of 0 */
/* b is stored in the 0, at the offset of 800 */
/* c is stored in the 0, at the offset of 1600 */
/* M is stored in the 1, at the offset of 10 */
/* i is stored in the 1, at the offset of 11 */
/* j is stored in the 1, at the offset of 12 */
/* k is stored in the 1, at the offset of 13 */
/* r is stored in the 1, at the offset of 14 */
/* val is stored in the 1, at the offset of 15 */
	.section .text

	.globl read_m10x10
read_m10x10:
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
	movl     $100, -16(%rbp)     /* mov_l    vr19, $100 */
	movl     -80(%rbp), %r10d    /* cmplt_l  vr20, vr11, vr19 */
	cmpl     -16(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -8(%rbp)
	cmpl     $0, -8(%rbp)        /* cjmp_t   vr20, .L0 */
	jne      .L0
	jmp      .Lread_m10x10_return /* jmp      .Lread_m10x10_return */
.Lread_m10x10_return:
	addq     $96, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $2400 */
	movq     %rsp, %rbp
	subq     $2976, %rsp
	movl     $10, -2928(%rbp)    /* mov_l    vr16, $10 */
	movl     -2928(%rbp), %r10d  /* mov_l    vr10, vr16 */
	movl     %r10d, -2976(%rbp)
	leaq     -2400(%rbp), %r10   /* localaddr vr17, $0 */
	movq     %r10, -2920(%rbp)
	movq     -2920(%rbp), %rdi   /* mov_q    vr1, vr17 */
	call     read_m10x10         /* call     read_m10x10 */
	leaq     -1600(%rbp), %r10   /* localaddr vr19, $800 */
	movq     %r10, -2904(%rbp)
	movq     -2904(%rbp), %rdi   /* mov_q    vr1, vr19 */
	call     read_m10x10         /* call     read_m10x10 */
	movl     $0, -2888(%rbp)     /* mov_l    vr21, $0 */
	movl     -2888(%rbp), %r11d  /* mov_l    vr11, vr21 */
	movl     %r11d, -2968(%rbp)
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -800(%rbp), %r10    /* localaddr vr22, $1600 */
	movq     %r10, -2880(%rbp)
	movl     -2968(%rbp), %r10d  /* sconv_lq vr23, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -2872(%rbp)
	movq     -2872(%rbp), %r11   /* mul_q    vr24, vr23, $8 */
	imulq    $8, %r11
	movq     %r11, -2864(%rbp)
	movq     -2880(%rbp), %r10   /* add_q    vr25, vr22, vr24 */
	addq     -2864(%rbp), %r10
	movq     %r10, -2856(%rbp)
	movq     $0, -2848(%rbp)     /* mov_q    vr26, $0 */
	movq     -2856(%rbp), %r11   /* mov_q    (vr25), vr26 */
	movq     -2848(%rbp), %r10
	movq     %r10, (%r11)
	movl     $1, -2840(%rbp)     /* mov_l    vr27, $1 */
	movl     -2968(%rbp), %r11d  /* add_l    vr28, vr11, vr27 */
	addl     -2840(%rbp), %r11d
	movl     %r11d, -2832(%rbp)
	movl     -2832(%rbp), %r10d  /* mov_l    vr11, vr28 */
	movl     %r10d, -2968(%rbp)
.L3:
	movl     $100, -2824(%rbp)   /* mov_l    vr29, $100 */
	movl     -2968(%rbp), %r11d  /* cmplt_l  vr30, vr11, vr29 */
	cmpl     -2824(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -2816(%rbp)
	cmpl     $0, -2816(%rbp)     /* cjmp_t   vr30, .L2 */
	jne      .L2
	movl     $0, -2808(%rbp)     /* mov_l    vr31, $0 */
	movl     -2808(%rbp), %r10d  /* mov_l    vr13, vr31 */
	movl     %r10d, -2952(%rbp)
	jmp      .L5                 /* jmp      .L5 */
.L4:
	movl     $0, -2800(%rbp)     /* mov_l    vr32, $0 */
	movl     -2800(%rbp), %r11d  /* mov_l    vr11, vr32 */
	movl     %r11d, -2968(%rbp)
	jmp      .L7                 /* jmp      .L7 */
.L6:
	leaq     -2400(%rbp), %r10   /* localaddr vr33, $0 */
	movq     %r10, -2792(%rbp)
	movl     -2976(%rbp), %r10d  /* mul_l    vr34, vr11, vr10 */
	movl     -2968(%rbp), %r11d
	imull    %r10d, %r11d
	movl     %r11d, -2784(%rbp)
	movl     -2784(%rbp), %r10d  /* add_l    vr35, vr34, vr13 */
	addl     -2952(%rbp), %r10d
	movl     %r10d, -2776(%rbp)
	movl     -2776(%rbp), %r11d  /* sconv_lq vr36, vr35 */
	movslq   %r11d, %r11
	movq     %r11, -2768(%rbp)
	movq     -2768(%rbp), %r10   /* mul_q    vr37, vr36, $8 */
	imulq    $8, %r10
	movq     %r10, -2760(%rbp)
	movq     -2792(%rbp), %r11   /* add_q    vr38, vr33, vr37 */
	addq     -2760(%rbp), %r11
	movq     %r11, -2752(%rbp)
	movq     -2752(%rbp), %r10   /* mov_q    vr14, (vr38) */
	movq     (%r10), %r11
	movq     %r11, -2944(%rbp)
	movl     $0, -2744(%rbp)     /* mov_l    vr39, $0 */
	movl     -2744(%rbp), %r10d  /* mov_l    vr12, vr39 */
	movl     %r10d, -2960(%rbp)
	jmp      .L9                 /* jmp      .L9 */
.L8:
	leaq     -800(%rbp), %r10    /* localaddr vr40, $1600 */
	movq     %r10, -2736(%rbp)
	movl     -2976(%rbp), %r11d  /* mul_l    vr41, vr11, vr10 */
	movl     -2968(%rbp), %r10d
	imull    %r11d, %r10d
	movl     %r10d, -2728(%rbp)
	movl     -2728(%rbp), %r11d  /* add_l    vr42, vr41, vr12 */
	addl     -2960(%rbp), %r11d
	movl     %r11d, -2720(%rbp)
	movl     -2720(%rbp), %r10d  /* sconv_lq vr43, vr42 */
	movslq   %r10d, %r10
	movq     %r10, -2712(%rbp)
	movq     -2712(%rbp), %r11   /* mul_q    vr44, vr43, $8 */
	imulq    $8, %r11
	movq     %r11, -2704(%rbp)
	movq     -2736(%rbp), %r10   /* add_q    vr45, vr40, vr44 */
	addq     -2704(%rbp), %r10
	movq     %r10, -2696(%rbp)
	movq     -2696(%rbp), %r11   /* mov_q    vr15, (vr45) */
	movq     (%r11), %r10
	movq     %r10, -2936(%rbp)
	leaq     -1600(%rbp), %r10   /* localaddr vr46, $800 */
	movq     %r10, -2688(%rbp)
	movl     -2976(%rbp), %r11d  /* mul_l    vr47, vr13, vr10 */
	movl     -2952(%rbp), %r10d
	imull    %r11d, %r10d
	movl     %r10d, -2680(%rbp)
	movl     -2680(%rbp), %r11d  /* add_l    vr48, vr47, vr12 */
	addl     -2960(%rbp), %r11d
	movl     %r11d, -2672(%rbp)
	movl     -2672(%rbp), %r10d  /* sconv_lq vr49, vr48 */
	movslq   %r10d, %r10
	movq     %r10, -2664(%rbp)
	movq     -2664(%rbp), %r11   /* mul_q    vr50, vr49, $8 */
	imulq    $8, %r11
	movq     %r11, -2656(%rbp)
	movq     -2688(%rbp), %r10   /* add_q    vr51, vr46, vr50 */
	addq     -2656(%rbp), %r10
	movq     %r10, -2648(%rbp)
	movq     -2648(%rbp), %r11   /* mov_q    vr53, (vr51) */
	movq     (%r11), %r10
	movq     %r10, -2632(%rbp)
	movq     -2632(%rbp), %r11   /* mul_q    vr52, vr14, vr53 */
	movq     -2944(%rbp), %r10
	imulq    %r11, %r10
	movq     %r10, -2640(%rbp)
	movq     -2936(%rbp), %r11   /* add_q    vr54, vr15, vr52 */
	addq     -2640(%rbp), %r11
	movq     %r11, -2624(%rbp)
	movq     -2624(%rbp), %r10   /* mov_q    vr15, vr54 */
	movq     %r10, -2936(%rbp)
	leaq     -800(%rbp), %r10    /* localaddr vr55, $1600 */
	movq     %r10, -2616(%rbp)
	movl     -2976(%rbp), %r11d  /* mul_l    vr56, vr11, vr10 */
	movl     -2968(%rbp), %r10d
	imull    %r11d, %r10d
	movl     %r10d, -2608(%rbp)
	movl     -2608(%rbp), %r11d  /* add_l    vr57, vr56, vr12 */
	addl     -2960(%rbp), %r11d
	movl     %r11d, -2600(%rbp)
	movl     -2600(%rbp), %r10d  /* sconv_lq vr58, vr57 */
	movslq   %r10d, %r10
	movq     %r10, -2592(%rbp)
	movq     -2592(%rbp), %r11   /* mul_q    vr59, vr58, $8 */
	imulq    $8, %r11
	movq     %r11, -2584(%rbp)
	movq     -2616(%rbp), %r10   /* add_q    vr60, vr55, vr59 */
	addq     -2584(%rbp), %r10
	movq     %r10, -2576(%rbp)
	movq     -2576(%rbp), %r11   /* mov_q    (vr60), vr15 */
	movq     -2936(%rbp), %r10
	movq     %r10, (%r11)
	movl     $1, -2568(%rbp)     /* mov_l    vr61, $1 */
	movl     -2960(%rbp), %r11d  /* add_l    vr62, vr12, vr61 */
	addl     -2568(%rbp), %r11d
	movl     %r11d, -2560(%rbp)
	movl     -2560(%rbp), %r10d  /* mov_l    vr12, vr62 */
	movl     %r10d, -2960(%rbp)
.L9:
	movl     -2960(%rbp), %r11d  /* cmplt_l  vr63, vr12, vr10 */
	cmpl     -2976(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -2552(%rbp)
	cmpl     $0, -2552(%rbp)     /* cjmp_t   vr63, .L8 */
	jne      .L8
	movl     $1, -2544(%rbp)     /* mov_l    vr64, $1 */
	movl     -2968(%rbp), %r10d  /* add_l    vr65, vr11, vr64 */
	addl     -2544(%rbp), %r10d
	movl     %r10d, -2536(%rbp)
	movl     -2536(%rbp), %r11d  /* mov_l    vr11, vr65 */
	movl     %r11d, -2968(%rbp)
.L7:
	movl     -2968(%rbp), %r10d  /* cmplt_l  vr66, vr11, vr10 */
	cmpl     -2976(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -2528(%rbp)
	cmpl     $0, -2528(%rbp)     /* cjmp_t   vr66, .L6 */
	jne      .L6
	movl     $1, -2520(%rbp)     /* mov_l    vr67, $1 */
	movl     -2952(%rbp), %r11d  /* add_l    vr68, vr13, vr67 */
	addl     -2520(%rbp), %r11d
	movl     %r11d, -2512(%rbp)
	movl     -2512(%rbp), %r10d  /* mov_l    vr13, vr68 */
	movl     %r10d, -2952(%rbp)
.L5:
	movl     -2952(%rbp), %r11d  /* cmplt_l  vr69, vr13, vr10 */
	cmpl     -2976(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -2504(%rbp)
	cmpl     $0, -2504(%rbp)     /* cjmp_t   vr69, .L4 */
	jne      .L4
	movl     $0, -2496(%rbp)     /* mov_l    vr70, $0 */
	movl     -2496(%rbp), %r10d  /* mov_l    vr11, vr70 */
	movl     %r10d, -2968(%rbp)
	jmp      .L11                /* jmp      .L11 */
.L10:
	leaq     -800(%rbp), %r10    /* localaddr vr71, $1600 */
	movq     %r10, -2488(%rbp)
	movl     -2968(%rbp), %r11d  /* sconv_lq vr72, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -2480(%rbp)
	movq     -2480(%rbp), %r10   /* mul_q    vr73, vr72, $8 */
	imulq    $8, %r10
	movq     %r10, -2472(%rbp)
	movq     -2488(%rbp), %r11   /* add_q    vr74, vr71, vr73 */
	addq     -2472(%rbp), %r11
	movq     %r11, -2464(%rbp)
	movq     -2464(%rbp), %r10   /* mov_q    vr1, (vr74) */
	movq     (%r10), %rdi
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     $1, -2440(%rbp)     /* mov_l    vr77, $1 */
	movl     -2968(%rbp), %r11d  /* add_l    vr78, vr11, vr77 */
	addl     -2440(%rbp), %r11d
	movl     %r11d, -2432(%rbp)
	movl     -2432(%rbp), %r10d  /* mov_l    vr11, vr78 */
	movl     %r10d, -2968(%rbp)
.L11:
	movl     $100, -2424(%rbp)   /* mov_l    vr79, $100 */
	movl     -2968(%rbp), %r11d  /* cmplt_l  vr80, vr11, vr79 */
	cmpl     -2424(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -2416(%rbp)
	cmpl     $0, -2416(%rbp)     /* cjmp_t   vr80, .L10 */
	jne      .L10
	movl     $0, -2408(%rbp)     /* mov_l    vr81, $0 */
	movl     -2408(%rbp), %eax   /* mov_l    vr0, vr81 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $2976, %rsp         /* leave    $2400 */
	popq     %rbp
	ret                          /* ret       */
