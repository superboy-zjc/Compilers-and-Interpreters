/* arr is stored in the 1, at the offset of 10 */ 
/* i is stored in the 1, at the offset of 11 */
/* a is stored in the 0, at the offset of 0 */
/* b is stored in the 0, at the offset of 2000000 */
/* c is stored in the 0, at the offset of 4000000 */
/* M is stored in the 1, at the offset of 10 */
/* i is stored in the 1, at the offset of 11 */
/* j is stored in the 1, at the offset of 12 */
/* k is stored in the 1, at the offset of 13 */
/* r is stored in the 1, at the offset of 14 */
/* val is stored in the 1, at the offset of 15 */
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
	subq     $6000832, %rsp
	movl     $500, -6000784(%rbp) /* mov_l    vr16, $500 */
	movl     -6000784(%rbp), %r10d /* mov_l    vr10, vr16 */
	movl     %r10d, -6000832(%rbp)
	leaq     -6000000(%rbp), %r10 /* localaddr vr17, $0 */
	movq     %r10, -6000776(%rbp)
	movl     $0, -6000768(%rbp)  /* mov_l    vr18, $0 */
	movl     -6000768(%rbp), %r11d /* sconv_lq vr19, vr18 */
	movslq   %r11d, %r11
	movq     %r11, -6000760(%rbp)
	movq     -6000760(%rbp), %r10 /* mul_q    vr20, vr19, $4000 */
	imulq    $4000, %r10
	movq     %r10, -6000752(%rbp)
	movq     -6000776(%rbp), %r11 /* add_q    vr21, vr17, vr20 */
	addq     -6000752(%rbp), %r11
	movq     %r11, -6000744(%rbp)
	movl     $0, -6000736(%rbp)  /* mov_l    vr22, $0 */
	movl     -6000736(%rbp), %r10d /* sconv_lq vr23, vr22 */
	movslq   %r10d, %r10
	movq     %r10, -6000728(%rbp)
	movq     -6000728(%rbp), %r11 /* mul_q    vr24, vr23, $8 */
	imulq    $8, %r11
	movq     %r11, -6000720(%rbp)
	movq     -6000744(%rbp), %r10 /* add_q    vr25, vr21, vr24 */
	addq     -6000720(%rbp), %r10
	movq     %r10, -6000712(%rbp)
	movq     -6000712(%rbp), %rdi /* mov_q    vr1, vr25 */
	call     read_m500x500       /* call     read_m500x500 */
	leaq     -4000000(%rbp), %r10 /* localaddr vr27, $2000000 */
	movq     %r10, -6000696(%rbp)
	movl     $0, -6000688(%rbp)  /* mov_l    vr28, $0 */
	movl     -6000688(%rbp), %r11d /* sconv_lq vr29, vr28 */
	movslq   %r11d, %r11
	movq     %r11, -6000680(%rbp)
	movq     -6000680(%rbp), %r10 /* mul_q    vr30, vr29, $4000 */
	imulq    $4000, %r10
	movq     %r10, -6000672(%rbp)
	movq     -6000696(%rbp), %r11 /* add_q    vr31, vr27, vr30 */
	addq     -6000672(%rbp), %r11
	movq     %r11, -6000664(%rbp)
	movl     $0, -6000656(%rbp)  /* mov_l    vr32, $0 */
	movl     -6000656(%rbp), %r10d /* sconv_lq vr33, vr32 */
	movslq   %r10d, %r10
	movq     %r10, -6000648(%rbp)
	movq     -6000648(%rbp), %r11 /* mul_q    vr34, vr33, $8 */
	imulq    $8, %r11
	movq     %r11, -6000640(%rbp)
	movq     -6000664(%rbp), %r10 /* add_q    vr35, vr31, vr34 */
	addq     -6000640(%rbp), %r10
	movq     %r10, -6000632(%rbp)
	movq     -6000632(%rbp), %rdi /* mov_q    vr1, vr35 */
	call     read_m500x500       /* call     read_m500x500 */
	movl     $0, -6000616(%rbp)  /* mov_l    vr37, $0 */
	movl     -6000616(%rbp), %r11d /* mov_l    vr11, vr37 */
	movl     %r11d, -6000824(%rbp)
	jmp      .L3                 /* jmp      .L3 */
