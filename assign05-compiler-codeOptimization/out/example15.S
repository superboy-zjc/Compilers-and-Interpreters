/* x is stored in the 1, at the offset of 10 */
/* y is stored in the 1, at the offset of 11 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	pushq    %rbx
	subq     $8, %rsp
	call     read_i32            /* call     read_i32 */
	movl     %eax, %ebx          /* mov_l    vr10<%rbx>, vr0 */
	call     read_i32            /* call     read_i32 */
	movl     %ebx, %r10d         /* add_l    vr14<%r9>, vr10<%rbx>, vr0 */
	addl     %eax, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %eax          /* mov_l    vr0, vr14<%r9> */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $8, %rsp            /* leave    $0 */
	popq     %rbx
	addq     $16, %rsp
	popq     %rbp
	ret                          /* ret       */
