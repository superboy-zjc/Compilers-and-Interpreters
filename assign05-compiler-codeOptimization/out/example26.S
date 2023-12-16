/*name is stored, at the offset of 0 */
/*age is stored, at the offset of 20 */
/* p is stored in the 0, at the offset of 0 */
/* s is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $24 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	leaq     -24(%rbp), %r10     /* localaddr vr11<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %r10           /* add_q    vr13<%r8>, vr11<%r9>, $0 */
	addq     $0, %r10
	movq     %r10, %r8
	movq     %r8, %r11           /* add_q    vr17<%rcx>, vr13<%r8>, $0 */
	addq     $0, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_b    (vr17<%rcx>), $65 */
	movb     $65, (%r10)
	movq     %r8, %r11           /* add_q    vr25<%rcx>, vr13<%r8>, $1 */
	addq     $1, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_b    (vr25<%rcx>), $108 */
	movb     $108, (%r10)
	movq     %r8, %r11           /* add_q    vr33<%rcx>, vr13<%r8>, $2 */
	addq     $2, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_b    (vr33<%rcx>), $105 */
	movb     $105, (%r10)
	movq     %r8, %r11           /* add_q    vr41<%rcx>, vr13<%r8>, $3 */
	addq     $3, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_b    (vr41<%rcx>), $99 */
	movb     $99, (%r10)
	movq     %r8, %r11           /* add_q    vr49<%rcx>, vr13<%r8>, $4 */
	addq     $4, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_b    (vr49<%rcx>), $101 */
	movb     $101, (%r10)
	movq     %r8, %r11           /* add_q    vr57<%rcx>, vr13<%r8>, $5 */
	addq     $5, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_b    (vr57<%rcx>), $0 */
	movb     $0, (%r10)
	movq     %r9, %r11           /* add_q    vr61<%rcx>, vr11<%r9>, $20 */
	addq     $20, %r11
	movq     %r11, %rcx
	movq     %rcx, %r10          /* mov_l    (vr61<%rcx>), $43 */
	movl     $43, (%r10)
	movq     %r8, %rdi           /* mov_q    vr1, vr13<%r8> */
	call     print_str           /* call     print_str */
	call     print_nl            /* call     print_nl */
	leaq     -24(%rbp), %r10     /* localaddr vr68<%r9>, $0 */
	movq     %r10, %r9
	movq     %r9, %r11           /* add_q    vr70<%r8>, vr68<%r9>, $20 */
	addq     $20, %r11
	movq     %r11, %r8
	movq     %r8, %r10           /* mov_l    vr1, (vr70<%r8>) */
	movl     (%r10), %edi
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $32, %rsp           /* leave    $24 */
	popq     %rbp
	ret                          /* ret       */
