/* arr is stored in the 0, at the offset of 0 */
/* sum is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $4 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr11<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %r10           /* add_q    vr15<%r8>, vr11<%r9>, $0 */
	addq     $0, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* mov_l    (vr15<%r8>), $2 */
	movl     $2, (%r11)
	movq     %r8, %r10           /* mov_l    vr24<%r9>, (vr15<%r8>) */
	movl     (%r10), %r9d
	movl     %r9d, %r11d         /* add_l    vr23<%r8>, vr24<%r9>, $1 */
	addl     $1, %r11d
	movl     %r11d, %r8d
	movl     %r8d, %eax          /* mov_l    vr0, vr23<%r8> */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $16, %rsp           /* leave    $4 */
	popq     %rbp
	ret                          /* ret       */
