/* n is stored in the 1, at the offset of 10 */
/* i is stored in the 1, at the offset of 11 */
/* sum is stored in the 1, at the offset of 12 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	pushq    %rbx
	pushq    %r12
	pushq    %r13
	subq     $8, %rsp
	movl     $11, %r13d          /* mov_l    vr10<%r13>, $11 */
	movl     $1, %ebx            /* mov_l    vr11<%rbx>, $1 */
	movl     $0, %r12d           /* mov_l    vr12<%r12>, $0 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     %r12d, %r10d        /* add_l    vr16<%r9>, vr12<%r12>, vr11<%rbx> */
	addl     %ebx, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %r12d         /* mov_l    vr12<%r12>, vr16<%r9> */
	movl     %ebx, %r11d         /* add_l    vr18<%r9>, vr11<%rbx>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr11<%rbx>, vr18<%r9> */
.L1:
	cmpl     %r13d, %ebx         /* cmplte_l vr19<%r9>, vr11<%rbx>, vr10<%r13> */
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr19<%r9>, .L0 */
	jne      .L0
	movl     %r12d, %eax         /* mov_l    vr0, vr12<%r12> */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $8, %rsp            /* leave    $0 */
	popq     %r13
	popq     %r12
	popq     %rbx
	addq     $32, %rsp
	popq     %rbp
	ret                          /* ret       */
