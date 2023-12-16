/* n is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	pushq    %rbx
	subq     $8, %rsp
	movl     $10, %ebx           /* mov_l    vr10<%rbx>, $10 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     %ebx, %edi          /* mov_l    vr1, vr10<%rbx> */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     %ebx, %r10d         /* sub_l    vr15<%r9>, vr10<%rbx>, $1 */
	subl     $1, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %ebx          /* mov_l    vr10<%rbx>, vr15<%r9> */
.L1:
	cmpl     $0, %ebx            /* cmpgt_l  vr17<%r9>, vr10<%rbx>, $0 */
	setg     %r11b
	movzbl   %r11b, %r11d
	movl     %r11d, %r9d
	cmpl     $0, %r9d            /* cjmp_t   vr17<%r9>, .L0 */
	jne      .L0
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $8, %rsp            /* leave    $0 */
	popq     %rbx
	addq     $16, %rsp
	popq     %rbp
	ret                          /* ret       */
