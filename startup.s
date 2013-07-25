.global _Reset
.global vectors_start
.global vectors_end

vectors_start:
_Reset:
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
swi_handle_addr: 	.word undef_handler
prefetch_abort_handler_addr: .word undef_handler
data_abort_handler_addr: .word undef_handler
irq_handler_addr: .word IRQ_Handler
fiq_handler_addr: .word undef_handler

vectors_end:

undef_handler:
	bl 		.

Reset_Handler:
	@ Set supervisor stack
	ldr 	sp, =stack_top

	@ Move the vector table
	/*bl		copy_vectors*/
	
	@ Get program status register
	mrs 	r0, cpsr

	@ Go to IRQ mode and set the stack
	bic 	r1, r0, #0x1F
	orr 	r1, r1, #0x12
	msr 	cpsr, r1

	ldr 	sp, =stack_top + 1000

	@ Turn on 'dem interrupts!
	bic 	r0, r0, #0x80

	@ Go back to supervisor mode and go do something interesting
	msr  	cpsr, r0
	bl 		nihilo_entry
	b 		.
