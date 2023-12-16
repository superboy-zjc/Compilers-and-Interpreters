/* a is stored in the 1, at the offset of 10 */ 
/* b is stored in the 1, at the offset of 11 */ 
/* result is stored in the 1, at the offset of 12 */
/* x is stored in the 1, at the offset of 10 */
/* y is stored in the 1, at the offset of 11 */
/* z is stored in the 1, at the offset of 12 */
	.section .text

	.globl sum
sum:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	movl     %edi, %r10d         /* add_l    vr13<%r9>, vr1, vr2 */
	addl     %esi, %r10d
	movl     %r10d, %r9d
	movl     %r9d, %eax          /* mov_l    vr0, vr13<%r9> */
	jmp      .Lsum_return        /* jmp      .Lsum_return */
.Lsum_return:
	addq     $32, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $32, %rsp
	movl     $2, %edi            /* mov_l    vr1, $2 */
	movl     $3, %esi            /* mov_l    vr2, $3 */
	call     sum                 /* call     sum */
	movl     %eax, %eax          /* mov_l    vr0, vr0 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $32, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
