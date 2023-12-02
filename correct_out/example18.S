/* n is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $80, %rsp
	movl     $10, -72(%rbp)      /* mov_l    vr10, $10 */
	jmp      .L1                 /* jmp      .L1 */
.L0:
	movl     -72(%rbp), %edi     /* mov_l    vr1, vr10 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     -72(%rbp), %r10d    /* sub_l    vr15, vr10, $1 */
	subl     $1, %r10d
	movl     %r10d, -32(%rbp)
	movl     -32(%rbp), %r11d    /* mov_l    vr10, vr15 */
	movl     %r11d, -72(%rbp)
.L1:
	cmpl     $0, -72(%rbp)       /* cmpgt_l  vr17, vr10, $0 */
	setg     %bpl
	movzbl   %bpl, %r11d
	movl     %r11d, -16(%rbp)
	cmpl     $0, -16(%rbp)       /* cjmp_t   vr17, .L0 */
	jne      .L0
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $80, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
