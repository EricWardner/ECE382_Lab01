;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections


            .global main                    ; that have references to current
                                            ; section


op1:		.byte	0x14, 0x11, 0x32, 0x22, 0x08, 0x44, 0x04, 0x22, 0x02, 0x55
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------

			mov.w	#op1, r5				;r5 is the array pointer
			mov.w	#0x200, r10				;result array in RAM

			mov.b	@r5+, r8				;stores operand
getFunc		mov.b	@r5+, r6				;stores operator
			mov.b	@r5+, r7				;stores 2nd operand

ClrJMP		cmp.b	#0x11, r6
			jeq		ADD_OP
			cmp.b	#0x22, r6
			jeq		SUB_OP
			cmp.b	#0x33, r6
			jeq		MUL_OP
			cmp.b	#0x44, r6
			jeq		CLR_OP
			cmp.b	#0x55, r6
			jeq		END_OP

			jmp		END_OP


ADD_OP		add.b	r7, r8
			mov.b	r8, 0(r10)
			inc.w	r10
			jmp		getFunc

SUB_OP		sub.b	r7, r8
			mov.b	r8, 0(r10)
			inc.w	r10
			jmp		getFunc


MUL_OP		add.b	r7, r8
			mov.b	r8, 0(r10)
			inc		r10
			rla.b	r7
			tst		r7
			jz		endMul
			rla.b	r8
			jmp		MUL_OP

endMul		inc.w	r10
			jmp		getFunc


CLR_OP		mov.b	#0x00, 0(r10)
			inc.w	r10
			mov.b	r7, r8
			mov.b	@r5+, r6				;stores operator
			mov.b	@r5+, r7
			jmp		ClrJMP


END_OP		jmp		END_OP




;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
