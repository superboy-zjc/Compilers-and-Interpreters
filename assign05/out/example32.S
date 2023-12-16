/* arr is stored in the 0, at the offset of 0 */ 
/* i is stored in the 1, at the offset of 10 */ 
/* j is stored in the 1, at the offset of 11 */ 
/* tmp is stored in the 1, at the offset of 12 */
/* arr is stored in the 0, at the offset of 0 */ 
/* n is stored in the 1, at the offset of 10 */ 
/* i is stored in the 1, at the offset of 11 */
/* tmp is stored in the 1, at the offset of 12 */
/* a is stored in the 0, at the offset of 0 */
/* i is stored in the 1, at the offset of 10 */
	.section .text

	.globl swap
swap:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	pushq    %r13
	subq     $8, %rsp
	leaq     0(%rbp), %r10       /* localaddr vr13<%r9>, $0 */
	movq     %r10, %r9
	movl     %esi, %r10d         /* sconv_lq vr14<%r8>, vr2 */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $4, %r8             /* mul_q    vr15<%rcx>, vr14<%r8>, $4 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr16<%r8>, vr13<%r9>, vr15<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_l    vr12<%r13>, (vr16<%r8>) */
	movl     (%r10), %r13d
	movq     %r8, %rcx           /* mov_q    vr20<%rcx>, vr16<%r8> */
	movl     %edx, %r11d         /* sconv_lq vr22<%r8>, vr3 */
	movslq   %r11d, %r11
	movq     %r11, %r8
	imulq    $4, %r8             /* mul_q    vr23<%rdx>, vr22<%r8>, $4 */
	movq     %r8, %rdx
	movq     %r9, %r10           /* add_q    vr24<%r8>, vr13<%r9>, vr23<%rdx> */
	addq     %rdx, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr20<%rcx>), (vr24<%r8>) */
	movq     %rcx, %r10
	movl     (%r11), %r11d
	movl     %r11d, (%r10)
	movq     %r8, %rcx           /* mov_q    vr28<%rcx>, vr24<%r8> */
	movq     %rcx, %r10          /* mov_l    (vr28<%rcx>), vr12<%r13> */
	movl     %r13d, (%r10)
	jmp      .Lswap_return       /* jmp      .Lswap_return */
.Lswap_return:
	addq     $8, %rsp            /* leave    $0 */
	popq     %r13
	addq     $32, %rsp
	popq     %rbp
	ret                          /* ret       */

	.globl bubble
bubble:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	pushq    %rbx
	pushq    %r12
	movl     %esi, %r12d         /* mov_l    vr10<%r12>, vr2 */
	movl     $1, %ebx            /* mov_l    vr11<%rbx>, $1 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	leaq     0(%rbp), %r10       /* localaddr vr14<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr15<%r8>, vr11<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $4, %r8             /* mul_q    vr16<%rcx>, vr15<%r8>, $4 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr17<%r8>, vr14<%r9>, vr16<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movl     %ebx, %r10d         /* sub_l    vr20<%rcx>, vr11<%rbx>, $1 */
	subl     $1, %r10d
	movl     %r10d, %ecx
	movl     %ecx, %r11d         /* sconv_lq vr21<%rdx>, vr20<%rcx> */
	movslq   %r11d, %r11
	movq     %r11, %rdx
	imulq    $4, %rdx            /* mul_q    vr22<%rcx>, vr21<%rdx>, $4 */
	movq     %rdx, %rcx
	movq     %r9, %r10           /* add_q    vr23<%rdx>, vr14<%r9>, vr22<%rcx> */
	addq     %rcx, %r10
	movq     %r10, %rdx
	movq     %r8, %r11           /* mov_l    vr25<%rcx>, (vr17<%r8>) */
	movl     (%r11), %ecx
	movq     %rdx, %r10          /* mov_l    vr26<%r8>, (vr23<%rdx>) */
	movl     (%r10), %r8d
	cmpl     %r8d, %ecx          /* cmplt_l  vr24<%rdx>, vr25<%rcx>, vr26<%r8> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %edx
	cmpl     $0, %edx            /* cjmp_f   vr24<%rdx>, .L2 */
	je       .L2
	leaq     0(%rbp), %r10       /* localaddr vr27<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sub_l    vr29<%r8>, vr11<%rbx>, $1 */
	subl     $1, %r10d
	movl     %r10d, %r8d
	movq     %r9, %rdi           /* mov_q    vr1, vr27<%r9> */
	movl     %r8d, %esi          /* mov_l    vr2, vr29<%r8> */
	movl     %ebx, %edx          /* mov_l    vr3, vr11<%rbx> */
	call     swap                /* call     swap */
.L2:
	movl     %ebx, %r11d         /* add_l    vr32<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr32<%r9> */
.L1:
	cmpl     %r12d, %ebx         /* cmplt_l  vr33<%r9>, vr11<%rbx>, vr10<%r12> */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr33<%r9>, .L0 */
	jne      .L0
	jmp      .Lbubble_return     /* jmp      .Lbubble_return */
.Lbubble_return:
	popq     %r12                /* leave    $0 */
	popq     %rbx
	addq     $32, %rsp
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $20 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	pushq    %rbx
	subq     $8, %rsp
	leaq     -24(%rbp), %r10     /* localaddr vr11<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %r10           /* add_q    vr15<%r8>, vr11<%r9>, $0 */
	addq     $0, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr15<%r8>), $52 */
	movl     $52, (%r11)
	movq     %r9, %r10           /* add_q    vr21<%r8>, vr11<%r9>, $4 */
	addq     $4, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr21<%r8>), $31 */
	movl     $31, (%r11)
	movq     %r9, %r10           /* add_q    vr27<%r8>, vr11<%r9>, $8 */
	addq     $8, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr27<%r8>), $8 */
	movl     $8, (%r11)
	movq     %r9, %r10           /* add_q    vr33<%r8>, vr11<%r9>, $12 */
	addq     $12, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr33<%r8>), $41 */
	movl     $41, (%r11)
	movq     %r9, %r10           /* add_q    vr39<%r8>, vr11<%r9>, $16 */
	addq     $16, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr39<%r8>), $75 */
	movl     $75, (%r11)
	movq     %r9, %rdi           /* mov_q    vr1, vr11<%r9> */
	movl     $5, %esi            /* mov_l    vr2, $5 */
	call     bubble              /* call     bubble */
	movl     $0, %ebx            /* mov_l    vr10<%rbx>, $0 */
	jmp      .L5                 /* jmp      .L5 */
.L4:
	leaq     -24(%rbp), %r10     /* localaddr vr45<%r9>, $0 */
	movq     %r10, %r9
	movl     %ebx, %r10d         /* sconv_lq vr46<%r8>, vr10<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r8
	imulq    $4, %r8             /* mul_q    vr47<%rcx>, vr46<%r8>, $4 */
	movq     %r8, %rcx
	movq     %r9, %r11           /* add_q    vr48<%r8>, vr45<%r9>, vr47<%rcx> */
	addq     %rcx, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_l    vr1, (vr48<%r8>) */
	movl     (%r10), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     %ebx, %r11d         /* add_l    vr52<%r9>, vr10<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr10<%rbx>, vr52<%r9> */
.L5:
	cmpl     $5, %ebx            /* cmplt_l  vr54<%r9>, vr10<%rbx>, $5 */
	setl     %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr54<%r9>, .L4 */
	jne      .L4
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $8, %rsp            /* leave    $20 */
	popq     %rbx
	addq     $32, %rsp
	popq     %rbp
	ret                          /* ret       */
