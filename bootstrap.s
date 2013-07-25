	.arch armv7-a
	.fpu vfpv3
	.text

@ Prints the string pointed to by r0 to the UART
	.global print_uart0
print_uart0:
	@ This routine allows us to print onto UART0DR
	@ We use r0 as the mem address for our char *
	ldrb	r3, [r0, #0]
	cmp		r3, #0
	bxeq	lr
	ldr 	r2, =UART0_ADR
	ldr 	r2, [r2, #0]
print_uart0_loop:
	str		r3, [r2, #0]
	ldrb	r3, [r0, #1]!
	cmp		r3, #0
	bne		print_uart0_loop
	bx 		lr

@ IRQ Handler
	.global IRQ_Handler
IRQ_Handler:
	ldr 	r0, =IRQ_STRING
	bl 		print_uart0
	subs	pc, lr, #4

@ MAIN - Where it all begins
	.global nihilo_entry
	@ This is the main entry point from startup.s
nihilo_entry:
	ldr 	r0, =WELCOME_STR
	bl 		print_uart0
	b 		.

@ --- Versatile PB Memory Map ---
	.section	.rodata

	.global PIC_ADR
PIC_ADR:
	.word 	0x10140000 	@ PrimeCell PL190 Vectored Interrupt Controller (PIC)

	.global UART0_ADR
UART0_ADR:
	.word 	0x101F1000	@ PrimeCell PL011 UART 0

@ -- Global Variables ---

	.section 	.rodata.str1.4, "aMS",%progbits,1
WELCOME_STR: @ The string to print
	.ascii	"Nihilo\012\000"

IRQ_STRING:
	.ascii "IRQ\012\000"
