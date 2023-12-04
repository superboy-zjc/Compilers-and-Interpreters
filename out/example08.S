/* a is stored in the 1, at the offset of 10 */
/* b is stored in the 1, at the offset of 11 */
/* c is stored in the 1, at the offset of 12 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	pushq    %rbx
	subq     $8, %rsp
	movl     $0, %r9d            /* mov_l    vr18<%r9>, $0 */
	cmpl     $0, %r9d            /* cjmp_f   vr18<%r9>, .L1 */
	je       .L1
	movl     $1, %ebx            /* mov_l    vr12<%rbx>, $1 */
	jmp      .L0                 /* jmp      .L0 */
.L1:
	movl     $2, %ebx            /* mov_l    vr12<%rbx>, $2 */
.L0:
	movl     %ebx, %eax          /* mov_l    vr0, vr12<%rbx> */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $8, %rsp            /* leave    $0 */
	popq     %rbx
	addq     $32, %rsp
	popq     %rbp
	ret                          /* ret       */
