.global _Reset
_Reset:
	B Reset_Handler	/* Reset 			*/
	B .				/* Undefined 		*/
	B .				/* SWI				*/
	B .				/* Prefetch Abort	*/
	B .				/* Data Abort		*/
	B .				/* reserved			*/
	B IRQ_Handler	/* IRQ				*/
	B .				/* FIQ				*/

Reset_Handler:
	LDR sp, =stack_top
	BL nihilo_entry
	B .
