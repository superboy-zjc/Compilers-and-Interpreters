/* a is stored in the 0, at the offset of 0 */
/* p is stored in the 0, at the offset of 8 */
/* pp is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $16 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	leaq     -8(%rbp), %r10      /* localaddr vr11<%r9>, $8 */
	movq     %r10, %r9
	leaq     -16(%rbp), %r10     /* localaddr vr12<%r8>, $0 */
	movq     %r10, %r8
	movq     %r9, %r10           /* mov_q    (vr11<%r9>), vr12<%r8> */
	movq     %r8, (%r10)
	movq     %r9, %r11           /* mov_q    vr14<%rcx>, (vr11<%r9>) */
	movq     (%r11), %rcx
	movq     %rcx, %r10          /* mov_l    (vr14<%rcx>), $17 */
	movl     $17, (%r10)
	movq     %r8, %r11           /* mov_l    vr0, (vr12<%r8>) */
	movl     (%r11), %eax
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $32, %rsp           /* leave    $16 */
	popq     %rbp
	ret                          /* ret       */
