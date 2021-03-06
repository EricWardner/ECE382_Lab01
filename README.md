ECE382_Lab01
============

MSP430 Calculator

#####Purpose
Create a calculator program in assembly that reads a string of specific bytes as a math function and solves it
The following bytes represent operations
0x11 - add
0x22 - subtract
0x33 - multiply
0x44 - clear
0x55 - end

##Pre-Lab
The program will take a mathmatical operation as an input in the form of an array of bytes.
The array will need a pointer which will be a register
the array pointer will need to change after each operation is done and increment by enough to point at the next operation
there will need to be temp variables to store operands. A register will do this.

#####Psuedo Code
```java
final ADD_OP = 0x11;
final SUB_OP = 0x22;
final MUL_OP = 0x33;
final CLR_OP = 0x44;
final END_OP = 0x55;

input[arrayPtr] = a bunch of operations;

result[] = 0x230-0x240;

main(){
operand = input[arrayPtr];
operation = input[arrayPtr+1];
2ndOperand = input[arrayPtr+2];
  if(operation == 0x11){
    add();
  }else if(operation == 0x22){
    sub();
  }else if(operation == 0x33){
    mul();
  }else if(operation == 0x44){
    clr();
  }else if(operation == 0x55){
    end();
  }
}
add(){
  result[] = operand + 2ndOperand;
  arrayPtr = arrayPtr+3;
  jmp main;
}
sub(){
  result[] = operand - 2ndOperand;
  arrayPtr = arrayPtr+3;
  jmp main;
}
mul(){
  result[] = operand * 2ndOperand;
  arrayPtr = arrayPtr+3;
  jmp main;
}
clr(){
    result[] = 0x00;
    jmp main;
}
```
##Lab Process
The lab design process was broken into 2 main parts, the switch "if else" statements and the actual mathmatical operation functions. First the switches were made.
######Case Switch
```asm
  	cmp.b	#0x11, r6
	jeq	ADD_OP
	cmp.b	#0x22, r6
	jeq	SUB_OP
	cmp.b	#0x33, r6
	jeq	MUL_OP
	cmp.b	#0x44, r6
	jeq	CLR_OP
	cmp.b	#0x55, r6
	jeq	END_OP
	jmp	END_OP
```

Next the operations were dealt with
######Add
The add operation was simple, add the two registers and return, oveflow was also considered
```asm
add.b	r7, r8
jc	AddOverflow
jmp	reset
```
######Subtract
The subtration operation was similar to the addition, overflow had to be handled differently
```asm
sub.b	r7, r8
cmp	#0xFF, r8
jeq	SubOverflow
jmp	reset
```
######Multiply
Multiplying in assembly was accomplished used a methid know as peseant multiplication where one
```asm
MUL_OP		
		mov.w	r7, r13
		mov.w	#0x00, r9
		rra.b	r13
		jc	MulAdd
MUL_LOOP	
		cmp.b	#0x01, r7
		jeq	reset
		rla.b	r8
		jc	AddOverflow
		rra.b	r7
		jnc	MUL_LOOP
MulAdd		
		rla.b	r8
		add.b	r9, r8
		jc	AddOverflow
		jmp	MUL_LOOP
```

difficulties with the multiplication method occured becasue I initilly didn't have the subtraction overflow properly handled. 
######B Functionality
To check for overflows the jc instruction was used. If there was a carry, an overflow occured

#####Difficulties/Debugging
The hardest part of the program was getting the pointer to always line up with the right place in the "input array" 
the "pointer" in the program was a register that incremented after each reference.
