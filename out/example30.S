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
	subq     $3232, %rsp
	movl     $10, -3184(%rbp)    /* mov_l    vr16, $10 */
	movl     -3184(%rbp), %r10d  /* mov_l    vr10, vr16 */
	movl     %r10d, -3232(%rbp)
	leaq     -2400(%rbp), %r10   /* localaddr vr17, $0 */
	movq     %r10, -3176(%rbp)
	movl     $0, -3168(%rbp)     /* mov_l    vr18, $0 */
	movl     -3168(%rbp), %r11d  /* sconv_lq vr19, vr18 */
	movslq   %r11d, %r11
	movq     %r11, -3160(%rbp)
	movq     -3160(%rbp), %r10   /* mul_q    vr20, vr19, $80 */
	imulq    $80, %r10
	movq     %r10, -3152(%rbp)
	movq     -3176(%rbp), %r11   /* add_q    vr21, vr17, vr20 */
	addq     -3152(%rbp), %r11
	movq     %r11, -3144(%rbp)
	movl     $0, -3136(%rbp)     /* mov_l    vr22, $0 */
	movl     -3136(%rbp), %r10d  /* sconv_lq vr23, vr22 */
	movslq   %r10d, %r10
	movq     %r10, -3128(%rbp)
	movq     -3128(%rbp), %r11   /* mul_q    vr24, vr23, $8 */
	imulq    $8, %r11
	movq     %r11, -3120(%rbp)
	movq     -3144(%rbp), %r10   /* add_q    vr25, vr21, vr24 */
	addq     -3120(%rbp), %r10
	movq     %r10, -3112(%rbp)
	movq     -3112(%rbp), %rdi   /* mov_q    vr1, vr25 */
	call     read_m10x10         /* call     read_m10x10 */
	leaq     -1600(%rbp), %r10   /* localaddr vr27, $800 */
	movq     %r10, -3096(%rbp)
	movl     $0, -3088(%rbp)     /* mov_l    vr28, $0 */
	movl     -3088(%rbp), %r11d  /* sconv_lq vr29, vr28 */
	movslq   %r11d, %r11
	movq     %r11, -3080(%rbp)
	movq     -3080(%rbp), %r10   /* mul_q    vr30, vr29, $80 */
	imulq    $80, %r10
	movq     %r10, -3072(%rbp)
	movq     -3096(%rbp), %r11   /* add_q    vr31, vr27, vr30 */
	addq     -3072(%rbp), %r11
	movq     %r11, -3064(%rbp)
	movl     $0, -3056(%rbp)     /* mov_l    vr32, $0 */
	movl     -3056(%rbp), %r10d  /* sconv_lq vr33, vr32 */
	movslq   %r10d, %r10
	movq     %r10, -3048(%rbp)
	movq     -3048(%rbp), %r11   /* mul_q    vr34, vr33, $8 */
	imulq    $8, %r11
	movq     %r11, -3040(%rbp)
	movq     -3064(%rbp), %r10   /* add_q    vr35, vr31, vr34 */
	addq     -3040(%rbp), %r10
	movq     %r10, -3032(%rbp)
	movq     -3032(%rbp), %rdi   /* mov_q    vr1, vr35 */
	call     read_m10x10         /* call     read_m10x10 */
	movl     $0, -3016(%rbp)     /* mov_l    vr37, $0 */
	movl     -3016(%rbp), %r11d  /* mov_l    vr11, vr37 */
	movl     %r11d, -3224(%rbp)
	jmp      .L3                 /* jmp      .L3 */
.L2:
	movl     $0, -3008(%rbp)     /* mov_l    vr38, $0 */
	movl     -3008(%rbp), %r10d  /* mov_l    vr12, vr38 */
	movl     %r10d, -3216(%rbp)
	jmp      .L5                 /* jmp      .L5 */