.L2:
	movl     $0, -6000608(%rbp)  /* mov_l    vr38, $0 */
	movl     -6000608(%rbp), %r10d /* mov_l    vr12, vr38 */
	movl     %r10d, -6000816(%rbp)
	jmp      .L5                 /* jmp      .L5 */
.L4:
	leaq     -2000000(%rbp), %r10 /* localaddr vr39, $4000000 */
	movq     %r10, -6000600(%rbp)
	movl     -6000824(%rbp), %r11d /* sconv_lq vr40, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -6000592(%rbp)
	movq     -6000592(%rbp), %r10 /* mul_q    vr41, vr40, $4000 */
	imulq    $4000, %r10
	movq     %r10, -6000584(%rbp)
	movq     -6000600(%rbp), %r11 /* add_q    vr42, vr39, vr41 */
	addq     -6000584(%rbp), %r11
	movq     %r11, -6000576(%rbp)
	movl     -6000816(%rbp), %r10d /* sconv_lq vr43, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -6000568(%rbp)
	movq     -6000568(%rbp), %r11 /* mul_q    vr44, vr43, $8 */
	imulq    $8, %r11
	movq     %r11, -6000560(%rbp)
	movq     -6000576(%rbp), %r10 /* add_q    vr45, vr42, vr44 */
	addq     -6000560(%rbp), %r10
	movq     %r10, -6000552(%rbp)
	movq     $0, -6000544(%rbp)  /* mov_q    vr46, $0 */
	movq     -6000552(%rbp), %r11 /* mov_q    (vr45), vr46 */
	movq     -6000544(%rbp), %r10
	movq     %r10, (%r11)
	movl     $1, -6000536(%rbp)  /* mov_l    vr47, $1 */
	movl     -6000816(%rbp), %r11d /* add_l    vr48, vr12, vr47 */
	addl     -6000536(%rbp), %r11d
	movl     %r11d, -6000528(%rbp)
	movl     -6000528(%rbp), %r10d /* mov_l    vr12, vr48 */
	movl     %r10d, -6000816(%rbp)
