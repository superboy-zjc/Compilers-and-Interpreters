/* a is stored in the 0, at the offset of 0 */
/* p is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $4 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	pushq    %rbx
	subq     $8, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr11<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %rbx           /* mov_q    vr10<%rbx>, vr11<%r9> */
	movq     %rbx, %r10          /* mov_l    (vr10<%rbx>), $42 */
	movl     $42, (%r10)
	movq     %r9, %r11           /* mov_l    vr0, (vr11<%r9>) */
	movl     (%r11), %eax
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $8, %rsp            /* leave    $4 */
	popq     %rbx
	addq     $16, %rsp
	popq     %rbp
	ret                          /* ret       */
