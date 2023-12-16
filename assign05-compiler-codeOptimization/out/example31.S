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
	subq     $16, %rsp
	pushq    %rbx
	pushq    %r12
	movq     %rdi, %r12          /* mov_q    vr10<%r12>, vr1 */
	movl     $0, %ebx            /* mov_l    vr11<%rbx>, $0 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	call     read_i64            /* call     read_i64 */
	movl     %ebx, %r10d         /* sconv_lq vr14<%r9>, vr11<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r9
	imulq    $8, %r9             /* mul_q    vr15<%r8>, vr14<%r9>, $8 */
	movq     %r9, %r8
	movq     %r12, %r11          /* add_q    vr16<%r9>, vr10<%r12>, vr15<%r8> */
	addq     %r8, %r11
	movq     %r11, %r9
	movq     %r9, %r10           /* mov_q    (vr16<%r9>), vr0 */
	movq     %rax, (%r10)
	movl     %ebx, %r11d         /* add_l    vr18<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr18<%r9> */
.L1:
	cmpl     $250000, %ebx       /* cmplt_l  vr20<%r9>, vr11<%rbx>, $250000 */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr20<%r9>, .L0 */
	jne      .L0
	jmp      .Lread_m500x500_return /* jmp      .Lread_m500x500_return */
.Lread_m500x500_return:
	popq     %r12                /* leave    $0 */
	popq     %rbx
	addq     $16, %rsp
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $6000000 */
	movq     %rsp, %rbp
	subq     $6000048, %rsp
	pushq    %rbx
	pushq    %r12
	pushq    %r13
	pushq    %r14
	movl     $500, %r13d         /* mov_l    vr10<%r13>, $500 */
	leaq     -6000000(%rbp), %r10 /* localaddr vr17<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %r10           /* add_q    vr21<%r8>, vr17<%r9>, $0 */
	addq     $0, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* add_q    vr25<%r9>, vr21<%r8>, $0 */
	addq     $0, %r11
	movq     %r11, %r9
	movq     %r9, %rdi           /* mov_q    vr1, vr25<%r9> */
	call     read_m500x500       /* call     read_m500x500 */
	leaq     -4000000(%rbp), %r10 /* localaddr vr27<%r9>, $2000000 */
	movq     %r10, %r9
	movq     %r9, %r10           /* add_q    vr31<%r8>, vr27<%r9>, $0 */
	addq     $0, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* add_q    vr35<%r9>, vr31<%r8>, $0 */
	addq     $0, %r11
	movq     %r11, %r9
	movq     %r9, %rdi           /* mov_q    vr1, vr35<%r9> */
	call     read_m500x500       /* call     read_m500x500 */
	movl     $0, %ebx            /* mov_l    vr11<%rbx>, $0 */
	jmp      .L3                 /* jmp      .L3 */
.L2:
	movl     $0, %r12d           /* mov_l    vr12<%r12>, $0 */
	jmp      .L5                 /* jmp      .L5 */
.L4:
	leaq     -2000000(%rbp), %r10 /* localaddr vr39<%r9>, $4000000 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr40<%r8>, vr11<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $4000, %r8          /* mul_q    vr41<%rcx>, vr40<%r8>, $4000 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr42<%r8>, vr39<%r9>, vr41<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movl     %r12d, %r10d        /* sconv_lq vr43<%rcx>, vr12<%r12> */
	movslq   %r10d, %r10
	movq     %r10, %rcx
	imulq    $8, %rcx            /* mul_q    vr44<%r9>, vr43<%rcx>, $8 */
	movq     %rcx, %r9
	movq     %r8, %r11           /* add_q    vr45<%rcx>, vr42<%r8>, vr44<%r9> */
	addq     %r9, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_q    (vr45<%rcx>), $0 */
	movq     $0, (%r10)
	movl     %r12d, %r11d        /* add_l    vr48<%rcx>, vr12<%r12>, $1 */
	addl     $1, %r11d
	movl     %r11d, %ecx
	movl     %ecx, %r12d         /* mov_l    vr12<%r12>, vr48<%rcx> */
