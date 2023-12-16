/*x is stored, at the offset of 0 */
/*y is stored, at the offset of 4 */
/* p is stored in the 0, at the offset of 0 */
/* q is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $8 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr11<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %r10           /* add_q    vr13<%r8>, vr11<%r9>, $0 */
	addq     $0, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr13<%r8>), $2 */
	movl     $2, (%r11)
	movq     %r9, %r10           /* add_q    vr16<%rcx>, vr11<%r9>, $4 */
	addq     $4, %r10
	movq     %r10, %rcx
	movq     %rcx, %r11          /* mov_l    (vr16<%rcx>), $3 */
	movl     $3, (%r11)
	movq     %r8, %r10           /* mov_l    vr23<%r9>, (vr13<%r8>) */
	movl     (%r10), %r9d
	movq     %rcx, %r11          /* mov_l    vr24<%r8>, (vr16<%rcx>) */
	movl     (%r11), %r8d
	movl     %r9d, %r10d         /* add_l    vr22<%rcx>, vr23<%r9>, vr24<%r8> */
	addl     %r8d, %r10d
	movl     %r10d, %ecx
	movl     %ecx, %eax          /* mov_l    vr0, vr22<%rcx> */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $16, %rsp           /* leave    $8 */
	popq     %rbp
	ret                          /* ret       */
