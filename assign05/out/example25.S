/*x is stored, at the offset of 0 */
/*y is stored, at the offset of 4 */
/* points is stored in the 0, at the offset of 0 */
/* i is stored in the 1, at the offset of 10 */
/* count is stored in the 1, at the offset of 11 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $24 */
	movq     %rsp, %rbp
	subq     $48, %rsp
	pushq    %rbx
	pushq    %r12
	movl     $11, %r12d          /* mov_l    vr11<%r12>, $11 */
	movl     $0, %ebx            /* mov_l    vr10<%rbx>, $0 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	leaq     -24(%rbp), %r10     /* localaddr vr14<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr15<%r8>, vr10<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr16<%rcx>, vr15<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr17<%r8>, vr14<%r9>, vr16<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* add_q    vr19<%rcx>, vr17<%r8>, $0 */
	addq     $0, %r10
	movq     %r10, %rcx
	movq     %rcx, %r11          /* mov_l    (vr19<%rcx>), vr11<%r12> */
	movl     %r12d, (%r11)
	movl     %r12d, %r10d        /* add_l    vr21<%rcx>, vr11<%r12>, $1 */
	addl     $1, %r10d
	movl     %r10d, %ecx
	movq     %r8, %r11           /* add_q    vr27<%r9>, vr17<%r8>, $4 */
	addq     $4, %r11
	movq     %r11, %r9
	movq     %r9, %r10           /* mov_l    (vr27<%r9>), vr21<%rcx> */
	movl     %ecx, (%r10)
	movl     %ecx, %r11d         /* add_l    vr29<%r9>, vr21<%rcx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %r12d         /* mov_l    vr11<%r12>, vr29<%r9> */
	movl     %ebx, %r10d         /* add_l    vr31<%r9>, vr10<%rbx>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr10<%rbx>, vr31<%r9> */
.L1:
	cmpl     $3, %ebx            /* cmplt_l  vr33<%r9>, vr10<%rbx>, $3 */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr33<%r9>, .L0 */
	jne      .L0
	movl     $2, %ebx            /* mov_l    vr10<%rbx>, $2 */
	jmp      .L3                 /* jmp      .L3 */
.L2:
	leaq     -24(%rbp), %r10     /* localaddr vr35<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr36<%r8>, vr10<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr37<%rcx>, vr36<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr38<%r8>, vr35<%r9>, vr37<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* add_q    vr40<%rcx>, vr38<%r8>, $0 */
	addq     $0, %r10
	movq     %r10, %rcx
	movq     %rcx, %r11          /* mov_l    vr1, (vr40<%rcx>) */
	movl     (%r11), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	leaq     -24(%rbp), %r10     /* localaddr vr43<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr44<%r8>, vr10<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $8, %r8             /* mul_q    vr45<%rcx>, vr44<%r8>, $8 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr46<%r8>, vr43<%r9>, vr45<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* add_q    vr48<%rcx>, vr46<%r8>, $4 */
	addq     $4, %r10
	movq     %r10, %rcx
	movq     %rcx, %r11          /* mov_l    vr1, (vr48<%rcx>) */
	movl     (%r11), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     %ebx, %r10d         /* sub_l    vr52<%r9>, vr10<%rbx>, $1 */
	subl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr10<%rbx>, vr52<%r9> */
.L3:
	cmpl     $0, %ebx            /* cmpgte_l vr54<%r9>, vr10<%rbx>, $0 */
	setge    %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr54<%r9>, .L2 */
	jne      .L2
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	popq     %r12                /* leave    $24 */
	popq     %rbx
	addq     $48, %rsp
	popq     %rbp
	ret                          /* ret       */
