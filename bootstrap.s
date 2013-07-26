	.arch armv7-a
	.fpu vfpv3
	.text
	.code 32

@ Prints the string pointed to by r0 to the UART
	.align 2
	.global print_str_uart0
print_str_uart0:
	push 	{r0-r3, lr}
	@ This routine allows us to print onto UART0DR
	@ We use r0 as the mem address for our char *
	ldrb	r3, [r0, #0]
	cmp		r3, #0
	bxeq	lr
	ldr 	r2, =UART0_ADR
	ldr 	r2, [r2, #0]
print_str_uart0_loop:
	str		r3, [r2, #0]
	ldrb	r3, [r0, #1]!
	cmp		r3, #0
	bne		print_str_uart0_loop
	
	pop 	{r0-r3, pc}

	.align 2
@ Prints the hexadecimal value in r0 to the UART
print_hex_uart0:
	push 	{r0-r3, lr}
	mov 	r1, r0
	ldr 	r0, =HEX_PREFIX_STR
	bl 		print_str_uart0

	mov 	r0, r1
	add 	r0, r0, #'0'
	ldr 	r2, =UART0_ADR
	ldr 	r2, [r2, #0]
	str 	r0, [r2, #0]
	
	pop 	{r0-r3, pc}

	.align 2
@ IRQ Handler
	.global IRQ_Handler
IRQ_Handler:
	push 	{lr}
	ldr 	r0, =IRQ_STRING
	bl 		print_str_uart0
	pop 	{lr}
	subs	pc, lr, #4
	
	.align 2
@ MAIN - Where it all begins
	.global nihilo_entry
	@ This is the main entry point from startup.s
nihilo_entry:
	ldr 	r0, =WELCOME_STR
	bl 		print_str_uart0

	@mov 	r0, #9
	@bl 		print_hex_uart0

	@ Get the UART0 interrupt handler going
	ldr 	r0, =PIC_ADR
	ldr 	r0, [r0, #0x10]			@ Control reg
	mov 	r1, #1				@ Enable UART0
	lsl 	r1, r1, #12
	str 	r1, [r0, #0x10]

	ldr 	r0, =UART0_ADR
	ldr 	r0, [r0, #0x38]
	mov 	r1, #1				@ UART RXIM Mask
	lsl 	r1, r1, #4
	ldr 	r1, [r1]
	str 	r1, [r0, #0x38]
	
	@ Switch to user mode
	msr 	cpsr, #0x10

	ldr 	r0, =USER_STR
	bl 		print_str_uart0
	
	@ swi 0x123
	@ svc 	0x5

	b .


@ --- Versatile PB Memory Map ---
	.align 2
	.section	.rodata

@ PrimeCell PL190 Vectored Interrupt Controller (PIC)
PIC_ADR:			.word 	0x10140000 

@ PrimeCell PL011 UART 0
UART0_ADR:			.word 	0x101F1000

@ -- Global Variables ---

	.section 	.rodata.str1.4, "aMS",%progbits,1
WELCOME_STR:	.ascii	"Nihilo\012\000"
USER_STR:		.ascii 	"Switched to user mode\012\000"
IRQ_STRING:		.ascii 	"IRQ\012\000"
HEX_PREFIX_STR:	.ascii  "0x\000"

DBG_1:			.ascii 	"Got here 1\012\000"

	.global EXC_RESET_STR
	.global EXC_SWI_STR
EXC_RESET_STR:	.ascii	"Reset handler\012\000"
EXC_SWI_STR:	.ascii 	"SWI Handler\012\000"
