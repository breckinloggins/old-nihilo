.code 32
.globl _start

_start:
	ldr 	pc, reset_handler_addr
	ldr		pc, undef_handler_addr
	ldr		pc, swi_handle_addr
	ldr 	pc, prefetch_abort_handler_addr
	ldr 	pc, data_abort_handler_addr
	b .
	ldr 	pc, irq_handler_addr
	ldr 	pc, fiq_handler_addr

reset_handler_addr: .word Reset_Handler
undef_handler_addr: .word undef_handler
swi_handle_addr: 	.word swi_handler
prefetch_abort_handler_addr: .word undef_handler
data_abort_handler_addr: .word undef_handler
irq_handler_addr: .word IRQ_Handler
fiq_handler_addr: .word undef_handler

	.align 2
undef_handler:
	bl 		.

	.align 2
swi_handler:
	push {lr}

	ldr 	r0, =EXC_SWI_STR
	bl 		print_str_uart0

	pop	{lr}
	subs	pc, lr, #4
	
	/*
	ldr 	r0, =EXC_SWI_STR
	bl 		print_str_uart0
	subs	pc, lr, #4
	*/

	.align 2
Reset_Handler:
	@ Set supervisor stack
	@ldr 	sp, =stack_top
	mov 	sp, #0x20000

	ldr		r0, =EXC_RESET_STR
	bl 		print_str_uart0
	
	@ Get program status register
	mrs 	r0, cpsr

	@ Go to IRQ mode and set the stack
	bic 	r1, r0, #0x1F
	orr 	r1, r1, #0x12
	msr 	cpsr, r1

	@ldr 	sp, =stack_top + 1000
	mov 	sp, #0x21000

	@ Turn on 'dem interrupts!
	bic 	r0, r0, #0x80

	@ Go back to supervisor mode and go do something interesting
	msr  	cpsr, r0

	bl 		nihilo_entry
	b 		.
