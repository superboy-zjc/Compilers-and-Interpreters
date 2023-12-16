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
	cmpl     $100, %ebx          /* cmplt_l  vr20<%r9>, vr11<%rbx>, $100 */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr20<%r9>, .L0 */
	jne      .L0
	jmp      .Lread_m10x10_return /* jmp      .Lread_m10x10_return */
.Lread_m10x10_return:
	popq     %r12                /* leave    $0 */
	popq     %rbx
	addq     $16, %rsp
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $2400 */
	movq     %rsp, %rbp
	subq     $2448, %rsp
	pushq    %rbx
	pushq    %r12
	pushq    %r13
	pushq    %r14
	movl     $10, %r12d          /* mov_l    vr10<%r12>, $10 */
	leaq     -2400(%rbp), %r10   /* localaddr vr17<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %rdi           /* mov_q    vr1, vr17<%r9> */
	call     read_m10x10         /* call     read_m10x10 */
	leaq     -1600(%rbp), %r10   /* localaddr vr19<%r9>, $800 */
	movq     %r10, %r9
	movq     %r9, %rdi           /* mov_q    vr1, vr19<%r9> */
	call     read_m10x10         /* call     read_m10x10 */
	movl     $0, %ebx            /* mov_l    vr11<%rbx>, $0 */
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -800(%rbp), %r10    /* localaddr vr22<%r9>, $1600 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr23<%r8>, vr11<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr24<%rcx>, vr23<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr25<%r8>, vr22<%r9>, vr24<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_q    (vr25<%r8>), $0 */
	movq     $0, (%r10)
	movl     %ebx, %r11d         /* add_l    vr28<%r8>, vr11<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r8d
	movl     %r8d, %ebx          /* mov_l    vr11<%rbx>, vr28<%r8> */
.L3:
	cmpl     $100, %ebx          /* cmplt_l  vr30<%r9>, vr11<%rbx>, $100 */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr30<%r9>, .L2 */
	jne      .L2
	movl     $0, %r14d           /* mov_l    vr13<%r14>, $0 */
	jmp      .L5                 /* jmp      .L5 */
.L4:
	movl     $0, %ebx            /* mov_l    vr11<%rbx>, $0 */
	jmp      .L7                 /* jmp      .L7 */
.L6:
	leaq     -2400(%rbp), %r10   /* localaddr vr33<%r9>, $0 */
	movq     %r10, %r9
	imull    %r12d, %ebx         /* mul_l    vr34<%r8>, vr11<%rbx>, vr10<%r12> */
	movl     %ebx, %r8d
	movl     %r8d, %r11d         /* add_l    vr35<%rcx>, vr34<%r8>, vr13<%r14> */
	addl     %r14d, %r11d
	movl     %r11d, %ecx
	movl     %ecx, %r10d         /* sconv_lq vr36<%r8>, vr35<%rcx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr37<%rcx>, vr36<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr38<%r8>, vr33<%r9>, vr37<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_q    vr14, (vr38<%r8>) */
	movq     (%r10), %r11
	movq     %r11, -2416(%rbp)
	movl     $0, %r13d           /* mov_l    vr12<%r13>, $0 */
	jmp      .L9                 /* jmp      .L9 */
