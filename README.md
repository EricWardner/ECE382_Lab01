ECE382_Lab01
============

MSP430 Calculator

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

