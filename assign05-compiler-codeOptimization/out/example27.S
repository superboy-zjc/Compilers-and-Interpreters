/* i is stored in the 1, at the offset of 10 */
/* j is stored in the 1, at the offset of 11 */
/* n is stored in the 1, at the offset of 12 */
/* m is stored in the 0, at the offset of 0 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $400 */
	movq     %rsp, %rbp
	subq     $432, %rsp
	pushq    %rbx
	pushq    %r12
	pushq    %r13
	subq     $8, %rsp
	movl     $0, %ebx            /* mov_l    vr10<%rbx>, $0 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     $0, %r13d           /* mov_l    vr12<%r13>, $0 */
	movl     $0, %r12d           /* mov_l    vr11<%r12>, $0 */
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -400(%rbp), %r10    /* localaddr vr16<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr17<%r8>, vr10<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $40, %r8            /* mul_q    vr18<%rcx>, vr17<%r8>, $40 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr19<%r8>, vr16<%r9>, vr18<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movl     %r12d, %r10d        /* sconv_lq vr20<%rcx>, vr11<%r12> */
	movslq   %r10d, %r10
	movq     %r10, %rcx
	imulq    $4, %rcx            /* mul_q    vr21<%r9>, vr20<%rcx>, $4 */
	movq     %rcx, %r9
	movq     %r8, %r11           /* add_q    vr22<%rcx>, vr19<%r8>, vr21<%r9> */
	addq     %r9, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_l    (vr22<%rcx>), vr12<%r13> */
	movl     %r13d, (%r10)
	movl     %r13d, %r11d        /* add_l    vr23<%rcx>, vr12<%r13>, vr10<%rbx> */
	addl     %ebx, %r11d
	movl     %r11d, %ecx
	movl     %ecx, %r13d         /* mov_l    vr12<%r13>, vr23<%rcx> */
	movl     %r12d, %r10d        /* add_l    vr25<%rcx>, vr11<%r12>, $1 */
	addl     $1, %r10d
	movl     %r10d, %ecx
	movl     %ecx, %r12d         /* mov_l    vr11<%r12>, vr25<%rcx> */
.L3:
	cmpl     $9, %r12d           /* cmplte_l vr27<%r9>, vr11<%r12>, $9 */
	setle    %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr27<%r9>, .L2 */
	jne      .L2
	movl     %ebx, %r10d         /* add_l    vr29<%r9>, vr10<%rbx>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr10<%rbx>, vr29<%r9> */
.L1:
	cmpl     $9, %ebx            /* cmplte_l vr31<%r9>, vr10<%rbx>, $9 */
	setle    %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr31<%r9>, .L0 */
	jne      .L0
	movl     $0, %ebx            /* mov_l    vr10<%rbx>, $0 */
	jmp      .L5                 /* jmp      .L5 */
.L4:
	movl     $0, %r12d           /* mov_l    vr11<%r12>, $0 */
	jmp      .L7                 /* jmp      .L7 */
.L6:
	leaq     -400(%rbp), %r10    /* localaddr vr34<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr35<%r8>, vr10<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $40, %r8            /* mul_q    vr36<%rcx>, vr35<%r8>, $40 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr37<%r8>, vr34<%r9>, vr36<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movl     %r12d, %r10d        /* sconv_lq vr38<%rcx>, vr11<%r12> */
	movslq   %r10d, %r10
	movq     %r10, %rcx
	imulq    $4, %rcx            /* mul_q    vr39<%r9>, vr38<%rcx>, $4 */
	movq     %rcx, %r9
	movq     %r8, %r11           /* add_q    vr40<%rcx>, vr37<%r8>, vr39<%r9> */
	addq     %r9, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_l    vr1, (vr40<%rcx>) */
	movl     (%r10), %edi
	call     print_i32           /* call     print_i32 */
	call     print_space         /* call     print_space */
	movl     %r12d, %r11d        /* add_l    vr44<%r9>, vr11<%r12>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %r12d         /* mov_l    vr11<%r12>, vr44<%r9> */
.L7:
	cmpl     $9, %r12d           /* cmplte_l vr46<%r9>, vr11<%r12>, $9 */
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr46<%r9>, .L6 */
	jne      .L6
	call     print_nl            /* call     print_nl */
	movl     %ebx, %r11d         /* add_l    vr49<%r9>, vr10<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr10<%rbx>, vr49<%r9> */
.L5:
	cmpl     $9, %ebx            /* cmplte_l vr51<%r9>, vr10<%rbx>, $9 */
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr51<%r9>, .L4 */
	jne      .L4
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $8, %rsp            /* leave    $400 */
	popq     %r13
	popq     %r12
	popq     %rbx
	addq     $432, %rsp
	popq     %rbp
	ret                          /* ret       */
