/* n is stored in the 1, at the offset of 10 */ 
/* a is stored in the 1, at the offset of 11 */
/* b is stored in the 1, at the offset of 12 */
/* c is stored in the 1, at the offset of 13 */
/* i is stored in the 1, at the offset of 14 */
/* n is stored in the 1, at the offset of 10 */
	.section .text

	.globl fib
fib:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $48, %rsp
	pushq    %rbx
	pushq    %r12
	pushq    %r13
	pushq    %r14
	movl     %edi, %r13d         /* mov_l    vr10<%r13>, vr1 */
	cmpl     $1, %edi            /* cmplte_l vr16<%r9>, vr1, $1 */
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_f   vr16<%r9>, .L0 */
	je       .L0
	movl     %r13d, %eax         /* mov_l    vr0, vr10<%r13> */
.L0:
	movl     $0, %r14d           /* mov_l    vr11<%r14>, $0 */
	movl     $1, %ebx            /* mov_l    vr12<%rbx>, $1 */
	movl     $2, %r12d           /* mov_l    vr14<%r12>, $2 */
	jmp      .L3                 /* jmp      .L3 */
.L2:
	movl     %r14d, %r11d        /* add_l    vr20<%r9>, vr11<%r14>, vr12<%rbx> */
	addl     %ebx, %r11d
	movl     %r11d, %r9d
	movl     %ebx, %r14d         /* mov_l    vr11<%r14>, vr12<%rbx> */
	movl     %r9d, %ebx          /* mov_l    vr12<%rbx>, vr20<%r9> */
	movl     %r12d, %r10d        /* add_l    vr22<%r9>, vr14<%r12>, $1 */
	addl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %r12d         /* mov_l    vr14<%r12>, vr22<%r9> */
.L3:
	cmpl     %r13d, %r12d        /* cmplte_l vr23<%r9>, vr14<%r12>, vr10<%r13> */
	setle    %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr23<%r9>, .L2 */
	jne      .L2
	movl     %ebx, %eax          /* mov_l    vr0, vr12<%rbx> */
	jmp      .Lfib_return        /* jmp      .Lfib_return */
.Lfib_return:
	popq     %r14                /* leave    $0 */
	popq     %r13
	popq     %r12
	popq     %rbx
	addq     $48, %rsp
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	call     read_i32            /* call     read_i32 */
	movl     %eax, %edi          /* mov_l    vr1, vr0 */
	call     fib                 /* call     fib */
	movl     %eax, %edi          /* mov_l    vr1, vr0 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $16, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