.L5:
	cmpl     %r13d, %r12d        /* cmplt_l  vr49<%r9>, vr12<%r12>, vr10<%r13> */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr49<%r9>, .L4 */
	jne      .L4
	movl     %ebx, %r11d         /* add_l    vr51<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr51<%r9> */
.L3:
	cmpl     %r13d, %ebx         /* cmplt_l  vr52<%r9>, vr11<%rbx>, vr10<%r13> */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr52<%r9>, .L2 */
	jne      .L2
	movl     $0, %r14d           /* mov_l    vr13<%r14>, $0 */
	jmp      .L7                 /* jmp      .L7 */
.L6:
	movl     $0, %ebx            /* mov_l    vr11<%rbx>, $0 */
	jmp      .L9                 /* jmp      .L9 */
.L8:
	leaq     -6000000(%rbp), %r10 /* localaddr vr55<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r11d         /* sconv_lq vr56<%r8>, vr11<%rbx> */
	movslq   %r11d, %r11
	movq     %r11, %r8
	imulq    $4000, %r8          /* mul_q    vr57<%rcx>, vr56<%r8>, $4000 */
	movq     %r8, %rcx
	movq     %r9, %r10           /* add_q    vr58<%r8>, vr55<%r9>, vr57<%rcx> */
	addq     %rcx, %r10
	movq     %r10, %r8
	movl     %r14d, %r11d        /* sconv_lq vr59<%rcx>, vr13<%r14> */
	movslq   %r11d, %r11
	movq     %r11, %rcx
	imulq    $8, %rcx            /* mul_q    vr60<%r9>, vr59<%rcx>, $8 */
	movq     %rcx, %r9
	movq     %r8, %r10           /* add_q    vr61<%rcx>, vr58<%r8>, vr60<%r9> */
	addq     %r9, %r10
	movq     %r10, %rcx
	movq     %rcx, %r11          /* mov_q    vr14, (vr61<%rcx>) */
	movq     (%r11), %r10
	movq     %r10, -6000016(%rbp)
	movl     $0, %r12d           /* mov_l    vr12<%r12>, $0 */
	jmp      .L11                /* jmp      .L11 */
.L10:
	leaq     -2000000(%rbp), %r10 /* localaddr vr63<%r9>, $4000000 */
	movq     %r10, %r9
	movl     %ebx, %r11d         /* sconv_lq vr64<%r8>, vr11<%rbx> */
	movslq   %r11d, %r11
	movq     %r11, %r8
	imulq    $4000, %r8          /* mul_q    vr65<%rcx>, vr64<%r8>, $4000 */
	movq     %r8, %rcx
	movq     %r9, %r10           /* add_q    vr66<%r8>, vr63<%r9>, vr65<%rcx> */
	addq     %rcx, %r10
	movq     %r10, %r8
	movl     %r12d, %r11d        /* sconv_lq vr67<%rcx>, vr12<%r12> */
	movslq   %r11d, %r11
	movq     %r11, %rcx
	imulq    $8, %rcx            /* mul_q    vr68<%r9>, vr67<%rcx>, $8 */
	movq     %rcx, %r9
	movq     %r8, %r10           /* add_q    vr69<%rcx>, vr66<%r8>, vr68<%r9> */
	addq     %r9, %r10
	movq     %r10, %rcx
	movq     %rcx, %r11          /* mov_q    vr15, (vr69<%rcx>) */
	movq     (%r11), %r10
	movq     %r10, -6000008(%rbp)
	leaq     -4000000(%rbp), %r10 /* localaddr vr70<%r8>, $2000000 */
	movq     %r10, %r8
	movl     %r14d, %r11d        /* sconv_lq vr71<%rdx>, vr13<%r14> */
	movslq   %r11d, %r11
	movq     %r11, %rdx
	imulq    $4000, %rdx         /* mul_q    vr72<%rsi>, vr71<%rdx>, $4000 */
	movq     %rdx, %rsi
	movq     %r8, %r10           /* add_q    vr73<%rdx>, vr70<%r8>, vr72<%rsi> */
	addq     %rsi, %r10
	movq     %r10, %rdx
	movq     %rdx, %r11          /* add_q    vr76<%rsi>, vr73<%rdx>, vr68<%r9> */
	addq     %r9, %r11
	movq     %r11, %rsi
	movq     %rsi, %r10          /* mov_q    vr78<%r9>, (vr76<%rsi>) */
	movq     (%r10), %r9
	movq     -6000016(%rbp), %r11 /* mul_q    vr77<%rsi>, vr14, vr78<%r9> */
	imulq    %r9, %r11
	movq     %r11, %rsi
	movq     -6000008(%rbp), %r10 /* add_q    vr79<%r9>, vr15, vr77<%rsi> */
	addq     %rsi, %r10
	movq     %r10, %r9
	movq     %rcx, %rsi          /* mov_q    vr86<%rsi>, vr69<%rcx> */
	movq     %rsi, %r11          /* mov_q    (vr86<%rsi>), vr79<%r9> */
	movq     %r9, (%r11)
	movl     %r12d, %r10d        /* add_l    vr88<%r9>, vr12<%r12>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %r12d         /* mov_l    vr12<%r12>, vr88<%r9> */
