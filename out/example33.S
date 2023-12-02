/* n is stored in the 1, at the offset of 10 */ 
/* a is stored in the 1, at the offset of 11 */
/* b is stored in the 1, at the offset of 12 */
/* c is stored in the 1, at the offset of 13 */
/* i is stored in the 1, at the offset of 14 */
/* n is stored in the 1, at the offset of 10 */
	.section .text

	.globl fib
fib:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $112, %rsp
	movl     %edi, -112(%rbp)    /* mov_l    vr10, vr1 */
	movl     $1, -72(%rbp)       /* mov_l    vr15, $1 */
	movl     -112(%rbp), %r10d   /* cmplte_l vr16, vr10, vr15 */
	cmpl     -72(%rbp), %r10d
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -64(%rbp)
	cmpl     $0, -64(%rbp)       /* cjmp_f   vr16, .L0 */
	je       .L0
	movl     -112(%rbp), %eax    /* mov_l    vr0, vr10 */
.L0:
	movl     $0, -56(%rbp)       /* mov_l    vr17, $0 */
	movl     -56(%rbp), %r11d    /* mov_l    vr11, vr17 */
	movl     %r11d, -104(%rbp)
	movl     $1, -48(%rbp)       /* mov_l    vr18, $1 */
	movl     -48(%rbp), %r10d    /* mov_l    vr12, vr18 */
	movl     %r10d, -96(%rbp)
	movl     $2, -40(%rbp)       /* mov_l    vr19, $2 */
	movl     -40(%rbp), %r11d    /* mov_l    vr14, vr19 */
	movl     %r11d, -80(%rbp)
	jmp      .L3                 /* jmp      .L3 */
.L2:
	movl     -104(%rbp), %r10d   /* add_l    vr20, vr11, vr12 */
	addl     -96(%rbp), %r10d
	movl     %r10d, -32(%rbp)
	movl     -32(%rbp), %r11d    /* mov_l    vr13, vr20 */
	movl     %r11d, -88(%rbp)
	movl     -96(%rbp), %r10d    /* mov_l    vr11, vr12 */
	movl     %r10d, -104(%rbp)
	movl     -88(%rbp), %r11d    /* mov_l    vr12, vr13 */
	movl     %r11d, -96(%rbp)
	movl     $1, -24(%rbp)       /* mov_l    vr21, $1 */
	movl     -80(%rbp), %r10d    /* add_l    vr22, vr14, vr21 */
	addl     -24(%rbp), %r10d
	movl     %r10d, -16(%rbp)
	movl     -16(%rbp), %r11d    /* mov_l    vr14, vr22 */
	movl     %r11d, -80(%rbp)
.L3:
	movl     -80(%rbp), %r10d    /* cmplte_l vr23, vr14, vr10 */
	cmpl     -112(%rbp), %r10d
	setle    %r10b
	movzbl   %r10b, %r11d
	movl     %r11d, -8(%rbp)
	cmpl     $0, -8(%rbp)        /* cjmp_t   vr23, .L2 */
	jne      .L2
	movl     -96(%rbp), %eax     /* mov_l    vr0, vr12 */
	jmp      .Lfib_return        /* jmp      .Lfib_return */
.Lfib_return:
	addq     $112, %rsp          /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */

	.globl main
main:
	pushq    %rbp                /* enter    $0 */
	movq     %rsp, %rbp
	subq     $48, %rsp
	call     read_i32            /* call     read_i32 */
	movl     %eax, -40(%rbp)     /* mov_l    vr11, vr0 */
	movl     -40(%rbp), %r10d    /* mov_l    vr10, vr11 */
	movl     %r10d, -48(%rbp)
	movl     -48(%rbp), %edi     /* mov_l    vr1, vr10 */
	call     fib                 /* call     fib */
	movl     %eax, -32(%rbp)     /* mov_l    vr12, vr0 */
	movl     -32(%rbp), %r11d    /* mov_l    vr10, vr12 */
	movl     %r11d, -48(%rbp)
	movl     -48(%rbp), %edi     /* mov_l    vr1, vr10 */
	call     print_i32           /* call     print_i32 */
	call     print_nl            /* call     print_nl */
	movl     $0, -8(%rbp)        /* mov_l    vr15, $0 */
	movl     -8(%rbp), %eax      /* mov_l    vr0, vr15 */
	jmp      .Lmain_return       /* jmp      .Lmain_return */
.Lmain_return:
	addq     $48, %rsp           /* leave    $0 */
	popq     %rbp
	ret                          /* ret       */
