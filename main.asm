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


op1:		.byte	0x22, 0x11, 0x22, 0x22, 0x33, 0x33, 0x08, 0x44, 0x08, 0x22, 0x09, 0x44, 0xff, 0x11, 0xff, 0x44, 0xcc, 0x33, 0x02, 0x33, 0x00, 0x44, 0x33, 0x33, 0x08, 0x55
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
			jc		AddOverflow
			jmp		reset

SUB_OP		sub.b	r7, r8
			cmp		#0xFF, r8
			jeq		SubOverflow
			jmp		reset


MUL_OP		mov.w	r7, r13
			mov.w	#0x00, r9
			rra.b	r13
			jc		MulAdd
MUL_LOOP	cmp.b	#0x01, r7
			jeq		reset
			rla.b	r8
			jc		AddOverflow
			rra.b	r7
			jnc		MUL_LOOP
MulAdd		rla.b	r8
			add.b	r9, r8
			jc		AddOverflow
			jmp		MUL_LOOP


CLR_OP		mov.b	#0x00, 0(r10)
			inc.w	r10
			mov.b	r7, r8
			mov.b	@r5+, r6				;stores operator
			mov.b	@r5+, r7
			jmp		ClrJMP

reset		mov.b	r8, 0(r10)
			inc.w	r10
			jmp		getFunc


AddOverflow	mov.b	#0xFF, r8
			jmp		reset

SubOverflow	mov.b	#0x00, r8
			jmp		reset

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
