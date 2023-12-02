/* i is stored in the 1, at the offset of 10 */
/* j is stored in the 1, at the offset of 11 */
/* n is stored in the 1, at the offset of 12 */
/* m is stored in the 0, at the offset of 0 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $400 */
	movq     %rsp, %rbp
	subq     $752, %rsp
	movl     $0, -720(%rbp)      /* mov_l    vr13, $0 */
	movl     -720(%rbp), %r10d   /* mov_l    vr10, vr13 */
	movl     %r10d, -744(%rbp)
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     $0, -712(%rbp)      /* mov_l    vr14, $0 */
	movl     -712(%rbp), %r11d   /* mov_l    vr12, vr14 */
	movl     %r11d, -728(%rbp)
	movl     $0, -704(%rbp)      /* mov_l    vr15, $0 */
	movl     -704(%rbp), %r10d   /* mov_l    vr11, vr15 */
	movl     %r10d, -736(%rbp)
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -400(%rbp), %r10    /* localaddr vr16, $0 */
	movq     %r10, -696(%rbp)
	movl     -744(%rbp), %r11d   /* sconv_lq vr17, vr10 */
	movslq   %r11d, %r11
	movq     %r11, -688(%rbp)
	movq     -688(%rbp), %r10    /* mul_q    vr18, vr17, $40 */
	imulq    $40, %r10
	movq     %r10, -680(%rbp)
	movq     -696(%rbp), %r11    /* add_q    vr19, vr16, vr18 */
	addq     -680(%rbp), %r11
	movq     %r11, -672(%rbp)
	movl     -736(%rbp), %r10d   /* sconv_lq vr20, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -664(%rbp)
	movq     -664(%rbp), %r11    /* mul_q    vr21, vr20, $4 */
	imulq    $4, %r11
	movq     %r11, -656(%rbp)
	movq     -672(%rbp), %r10    /* add_q    vr22, vr19, vr21 */
	addq     -656(%rbp), %r10
	movq     %r10, -648(%rbp)
	movq     -648(%rbp), %r11    /* mov_l    (vr22), vr12 */
	movl     -728(%rbp), %r10d
	movl     %r10d, (%r11)
	movl     -728(%rbp), %r11d   /* add_l    vr23, vr12, vr10 */
	addl     -744(%rbp), %r11d
	movl     %r11d, -640(%rbp)
	movl     -640(%rbp), %r10d   /* mov_l    vr12, vr23 */
	movl     %r10d, -728(%rbp)
	movl     $1, -632(%rbp)      /* mov_l    vr24, $1 */
	movl     -736(%rbp), %r11d   /* add_l    vr25, vr11, vr24 */
	addl     -632(%rbp), %r11d
	movl     %r11d, -624(%rbp)
	movl     -624(%rbp), %r10d   /* mov_l    vr11, vr25 */
	movl     %r10d, -736(%rbp)
.L3:
	movl     $9, -616(%rbp)      /* mov_l    vr26, $9 */
	movl     -736(%rbp), %r11d   /* cmplte_l vr27, vr11, vr26 */
	cmpl     -616(%rbp), %r11d
	setle    %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -608(%rbp)
	cmpl     $0, -608(%rbp)      /* cjmp_t   vr27, .L2 */
	jne      .L2
	movl     $1, -600(%rbp)      /* mov_l    vr28, $1 */
	movl     -744(%rbp), %r10d   /* add_l    vr29, vr10, vr28 */
	addl     -600(%rbp), %r10d
	movl     %r10d, -592(%rbp)
	movl     -592(%rbp), %r11d   /* mov_l    vr10, vr29 */
	movl     %r11d, -744(%rbp)
.L1:
	movl     $9, -584(%rbp)      /* mov_l    vr30, $9 */
	movl     -744(%rbp), %r10d   /* cmplte_l vr31, vr10, vr30 */
	cmpl     -584(%rbp), %r10d
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -576(%rbp)
	cmpl     $0, -576(%rbp)      /* cjmp_t   vr31, .L0 */
	jne      .L0
	movl     $0, -568(%rbp)      /* mov_l    vr32, $0 */
	movl     -568(%rbp), %r11d   /* mov_l    vr10, vr32 */
	movl     %r11d, -744(%rbp)
	jmp      .L5                 /* jmp      .L5 */
.L4:
	movl     $0, -560(%rbp)      /* mov_l    vr33, $0 */
	movl     -560(%rbp), %r10d   /* mov_l    vr11, vr33 */
	movl     %r10d, -736(%rbp)
	jmp      .L7                 /* jmp      .L7 */
.L6:
	leaq     -400(%rbp), %r10    /* localaddr vr34, $0 */
	movq     %r10, -552(%rbp)
	movl     -744(%rbp), %r11d   /* sconv_lq vr35, vr10 */
	movslq   %r11d, %r11
	movq     %r11, -544(%rbp)
	movq     -544(%rbp), %r10    /* mul_q    vr36, vr35, $40 */
	imulq    $40, %r10
	movq     %r10, -536(%rbp)
	movq     -552(%rbp), %r11    /* add_q    vr37, vr34, vr36 */
	addq     -536(%rbp), %r11
	movq     %r11, -528(%rbp)
	movl     -736(%rbp), %r10d   /* sconv_lq vr38, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -520(%rbp)
	movq     -520(%rbp), %r11    /* mul_q    vr39, vr38, $4 */
	imulq    $4, %r11
	movq     %r11, -512(%rbp)
	movq     -528(%rbp), %r10    /* add_q    vr40, vr37, vr39 */
	addq     -512(%rbp), %r10
	movq     %r10, -504(%rbp)
	movq     -504(%rbp), %r11    /* mov_l    vr1, (vr40) */
	movl     (%r11), %edi
	call     print_i32           /* call     print_i32 */
	call     print_space         /* call     print_space */
	movl     $1, -480(%rbp)      /* mov_l    vr43, $1 */
	movl     -736(%rbp), %r10d   /* add_l    vr44, vr11, vr43 */
	addl     -480(%rbp), %r10d
	movl     %r10d, -472(%rbp)
	movl     -472(%rbp), %r11d   /* mov_l    vr11, vr44 */
	movl     %r11d, -736(%rbp)
.L7:
	movl     $9, -464(%rbp)      /* mov_l    vr45, $9 */
	movl     -736(%rbp), %r10d   /* cmplte_l vr46, vr11, vr45 */
	cmpl     -464(%rbp), %r10d
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -456(%rbp)
	cmpl     $0, -456(%rbp)      /* cjmp_t   vr46, .L6 */
	jne      .L6
	call     print_nl            /* call     print_nl */
	movl     $1, -440(%rbp)      /* mov_l    vr48, $1 */
	movl     -744(%rbp), %r11d   /* add_l    vr49, vr10, vr48 */
	addl     -440(%rbp), %r11d
	movl     %r11d, -432(%rbp)
	movl     -432(%rbp), %r10d   /* mov_l    vr10, vr49 */
	movl     %r10d, -744(%rbp)
.L5:
	movl     $9, -424(%rbp)      /* mov_l    vr50, $9 */
	movl     -744(%rbp), %r11d   /* cmplte_l vr51, vr10, vr50 */
	cmpl     -424(%rbp), %r11d
	setle    %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -416(%rbp)
	cmpl     $0, -416(%rbp)      /* cjmp_t   vr51, .L4 */
	jne      .L4
	movl     $0, -408(%rbp)      /* mov_l    vr52, $0 */
	movl     -408(%rbp), %eax    /* mov_l    vr0, vr52 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $752, %rsp          /* leave    $400 */
	popq     %rbp
	ret                          /* ret       */
