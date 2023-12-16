/* a is stored in the 1, at the offset of 10 */ 
/* n is stored in the 1, at the offset of 11 */ 
/* i is stored in the 1, at the offset of 12 */
/* sum is stored in the 1, at the offset of 13 */
/* arr is stored in the 0, at the offset of 0 */
/* result is stored in the 1, at the offset of 10 */
	.section .text

	.globl sum
sum:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	pushq    %rbx
	pushq    %r12
	pushq    %r13
	pushq    %r14
	movq     %rdi, %r14          /* mov_q    vr10<%r14>, vr1 */
	movl     %esi, %r13d         /* mov_l    vr11<%r13>, vr2 */
	movl     $0, %r12d           /* mov_l    vr13<%r12>, $0 */
	movl     $0, %ebx            /* mov_l    vr12<%rbx>, $0 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     %ebx, %r10d         /* sconv_lq vr16<%r9>, vr12<%rbx> */
	movslq   %r10d, %r10
	movq     %r10, %r9
	imulq    $4, %r9             /* mul_q    vr17<%r8>, vr16<%r9>, $4 */
	movq     %r9, %r8
	movq     %r14, %r11          /* add_q    vr18<%r9>, vr10<%r14>, vr17<%r8> */
	addq     %r8, %r11
	movq     %r11, %r9
	movq     %r9, %r10           /* mov_l    vr20<%r8>, (vr18<%r9>) */
	movl     (%r10), %r8d
	movl     %r12d, %r11d        /* add_l    vr19<%r9>, vr13<%r12>, vr20<%r8> */
	addl     %r8d, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %r12d         /* mov_l    vr13<%r12>, vr19<%r9> */
	movl     %ebx, %r10d         /* add_l    vr22<%r9>, vr12<%rbx>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr12<%rbx>, vr22<%r9> */
.L1:
	cmpl     %r13d, %ebx         /* cmplt_l  vr23<%r9>, vr12<%rbx>, vr11<%r13> */
	setl     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr23<%r9>, .L0 */
	jne      .L0
	movl     %r12d, %eax         /* mov_l    vr0, vr13<%r12> */
	jmp      .Lsum_return        /* jmp      .Lsum_return */
.Lsum_return:
	popq     %r14                /* leave    $0 */
	popq     %r13
	popq     %r12
	popq     %rbx
	addq     $32, %rsp
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $12 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	leaq     -16(%rbp), %r10     /* localaddr vr11<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %r10           /* add_q    vr15<%r8>, vr11<%r9>, $0 */
	addq     $0, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr15<%r8>), $1 */
	movl     $1, (%r11)
	movq     %r9, %r10           /* add_q    vr21<%r8>, vr11<%r9>, $4 */
	addq     $4, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr21<%r8>), $2 */
	movl     $2, (%r11)
	movq     %r9, %r10           /* add_q    vr27<%r8>, vr11<%r9>, $8 */
	addq     $8, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr27<%r8>), $3 */
	movl     $3, (%r11)
	movq     %r9, %rdi           /* mov_q    vr1, vr11<%r9> */
	movl     $3, %esi            /* mov_l    vr2, $3 */
	call     sum                 /* call     sum */
	movl     %eax, %eax          /* mov_l    vr0, vr0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $32, %rsp           /* leave    $12 */
	popq     %rbp
	ret                          /* ret       */