.L4:
	leaq     -800(%rbp), %r10    /* localaddr vr39, $1600 */
	movq     %r10, -3000(%rbp)
	movl     -3224(%rbp), %r11d  /* sconv_lq vr40, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -2992(%rbp)
	movq     -2992(%rbp), %r10   /* mul_q    vr41, vr40, $80 */
	imulq    $80, %r10
	movq     %r10, -2984(%rbp)
	movq     -3000(%rbp), %r11   /* add_q    vr42, vr39, vr41 */
	addq     -2984(%rbp), %r11
	movq     %r11, -2976(%rbp)
	movl     -3216(%rbp), %r10d  /* sconv_lq vr43, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -2968(%rbp)
	movq     -2968(%rbp), %r11   /* mul_q    vr44, vr43, $8 */
	imulq    $8, %r11
	movq     %r11, -2960(%rbp)
	movq     -2976(%rbp), %r10   /* add_q    vr45, vr42, vr44 */
	addq     -2960(%rbp), %r10
	movq     %r10, -2952(%rbp)
	movq     $0, -2944(%rbp)     /* mov_q    vr46, $0 */
	movq     -2952(%rbp), %r11   /* mov_q    (vr45), vr46 */
	movq     -2944(%rbp), %r10
	movq     %r10, (%r11)
	movl     $1, -2936(%rbp)     /* mov_l    vr47, $1 */
	movl     -3216(%rbp), %r11d  /* add_l    vr48, vr12, vr47 */
	addl     -2936(%rbp), %r11d
	movl     %r11d, -2928(%rbp)
	movl     -2928(%rbp), %r10d  /* mov_l    vr12, vr48 */
	movl     %r10d, -3216(%rbp)
