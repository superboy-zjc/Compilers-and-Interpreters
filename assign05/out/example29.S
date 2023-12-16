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
	subq     $6000064, %rsp
	pushq    %rbx
	pushq    %r12
	pushq    %r13
	pushq    %r14
	movl     $500, %r12d         /* mov_l    vr10<%r12>, $500 */
	movl     $250000, -6000056(%rbp) /* mov_l    vr11, $250000 */
	leaq     -6000000(%rbp), %r10 /* localaddr vr20<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %rdi           /* mov_q    vr1, vr20<%r9> */
	call     read_m500x500       /* call     read_m500x500 */
	leaq     -4000000(%rbp), %r10 /* localaddr vr22<%r9>, $2000000 */
	movq     %r10, %r9
	movq     %r9, %rdi           /* mov_q    vr1, vr22<%r9> */
	call     read_m500x500       /* call     read_m500x500 */
	movl     $0, %ebx            /* mov_l    vr13<%rbx>, $0 */
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -2000000(%rbp), %r10 /* localaddr vr25<%r9>, $4000000 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr26<%r8>, vr13<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr27<%rcx>, vr26<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr28<%r8>, vr25<%r9>, vr27<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_q    (vr28<%r8>), $0 */
	movq     $0, (%r10)
	movl     %ebx, %r11d         /* add_l    vr31<%r8>, vr13<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r8d
	movl     %r8d, %ebx          /* mov_l    vr13<%rbx>, vr31<%r8> */
.L3:
	cmpl     -6000056(%rbp), %ebx /* cmplt_l  vr32<%r9>, vr13<%rbx>, vr11 */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr32<%r9>, .L2 */
	jne      .L2
	movl     $0, %r14d           /* mov_l    vr15<%r14>, $0 */
	jmp      .L5                 /* jmp      .L5 */
.L4:
	movl     $0, %ebx            /* mov_l    vr13<%rbx>, $0 */
	jmp      .L7                 /* jmp      .L7 */
.L6:
	leaq     -6000000(%rbp), %r10 /* localaddr vr35<%r9>, $0 */
	movq     %r10, %r9
	imull    %r12d, %ebx         /* mul_l    vr36<%r8>, vr13<%rbx>, vr10<%r12> */
	movl     %ebx, %r8d
	movl     %r8d, %r11d         /* add_l    vr37<%rcx>, vr36<%r8>, vr15<%r14> */
	addl     %r14d, %r11d
	movl     %r11d, %ecx
	movl     %ecx, %r10d         /* sconv_lq vr38<%r8>, vr37<%rcx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr39<%rcx>, vr38<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr40<%r8>, vr35<%r9>, vr39<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_q    vr16, (vr40<%r8>) */
	movq     (%r10), %r11
	movq     %r11, -6000016(%rbp)
	movl     $0, %r13d           /* mov_l    vr14<%r13>, $0 */
	jmp      .L9                 /* jmp      .L9 */