.L5:
	movl     -6000816(%rbp), %r11d /* cmplt_l  vr49, vr12, vr10 */
	cmpl     -6000832(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -6000520(%rbp)
	cmpl     $0, -6000520(%rbp)  /* cjmp_t   vr49, .L4 */
	jne      .L4
	movl     $1, -6000512(%rbp)  /* mov_l    vr50, $1 */
	movl     -6000824(%rbp), %r10d /* add_l    vr51, vr11, vr50 */
	addl     -6000512(%rbp), %r10d
	movl     %r10d, -6000504(%rbp)
	movl     -6000504(%rbp), %r11d /* mov_l    vr11, vr51 */
	movl     %r11d, -6000824(%rbp)
.L3:
	movl     -6000824(%rbp), %r10d /* cmplt_l  vr52, vr11, vr10 */
	cmpl     -6000832(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000496(%rbp)
	cmpl     $0, -6000496(%rbp)  /* cjmp_t   vr52, .L2 */
	jne      .L2
	movl     $0, -6000488(%rbp)  /* mov_l    vr53, $0 */
	movl     -6000488(%rbp), %r11d /* mov_l    vr13, vr53 */
	movl     %r11d, -6000808(%rbp)
	jmp      .L7                 /* jmp      .L7 */
.L6:
	movl     $0, -6000480(%rbp)  /* mov_l    vr54, $0 */
	movl     -6000480(%rbp), %r10d /* mov_l    vr11, vr54 */
	movl     %r10d, -6000824(%rbp)
	jmp      .L9                 /* jmp      .L9 */
.L8:
	leaq     -6000000(%rbp), %r10 /* localaddr vr55, $0 */
	movq     %r10, -6000472(%rbp)
	movl     -6000824(%rbp), %r11d /* sconv_lq vr56, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -6000464(%rbp)
	movq     -6000464(%rbp), %r10 /* mul_q    vr57, vr56, $4000 */
	imulq    $4000, %r10
	movq     %r10, -6000456(%rbp)
	movq     -6000472(%rbp), %r11 /* add_q    vr58, vr55, vr57 */
	addq     -6000456(%rbp), %r11
	movq     %r11, -6000448(%rbp)
	movl     -6000808(%rbp), %r10d /* sconv_lq vr59, vr13 */
	movslq   %r10d, %r10
	movq     %r10, -6000440(%rbp)
	movq     -6000440(%rbp), %r11 /* mul_q    vr60, vr59, $8 */
	imulq    $8, %r11
	movq     %r11, -6000432(%rbp)
	movq     -6000448(%rbp), %r10 /* add_q    vr61, vr58, vr60 */
	addq     -6000432(%rbp), %r10
	movq     %r10, -6000424(%rbp)
	movq     -6000424(%rbp), %r11 /* mov_q    vr14, (vr61) */
	movq     (%r11), %r10
	movq     %r10, -6000800(%rbp)
	movl     $0, -6000416(%rbp)  /* mov_l    vr62, $0 */
	movl     -6000416(%rbp), %r11d /* mov_l    vr12, vr62 */
	movl     %r11d, -6000816(%rbp)
	jmp      .L11                /* jmp      .L11 */
.L10:
	leaq     -2000000(%rbp), %r10 /* localaddr vr63, $4000000 */
	movq     %r10, -6000408(%rbp)
	movl     -6000824(%rbp), %r10d /* sconv_lq vr64, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -6000400(%rbp)
	movq     -6000400(%rbp), %r11 /* mul_q    vr65, vr64, $4000 */
	imulq    $4000, %r11
	movq     %r11, -6000392(%rbp)
	movq     -6000408(%rbp), %r10 /* add_q    vr66, vr63, vr65 */
	addq     -6000392(%rbp), %r10
	movq     %r10, -6000384(%rbp)
	movl     -6000816(%rbp), %r11d /* sconv_lq vr67, vr12 */
	movslq   %r11d, %r11
	movq     %r11, -6000376(%rbp)
	movq     -6000376(%rbp), %r10 /* mul_q    vr68, vr67, $8 */
	imulq    $8, %r10
	movq     %r10, -6000368(%rbp)
	movq     -6000384(%rbp), %r11 /* add_q    vr69, vr66, vr68 */
	addq     -6000368(%rbp), %r11
	movq     %r11, -6000360(%rbp)
	movq     -6000360(%rbp), %r10 /* mov_q    vr15, (vr69) */
	movq     (%r10), %r11
	movq     %r11, -6000792(%rbp)
	leaq     -4000000(%rbp), %r10 /* localaddr vr70, $2000000 */
	movq     %r10, -6000352(%rbp)
	movl     -6000808(%rbp), %r10d /* sconv_lq vr71, vr13 */
	movslq   %r10d, %r10
	movq     %r10, -6000344(%rbp)
	movq     -6000344(%rbp), %r11 /* mul_q    vr72, vr71, $4000 */
	imulq    $4000, %r11
	movq     %r11, -6000336(%rbp)
	movq     -6000352(%rbp), %r10 /* add_q    vr73, vr70, vr72 */
	addq     -6000336(%rbp), %r10
	movq     %r10, -6000328(%rbp)
	movl     -6000816(%rbp), %r11d /* sconv_lq vr74, vr12 */
	movslq   %r11d, %r11
	movq     %r11, -6000320(%rbp)
	movq     -6000320(%rbp), %r10 /* mul_q    vr75, vr74, $8 */
	imulq    $8, %r10
	movq     %r10, -6000312(%rbp)
	movq     -6000328(%rbp), %r11 /* add_q    vr76, vr73, vr75 */
	addq     -6000312(%rbp), %r11
	movq     %r11, -6000304(%rbp)
	movq     -6000304(%rbp), %r10 /* mov_q    vr78, (vr76) */
	movq     (%r10), %r11
	movq     %r11, -6000288(%rbp)
	movq     -6000288(%rbp), %r10 /* mul_q    vr77, vr14, vr78 */
	movq     -6000800(%rbp), %r11
	imulq    %r10, %r11
	movq     %r11, -6000296(%rbp)
	movq     -6000792(%rbp), %r10 /* add_q    vr79, vr15, vr77 */
	addq     -6000296(%rbp), %r10
	movq     %r10, -6000280(%rbp)
	movq     -6000280(%rbp), %r11 /* mov_q    vr15, vr79 */
	movq     %r11, -6000792(%rbp)
	leaq     -2000000(%rbp), %r10 /* localaddr vr80, $4000000 */
	movq     %r10, -6000272(%rbp)
	movl     -6000824(%rbp), %r10d /* sconv_lq vr81, vr11 */
	movslq   %r10d, %r10
	movq     %r10, -6000264(%rbp)
	movq     -6000264(%rbp), %r11 /* mul_q    vr82, vr81, $4000 */
	imulq    $4000, %r11
	movq     %r11, -6000256(%rbp)
	movq     -6000272(%rbp), %r10 /* add_q    vr83, vr80, vr82 */
	addq     -6000256(%rbp), %r10
	movq     %r10, -6000248(%rbp)
	movl     -6000816(%rbp), %r11d /* sconv_lq vr84, vr12 */
	movslq   %r11d, %r11
	movq     %r11, -6000240(%rbp)
	movq     -6000240(%rbp), %r10 /* mul_q    vr85, vr84, $8 */
	imulq    $8, %r10
	movq     %r10, -6000232(%rbp)
	movq     -6000248(%rbp), %r11 /* add_q    vr86, vr83, vr85 */
	addq     -6000232(%rbp), %r11
	movq     %r11, -6000224(%rbp)
	movq     -6000224(%rbp), %r10 /* mov_q    (vr86), vr15 */
	movq     -6000792(%rbp), %r11
	movq     %r11, (%r10)
	movl     $1, -6000216(%rbp)  /* mov_l    vr87, $1 */
	movl     -6000816(%rbp), %r10d /* add_l    vr88, vr12, vr87 */
	addl     -6000216(%rbp), %r10d
	movl     %r10d, -6000208(%rbp)
	movl     -6000208(%rbp), %r11d /* mov_l    vr12, vr88 */
	movl     %r11d, -6000816(%rbp)
.L11:
	movl     -6000816(%rbp), %r10d /* cmplt_l  vr89, vr12, vr10 */
	cmpl     -6000832(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000200(%rbp)
	cmpl     $0, -6000200(%rbp)  /* cjmp_t   vr89, .L10 */
	jne      .L10
	movl     $1, -6000192(%rbp)  /* mov_l    vr90, $1 */
	movl     -6000824(%rbp), %r11d /* add_l    vr91, vr11, vr90 */
	addl     -6000192(%rbp), %r11d
	movl     %r11d, -6000184(%rbp)
	movl     -6000184(%rbp), %r10d /* mov_l    vr11, vr91 */
	movl     %r10d, -6000824(%rbp)
.L9:
	movl     -6000824(%rbp), %r11d /* cmplt_l  vr92, vr11, vr10 */
	cmpl     -6000832(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -6000176(%rbp)
	cmpl     $0, -6000176(%rbp)  /* cjmp_t   vr92, .L8 */
	jne      .L8
	movl     $1, -6000168(%rbp)  /* mov_l    vr93, $1 */
	movl     -6000808(%rbp), %r10d /* add_l    vr94, vr13, vr93 */
	addl     -6000168(%rbp), %r10d
	movl     %r10d, -6000160(%rbp)
	movl     -6000160(%rbp), %r11d /* mov_l    vr13, vr94 */
	movl     %r11d, -6000808(%rbp)
.L7:
	movl     -6000808(%rbp), %r10d /* cmplt_l  vr95, vr13, vr10 */
	cmpl     -6000832(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000152(%rbp)
	cmpl     $0, -6000152(%rbp)  /* cjmp_t   vr95, .L6 */
	jne      .L6
	movl     $0, -6000144(%rbp)  /* mov_l    vr96, $0 */
	movl     -6000144(%rbp), %r11d /* mov_l    vr11, vr96 */
	movl     %r11d, -6000824(%rbp)
	jmp      .L13                /* jmp      .L13 */
.L12:
	movl     $0, -6000136(%rbp)  /* mov_l    vr97, $0 */
	movl     -6000136(%rbp), %r10d /* mov_l    vr12, vr97 */
	movl     %r10d, -6000816(%rbp)
	jmp      .L15                /* jmp      .L15 */
.L14:
	leaq     -2000000(%rbp), %r10 /* localaddr vr98, $4000000 */
	movq     %r10, -6000128(%rbp)
	movl     -6000824(%rbp), %r11d /* sconv_lq vr99, vr11 */
	movslq   %r11d, %r11
	movq     %r11, -6000120(%rbp)
	movq     -6000120(%rbp), %r10 /* mul_q    vr100, vr99, $4000 */
	imulq    $4000, %r10
	movq     %r10, -6000112(%rbp)
	movq     -6000128(%rbp), %r11 /* add_q    vr101, vr98, vr100 */
	addq     -6000112(%rbp), %r11
	movq     %r11, -6000104(%rbp)
	movl     -6000816(%rbp), %r10d /* sconv_lq vr102, vr12 */
	movslq   %r10d, %r10
	movq     %r10, -6000096(%rbp)
	movq     -6000096(%rbp), %r11 /* mul_q    vr103, vr102, $8 */
	imulq    $8, %r11
	movq     %r11, -6000088(%rbp)
	movq     -6000104(%rbp), %r10 /* add_q    vr104, vr101, vr103 */
	addq     -6000088(%rbp), %r10
	movq     %r10, -6000080(%rbp)
	movq     -6000080(%rbp), %r11 /* mov_q    vr1, (vr104) */
	movq     (%r11), %rdi
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     $1, -6000056(%rbp)  /* mov_l    vr107, $1 */
	movl     -6000816(%rbp), %r10d /* add_l    vr108, vr12, vr107 */
	addl     -6000056(%rbp), %r10d
	movl     %r10d, -6000048(%rbp)
	movl     -6000048(%rbp), %r11d /* mov_l    vr12, vr108 */
	movl     %r11d, -6000816(%rbp)
.L15:
	movl     -6000816(%rbp), %r10d /* cmplt_l  vr109, vr12, vr10 */
	cmpl     -6000832(%rbp), %r10d
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -6000040(%rbp)
	cmpl     $0, -6000040(%rbp)  /* cjmp_t   vr109, .L14 */
	jne      .L14
	movl     $1, -6000032(%rbp)  /* mov_l    vr110, $1 */
	movl     -6000824(%rbp), %r11d /* add_l    vr111, vr11, vr110 */
	addl     -6000032(%rbp), %r11d
	movl     %r11d, -6000024(%rbp)
	movl     -6000024(%rbp), %r10d /* mov_l    vr11, vr111 */
	movl     %r10d, -6000824(%rbp)
.L13:
	movl     -6000824(%rbp), %r11d /* cmplt_l  vr112, vr11, vr10 */
	cmpl     -6000832(%rbp), %r11d
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, -6000016(%rbp)
	cmpl     $0, -6000016(%rbp)  /* cjmp_t   vr112, .L12 */
	jne      .L12
	movl     $0, -6000008(%rbp)  /* mov_l    vr113, $0 */
	movl     -6000008(%rbp), %eax /* mov_l    vr0, vr113 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $6000832, %rsp      /* leave    $6000000 */
	popq     %rbp
	ret                          /* ret       */
