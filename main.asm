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


op1:		.byte	0x14 0x11 0x32 0x22 0x08 0x44 0x04 0x11 0x08 0x55
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------

			mov.w	#op1, r5				;r5 is the array pointer
			mov.w	#0x200, r10				;result array in RAM

getFunc		mov.b	@r5+, r7				;stores operand
			mov.b	@r5+, r6				;stores operator
			mov.b	@r5+, r8				;stores 2nd operand

			cmp.b	r6, #0x11
			jeq		ADD_OP
			cmp.b	r6, #0x22
			jeq		SUB_OP
			cmp.b	r6, #0x33
			jeq		MUL_OP
			cmp.b	r6, #0x44
			jeq		CLR_OP
			cmp.b	r6, #0x55
			jeq		END_OP

			jmp		END_OP


ADD_OP		add.b	r7, r8
			mov.w	r8, @r10
			inc.b	r10
			jmp		getFunc

SUB_OP		sub.b	r7, r8
			mov.w	r8, @r10
			inc.b	r10
			jmp		getFunc


MUL_OP		add.b	r7, r8
			mov.w	r8, @r10
			inc		r10
			rla.b	r7
			tst		r7
			jz		getFunc
			rla.b	r8
			jmp		MUL_OP


CLR_OP		mov.b	#0x00, @r10
			inc.b	r10
			jmp		getFunc

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