.L8:
	leaq     -2000000(%rbp), %r10 /* localaddr vr42<%r9>, $4000000 */
	movq     %r10, %r9
	imull    %r12d, %ebx         /* mul_l    vr43<%r8>, vr13<%rbx>, vr10<%r12> */
	movl     %ebx, %r8d
	movl     %r8d, %r10d         /* add_l    vr44<%rcx>, vr43<%r8>, vr14<%r13> */
	addl     %r13d, %r10d
	movl     %r10d, %ecx
	movl     %ecx, %r11d         /* sconv_lq vr45<%r8>, vr44<%rcx> */
	movslq   %r11d, %r11
	movq     %r11, %r8
	imulq    $8, %r8             /* mul_q    vr46<%rcx>, vr45<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r10           /* add_q    vr47<%r8>, vr42<%r9>, vr46<%rcx> */
	addq     %rcx, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_q    vr17, (vr47<%r8>) */
	movq     (%r11), %r10
	movq     %r10, -6000008(%rbp)
	leaq     -4000000(%rbp), %r10 /* localaddr vr48<%rcx>, $2000000 */
	movq     %r10, %rcx
	imull    %r12d, %r14d        /* mul_l    vr49<%r9>, vr15<%r14>, vr10<%r12> */
	movl     %r14d, %r9d
	movl     %r9d, %r11d         /* add_l    vr50<%rdx>, vr49<%r9>, vr14<%r13> */
	addl     %r13d, %r11d
	movl     %r11d, %edx
	movl     %edx, %r10d         /* sconv_lq vr51<%r9>, vr50<%rdx> */
	movslq   %r10d, %r10
	movq     %r10, %r9
	imulq    $8, %r9             /* mul_q    vr52<%rdx>, vr51<%r9>, $8 */
	movq     %r9, %rdx
	movq     %rcx, %r11          /* add_q    vr53<%r9>, vr48<%rcx>, vr52<%rdx> */
	addq     %rdx, %r11
	movq     %r11, %r9
	movq     %r9, %r10           /* mov_q    vr55<%rdx>, (vr53<%r9>) */
	movq     (%r10), %rdx
	movq     -6000016(%rbp), %r11 /* mul_q    vr54<%r9>, vr16, vr55<%rdx> */
	imulq    %rdx, %r11
	movq     %r11, %r9
	movq     -6000008(%rbp), %r10 /* add_q    vr56<%rdx>, vr17, vr54<%r9> */
	addq     %r9, %r10
	movq     %r10, %rdx
	movq     %r8, %r9            /* mov_q    vr62<%r9>, vr47<%r8> */
	movq     %r9, %r11           /* mov_q    (vr62<%r9>), vr56<%rdx> */
	movq     %rdx, (%r11)
	movl     %r13d, %r10d        /* add_l    vr64<%rdx>, vr14<%r13>, $1 */
	addl     $1, %r10d
	movl     %r10d, %edx
	movl     %edx, %r13d         /* mov_l    vr14<%r13>, vr64<%rdx> */
.L9:
	cmpl     %r12d, %r13d        /* cmplt_l  vr65<%r9>, vr14<%r13>, vr10<%r12> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr65<%r9>, .L8 */
	jne      .L8
	movl     %ebx, %r10d         /* add_l    vr67<%r9>, vr13<%rbx>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr13<%rbx>, vr67<%r9> */
.L7:
	cmpl     %r12d, %ebx         /* cmplt_l  vr68<%r9>, vr13<%rbx>, vr10<%r12> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr68<%r9>, .L6 */
	jne      .L6
	movl     %r14d, %r10d        /* add_l    vr70<%r9>, vr15<%r14>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %r14d         /* mov_l    vr15<%r14>, vr70<%r9> */
.L5:
	cmpl     %r12d, %r14d        /* cmplt_l  vr71<%r9>, vr15<%r14>, vr10<%r12> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr71<%r9>, .L4 */
	jne      .L4
	movl     $0, %ebx            /* mov_l    vr13<%rbx>, $0 */
	jmp      .L11                /* jmp      .L11 */
.L10:
	leaq     -2000000(%rbp), %r10 /* localaddr vr73<%r9>, $4000000 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr74<%r8>, vr13<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr75<%rcx>, vr74<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr76<%r8>, vr73<%r9>, vr75<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_q    vr1, (vr76<%r8>) */
	movq     (%r10), %rdi
	call     print_i64           /* call     print_i64 */
	call     print_nl            /* call     print_nl */
	movl     %ebx, %r11d         /* add_l    vr80<%r9>, vr13<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr13<%rbx>, vr80<%r9> */
.L11:
	cmpl     $250000, %ebx       /* cmplt_l  vr82<%r9>, vr13<%rbx>, $250000 */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr82<%r9>, .L10 */
	jne      .L10
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	popq     %r14                /* leave    $6000000 */
	popq     %r13
	popq     %r12
	popq     %rbx
	addq     $6000064, %rsp
	popq     %rbp
	ret                          /* ret       */