.L8:
	leaq     -800(%rbp), %r10    /* localaddr vr40<%r9>, $1600 */
	movq     %r10, %r9
	imull    %r12d, %ebx         /* mul_l    vr41<%r8>, vr11<%rbx>, vr10<%r12> */
	movl     %ebx, %r8d
	movl     %r8d, %r10d         /* add_l    vr42<%rcx>, vr41<%r8>, vr12<%r13> */
	addl     %r13d, %r10d
	movl     %r10d, %ecx
	movl     %ecx, %r11d         /* sconv_lq vr43<%r8>, vr42<%rcx> */
	movslq   %r11d, %r11
	movq     %r11, %r8
	imulq    $8, %r8             /* mul_q    vr44<%rcx>, vr43<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r10           /* add_q    vr45<%r8>, vr40<%r9>, vr44<%rcx> */
	addq     %rcx, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_q    vr15, (vr45<%r8>) */
	movq     (%r11), %r10
	movq     %r10, -2408(%rbp)
	leaq     -1600(%rbp), %r10   /* localaddr vr46<%rcx>, $800 */
	movq     %r10, %rcx
	imull    %r12d, %r14d        /* mul_l    vr47<%r9>, vr13<%r14>, vr10<%r12> */
	movl     %r14d, %r9d
	movl     %r9d, %r11d         /* add_l    vr48<%rdx>, vr47<%r9>, vr12<%r13> */
	addl     %r13d, %r11d
	movl     %r11d, %edx
	movl     %edx, %r10d         /* sconv_lq vr49<%r9>, vr48<%rdx> */
	movslq   %r10d, %r10
	movq     %r10, %r9
	imulq    $8, %r9             /* mul_q    vr50<%rdx>, vr49<%r9>, $8 */
	movq     %r9, %rdx
	movq     %rcx, %r11          /* add_q    vr51<%r9>, vr46<%rcx>, vr50<%rdx> */
	addq     %rdx, %r11
	movq     %r11, %r9
	movq     %r9, %r10           /* mov_q    vr53<%rdx>, (vr51<%r9>) */
	movq     (%r10), %rdx
	movq     -2416(%rbp), %r11   /* mul_q    vr52<%r9>, vr14, vr53<%rdx> */
	imulq    %rdx, %r11
	movq     %r11, %r9
	movq     -2408(%rbp), %r10   /* add_q    vr54<%rdx>, vr15, vr52<%r9> */
	addq     %r9, %r10
	movq     %r10, %rdx
	movq     %r8, %r9            /* mov_q    vr60<%r9>, vr45<%r8> */
	movq     %r9, %r11           /* mov_q    (vr60<%r9>), vr54<%rdx> */
	movq     %rdx, (%r11)
	movl     %r13d, %r10d        /* add_l    vr62<%rdx>, vr12<%r13>, $1 */
	addl     $1, %r10d
	movl     %r10d, %edx
	movl     %edx, %r13d         /* mov_l    vr12<%r13>, vr62<%rdx> */
.L9:
	cmpl     %r12d, %r13d        /* cmplt_l  vr63<%r9>, vr12<%r13>, vr10<%r12> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr63<%r9>, .L8 */
	jne      .L8
	movl     %ebx, %r10d         /* add_l    vr65<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr65<%r9> */
.L7:
	cmpl     %r12d, %ebx         /* cmplt_l  vr66<%r9>, vr11<%rbx>, vr10<%r12> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr66<%r9>, .L6 */
	jne      .L6
	movl     %r14d, %r10d        /* add_l    vr68<%r9>, vr13<%r14>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %r14d         /* mov_l    vr13<%r14>, vr68<%r9> */
.L5:
	cmpl     %r12d, %r14d        /* cmplt_l  vr69<%r9>, vr13<%r14>, vr10<%r12> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr69<%r9>, .L4 */
	jne      .L4
	movl     $0, %ebx            /* mov_l    vr11<%rbx>, $0 */
	jmp      .L11                /* jmp      .L11 */
.L10:
	leaq     -800(%rbp), %r10    /* localaddr vr71<%r9>, $1600 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr72<%r8>, vr11<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr73<%rcx>, vr72<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr74<%r8>, vr71<%r9>, vr73<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_q    vr1, (vr74<%r8>) */
	movq     (%r10), %rdi
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     %ebx, %r11d         /* add_l    vr78<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr78<%r9> */
.L11:
	cmpl     $100, %ebx          /* cmplt_l  vr80<%r9>, vr11<%rbx>, $100 */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr80<%r9>, .L10 */
	jne      .L10
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	popq     %r14                /* leave    $2400 */
	popq     %r13
	popq     %r12
	popq     %rbx
	addq     $2448, %rsp
	popq     %rbp
	ret                          /* ret       */