.L11:
	cmpl     %r13d, %r12d        /* cmplt_l  vr89<%r9>, vr12<%r12>, vr10<%r13> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr89<%r9>, .L10 */
	jne      .L10
	movl     %ebx, %r10d         /* add_l    vr91<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr91<%r9> */
.L9:
	cmpl     %r13d, %ebx         /* cmplt_l  vr92<%r9>, vr11<%rbx>, vr10<%r13> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr92<%r9>, .L8 */
	jne      .L8
	movl     %r14d, %r10d        /* add_l    vr94<%r9>, vr13<%r14>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %r14d         /* mov_l    vr13<%r14>, vr94<%r9> */
.L7:
	cmpl     %r13d, %r14d        /* cmplt_l  vr95<%r9>, vr13<%r14>, vr10<%r13> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr95<%r9>, .L6 */
	jne      .L6
	movl     $0, %ebx            /* mov_l    vr11<%rbx>, $0 */
	jmp      .L13                /* jmp      .L13 */
.L12:
	movl     $0, %r12d           /* mov_l    vr12<%r12>, $0 */
	jmp      .L15                /* jmp      .L15 */
.L14:
	leaq     -2000000(%rbp), %r10 /* localaddr vr98<%r9>, $4000000 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr99<%r8>, vr11<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $4000, %r8          /* mul_q    vr100<%rcx>, vr99<%r8>, $4000 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr101<%r8>, vr98<%r9>, vr100<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movl     %r12d, %r10d        /* sconv_lq vr102<%rcx>, vr12<%r12> */
	movslq   %r10d, %r10
	movq     %r10, %rcx
	imulq    $8, %rcx            /* mul_q    vr103<%r9>, vr102<%rcx>, $8 */
	movq     %rcx, %r9
	movq     %r8, %r11           /* add_q    vr104<%rcx>, vr101<%r8>, vr103<%r9> */
	addq     %r9, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_q    vr1, (vr104<%rcx>) */
	movq     (%r10), %rdi
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     %r12d, %r11d        /* add_l    vr108<%r9>, vr12<%r12>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %r12d         /* mov_l    vr12<%r12>, vr108<%r9> */
.L15:
	cmpl     %r13d, %r12d        /* cmplt_l  vr109<%r9>, vr12<%r12>, vr10<%r13> */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr109<%r9>, .L14 */
	jne      .L14
	movl     %ebx, %r11d         /* add_l    vr111<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr111<%r9> */
.L13:
	cmpl     %r13d, %ebx         /* cmplt_l  vr112<%r9>, vr11<%rbx>, vr10<%r13> */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr112<%r9>, .L12 */
	jne      .L12
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	popq     %r14                /* leave    $6000000 */
	popq     %r13
	popq     %r12
	popq     %rbx
	addq     $6000048, %rsp
	popq     %rbp
	ret                          /* ret       */
