/* c is stored in the 1, at the offset of 10 */
	.section .text

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	movl     $-67, %edi          /* mov_l    vr1, $-67 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, %eax            /* mov_l    vr0, $0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $16, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
