/* c is stored in the 1, at the offset of 10 */ 
	.section .text

	.globl ctoi
ctoi:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $16, %rsp
	movb     %dil, -16(%rbp)     /* mov_b    vr10, vr1 */
	movb     -16(%rbp), %r10b    /* sconv_bl vr11, vr10 */
	movsbl   %r10b, %r10d
	movl     %r10d, -8(%rbp)
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr11 */
	jmp      .Lctoi_return       /* jmp      .Lctoi_return */
.Lctoi_return:
	addq     $16, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $176, %rsp
	movb     $72, -168(%rbp)     /* mov_b    vr10, $72 */
	movb     -168(%rbp), %dil    /* mov_b    vr1, vr10 */
	call     ctoi                /* call     ctoi */
	movl     %eax, -160(%rbp)    /* mov_l    vr11, vr0 */
	movl     -160(%rbp), %edi    /* mov_l    vr1, vr11 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movb     $101, -136(%rbp)    /* mov_b    vr14, $101 */
	movb     -136(%rbp), %dil    /* mov_b    vr1, vr14 */
	call     ctoi                /* call     ctoi */
	movl     %eax, -128(%rbp)    /* mov_l    vr15, vr0 */
	movl     -128(%rbp), %edi    /* mov_l    vr1, vr15 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movb     $108, -104(%rbp)    /* mov_b    vr18, $108 */
	movb     -104(%rbp), %dil    /* mov_b    vr1, vr18 */
	call     ctoi                /* call     ctoi */
	movl     %eax, -96(%rbp)     /* mov_l    vr19, vr0 */
	movl     -96(%rbp), %edi     /* mov_l    vr1, vr19 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movb     $108, -72(%rbp)     /* mov_b    vr22, $108 */
	movb     -72(%rbp), %dil     /* mov_b    vr1, vr22 */
	call     ctoi                /* call     ctoi */
	movl     %eax, -64(%rbp)     /* mov_l    vr23, vr0 */
	movl     -64(%rbp), %edi     /* mov_l    vr1, vr23 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movb     $111, -40(%rbp)     /* mov_b    vr26, $111 */
	movb     -40(%rbp), %dil     /* mov_b    vr1, vr26 */
	call     ctoi                /* call     ctoi */
	movl     %eax, -32(%rbp)     /* mov_l    vr27, vr0 */
	movl     -32(%rbp), %edi     /* mov_l    vr1, vr27 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, -8(%rbp)        /* mov_l    vr30, $0 */
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr30 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $176, %rsp          /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