.L5:
	movl     -3216(%rbp), %r11d  /* cmplt_l  vr49, vr12, vr10 */
	cmpl     -3232(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -2920(%rbp)
	cmpl     $0, -2920(%rbp)     /* cjmp_t   vr49, .L4 */
	jne      .L4
	movl     $1, -2912(%rbp)     /* mov_l    vr50, $1 */
	movl     -3224(%rbp), %r10d  /* add_l    vr51, vr11, vr50 */
	addl     -2912(%rbp), %r10d
	movl     %r10d, -2904(%rbp)
	movl     -2904(%rbp), %r11d  /* mov_l    vr11, vr51 */
	movl     %r11d, -3224(%rbp)
.L3:
	movl     -3224(%rbp), %r10d  /* cmplt_l  vr52, vr11, vr10 */
	cmpl     -3232(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -2896(%rbp)
	cmpl     $0, -2896(%rbp)     /* cjmp_t   vr52, .L2 */
	jne      .L2
	movl     $0, -2888(%rbp)     /* mov_l    vr53, $0 */
	movl     -2888(%rbp), %r11d  /* mov_l    vr13, vr53 */
	movl     %r11d, -3208(%rbp)
	jmp      .L7                 /* jmp      .L7 */
.L6:
	movl     $0, -2880(%rbp)     /* mov_l    vr54, $0 */
	movl     -2880(%rbp), %r10d  /* mov_l    vr11, vr54 */
	movl     %r10d, -3224(%rbp)
	jmp      .L9                 /* jmp      .L9 */
.L8:
	leaq     -2400(%rbp), %r10   /* localaddr vr55, $0 */
	movq     %r10, -2872(%rbp)
	movl     -3224(%rbp), %r11d  /* sconv_lq vr56, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -2864(%rbp)
	movq     -2864(%rbp), %r10   /* mul_q    vr57, vr56, $80 */
	imulq    $80, %r10
	movq     %r10, -2856(%rbp)
	movq     -2872(%rbp), %r11   /* add_q    vr58, vr55, vr57 */
	addq     -2856(%rbp), %r11
	movq     %r11, -2848(%rbp)
	movl     -3208(%rbp), %r10d  /* sconv_lq vr59, vr13 */
	movslq   %r10d, %r10
	movq     %r10, -2840(%rbp)
	movq     -2840(%rbp), %r11   /* mul_q    vr60, vr59, $8 */
	imulq    $8, %r11
	movq     %r11, -2832(%rbp)
	movq     -2848(%rbp), %r10   /* add_q    vr61, vr58, vr60 */
	addq     -2832(%rbp), %r10
	movq     %r10, -2824(%rbp)
	movq     -2824(%rbp), %r11   /* mov_q    vr14, (vr61) */
	movq     (%r11), %r10
	movq     %r10, -3200(%rbp)
	movl     $0, -2816(%rbp)     /* mov_l    vr62, $0 */
	movl     -2816(%rbp), %r11d  /* mov_l    vr12, vr62 */
	movl     %r11d, -3216(%rbp)
	jmp      .L11                /* jmp      .L11 */
.L10:
	leaq     -800(%rbp), %r10    /* localaddr vr63, $1600 */
	movq     %r10, -2808(%rbp)
	movl     -3224(%rbp), %r10d  /* sconv_lq vr64, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -2800(%rbp)
	movq     -2800(%rbp), %r11   /* mul_q    vr65, vr64, $80 */
	imulq    $80, %r11
	movq     %r11, -2792(%rbp)
	movq     -2808(%rbp), %r10   /* add_q    vr66, vr63, vr65 */
	addq     -2792(%rbp), %r10
	movq     %r10, -2784(%rbp)
	movl     -3216(%rbp), %r11d  /* sconv_lq vr67, vr12 */
	movslq   %r11d, %r11
	movq     %r11, -2776(%rbp)
	movq     -2776(%rbp), %r10   /* mul_q    vr68, vr67, $8 */
	imulq    $8, %r10
	movq     %r10, -2768(%rbp)
	movq     -2784(%rbp), %r11   /* add_q    vr69, vr66, vr68 */
	addq     -2768(%rbp), %r11
	movq     %r11, -2760(%rbp)
	movq     -2760(%rbp), %r10   /* mov_q    vr15, (vr69) */
	movq     (%r10), %r11
	movq     %r11, -3192(%rbp)
	leaq     -1600(%rbp), %r10   /* localaddr vr70, $800 */
	movq     %r10, -2752(%rbp)
	movl     -3208(%rbp), %r10d  /* sconv_lq vr71, vr13 */
	movslq   %r10d, %r10
	movq     %r10, -2744(%rbp)
	movq     -2744(%rbp), %r11   /* mul_q    vr72, vr71, $80 */
	imulq    $80, %r11
	movq     %r11, -2736(%rbp)
	movq     -2752(%rbp), %r10   /* add_q    vr73, vr70, vr72 */
	addq     -2736(%rbp), %r10
	movq     %r10, -2728(%rbp)
	movl     -3216(%rbp), %r11d  /* sconv_lq vr74, vr12 */
	movslq   %r11d, %r11
	movq     %r11, -2720(%rbp)
	movq     -2720(%rbp), %r10   /* mul_q    vr75, vr74, $8 */
	imulq    $8, %r10
	movq     %r10, -2712(%rbp)
	movq     -2728(%rbp), %r11   /* add_q    vr76, vr73, vr75 */
	addq     -2712(%rbp), %r11
	movq     %r11, -2704(%rbp)
	movq     -2704(%rbp), %r10   /* mov_q    vr78, (vr76) */
	movq     (%r10), %r11
	movq     %r11, -2688(%rbp)
	movq     -2688(%rbp), %r10   /* mul_q    vr77, vr14, vr78 */
	movq     -3200(%rbp), %r11
	imulq    %r10, %r11
	movq     %r11, -2696(%rbp)
	movq     -3192(%rbp), %r10   /* add_q    vr79, vr15, vr77 */
	addq     -2696(%rbp), %r10
	movq     %r10, -2680(%rbp)
	movq     -2680(%rbp), %r11   /* mov_q    vr15, vr79 */
	movq     %r11, -3192(%rbp)
	leaq     -800(%rbp), %r10    /* localaddr vr80, $1600 */
	movq     %r10, -2672(%rbp)
	movl     -3224(%rbp), %r10d  /* sconv_lq vr81, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -2664(%rbp)
	movq     -2664(%rbp), %r11   /* mul_q    vr82, vr81, $80 */
	imulq    $80, %r11
	movq     %r11, -2656(%rbp)
	movq     -2672(%rbp), %r10   /* add_q    vr83, vr80, vr82 */
	addq     -2656(%rbp), %r10
	movq     %r10, -2648(%rbp)
	movl     -3216(%rbp), %r11d  /* sconv_lq vr84, vr12 */
	movslq   %r11d, %r11
	movq     %r11, -2640(%rbp)
	movq     -2640(%rbp), %r10   /* mul_q    vr85, vr84, $8 */
	imulq    $8, %r10
	movq     %r10, -2632(%rbp)
	movq     -2648(%rbp), %r11   /* add_q    vr86, vr83, vr85 */
	addq     -2632(%rbp), %r11
	movq     %r11, -2624(%rbp)
	movq     -2624(%rbp), %r10   /* mov_q    (vr86), vr15 */
	movq     -3192(%rbp), %r11
	movq     %r11, (%r10)
	movl     $1, -2616(%rbp)     /* mov_l    vr87, $1 */
	movl     -3216(%rbp), %r10d  /* add_l    vr88, vr12, vr87 */
	addl     -2616(%rbp), %r10d
	movl     %r10d, -2608(%rbp)
	movl     -2608(%rbp), %r11d  /* mov_l    vr12, vr88 */
	movl     %r11d, -3216(%rbp)
.L11:
	movl     -3216(%rbp), %r10d  /* cmplt_l  vr89, vr12, vr10 */
	cmpl     -3232(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -2600(%rbp)
	cmpl     $0, -2600(%rbp)     /* cjmp_t   vr89, .L10 */
	jne      .L10
	movl     $1, -2592(%rbp)     /* mov_l    vr90, $1 */
	movl     -3224(%rbp), %r11d  /* add_l    vr91, vr11, vr90 */
	addl     -2592(%rbp), %r11d
	movl     %r11d, -2584(%rbp)
	movl     -2584(%rbp), %r10d  /* mov_l    vr11, vr91 */
	movl     %r10d, -3224(%rbp)
.L9:
	movl     -3224(%rbp), %r11d  /* cmplt_l  vr92, vr11, vr10 */
	cmpl     -3232(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -2576(%rbp)
	cmpl     $0, -2576(%rbp)     /* cjmp_t   vr92, .L8 */
	jne      .L8
	movl     $1, -2568(%rbp)     /* mov_l    vr93, $1 */
	movl     -3208(%rbp), %r10d  /* add_l    vr94, vr13, vr93 */
	addl     -2568(%rbp), %r10d
	movl     %r10d, -2560(%rbp)
	movl     -2560(%rbp), %r11d  /* mov_l    vr13, vr94 */
	movl     %r11d, -3208(%rbp)
.L7:
	movl     -3208(%rbp), %r10d  /* cmplt_l  vr95, vr13, vr10 */
	cmpl     -3232(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -2552(%rbp)
	cmpl     $0, -2552(%rbp)     /* cjmp_t   vr95, .L6 */
	jne      .L6
	movl     $0, -2544(%rbp)     /* mov_l    vr96, $0 */
	movl     -2544(%rbp), %r11d  /* mov_l    vr11, vr96 */
	movl     %r11d, -3224(%rbp)
	jmp      .L13                /* jmp      .L13 */
.L12:
	movl     $0, -2536(%rbp)     /* mov_l    vr97, $0 */
	movl     -2536(%rbp), %r10d  /* mov_l    vr12, vr97 */
	movl     %r10d, -3216(%rbp)
	jmp      .L15                /* jmp      .L15 */
.L14:
	leaq     -800(%rbp), %r10    /* localaddr vr98, $1600 */
	movq     %r10, -2528(%rbp)
	movl     -3224(%rbp), %r11d  /* sconv_lq vr99, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -2520(%rbp)
	movq     -2520(%rbp), %r10   /* mul_q    vr100, vr99, $80 */
	imulq    $80, %r10
	movq     %r10, -2512(%rbp)
	movq     -2528(%rbp), %r11   /* add_q    vr101, vr98, vr100 */
	addq     -2512(%rbp), %r11
	movq     %r11, -2504(%rbp)
	movl     -3216(%rbp), %r10d  /* sconv_lq vr102, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -2496(%rbp)
	movq     -2496(%rbp), %r11   /* mul_q    vr103, vr102, $8 */
	imulq    $8, %r11
	movq     %r11, -2488(%rbp)
	movq     -2504(%rbp), %r10   /* add_q    vr104, vr101, vr103 */
	addq     -2488(%rbp), %r10
	movq     %r10, -2480(%rbp)
	movq     -2480(%rbp), %r11   /* mov_q    vr1, (vr104) */
	movq     (%r11), %rdi
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     $1, -2456(%rbp)     /* mov_l    vr107, $1 */
	movl     -3216(%rbp), %r10d  /* add_l    vr108, vr12, vr107 */
	addl     -2456(%rbp), %r10d
	movl     %r10d, -2448(%rbp)
	movl     -2448(%rbp), %r11d  /* mov_l    vr12, vr108 */
	movl     %r11d, -3216(%rbp)
.L15:
	movl     -3216(%rbp), %r10d  /* cmplt_l  vr109, vr12, vr10 */
	cmpl     -3232(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -2440(%rbp)
	cmpl     $0, -2440(%rbp)     /* cjmp_t   vr109, .L14 */
	jne      .L14
	movl     $1, -2432(%rbp)     /* mov_l    vr110, $1 */
	movl     -3224(%rbp), %r11d  /* add_l    vr111, vr11, vr110 */
	addl     -2432(%rbp), %r11d
	movl     %r11d, -2424(%rbp)
	movl     -2424(%rbp), %r10d  /* mov_l    vr11, vr111 */
	movl     %r10d, -3224(%rbp)
.L13:
	movl     -3224(%rbp), %r11d  /* cmplt_l  vr112, vr11, vr10 */
	cmpl     -3232(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -2416(%rbp)
	cmpl     $0, -2416(%rbp)     /* cjmp_t   vr112, .L12 */
	jne      .L12
	movl     $0, -2408(%rbp)     /* mov_l    vr113, $0 */
	movl     -2408(%rbp), %eax   /* mov_l    vr0, vr113 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $3232, %rsp         /* leave    $2400 */
	popq     %rbp
	ret                          /* ret       */
