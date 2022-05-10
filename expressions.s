  .syntax unified
  .cpu cortex-m4
  .fpu softvfp
  .thumb
  .global  Main

Main:

  @
  @ write your program here
  @

  @
  @ You can use either
  @
  @   The System stack (R13/SP) with PUSH and POP operations
  @
  @   or
  @
  @   A user stack (R12 has been initialised for this purpose)
  @

  MOV  R4, #0               @ count = 0
  LDR  R5, =10              @ constant = 10
while:
  LDRB R2, [R1]             @ ch = byte[address]
  CMP  R2, #0               @ while (ch != 0)
  BEQ  end                  @ {
  CMP  R2, #0x20            @  if(ch != ' '
  BEQ  next                 @         &&
  CMP  R2, #0x2a            @     ch != '*'
  BEQ  multiple             @         &&
  CMP  R2, #0x2b            @     ch != '+'
  BEQ  plus                 @         &&
  CMP  R2, #0x2d            @     ch != '-')
  BEQ  minus                @  {
  ADD  R4, R4, #1           @   count++
  SUB  R2, R2, #48          @   ch = ch - 48
  STRB R2, [R12, #-1]!      @   push byte from ch
  MOV  R3, R2               @   temp = ch
  ADD  R1, R1, #1           @   address = address + 1
  CMP  R4, #1               @   if(count > 1)
  BLS  while                @   {
  LDRB R2, [R12], #1        @    pop byte into ch
  MOV  R3, R2               @    temp = ch
  LDRB R2, [R12]            @    ch = byte[address]
  MUL  R2, R2, R5           @    ch = ch * constant
  ADD  R3, R2, R3           @    temp = temp + ch
  STRB R3, [R12]            @    byte[address] = temp    
  B    while                @   }

next:                       @  else if (ch = ' ') {
  ADD  R1, R1, #1           @   address = address + 1;
  MOV  R4, #0               @   count = 0
  B    while                @  }

multiple:                   @  else if (ch = '*') {
  LDRB R2, [R12], #1        @   pop byte into ch
  MOV  R3, R2               @   temp = ch
  LDRB R2, [R12]            @   ch = byte[address]
  MUL  R3, R2, R3           @   temp = ch * temp
  STRB R3, [R12]            @   byte[address] = temp
  ADD  R1, R1, #1           @   address = address + 1
  B    while                @  }

plus:                       @  else if (ch = '+') {
  LDRB R2, [R12], #1        @   pop byte into ch
  MOV  R3, R2               @   temp = ch
  LDRB R2, [R12]            @   ch = byte[address]
  ADD  R3, R2, R3           @   temp = ch + temp
  STRB R3, [R12]            @   byte[address] = temp
  ADD  R1, R1, #1           @   address = address + 1
  B    while                @  }

minus:                      @  else if (ch = '-') {
  LDRB R2, [R12], #1        @   pop byte into ch
  MOV  R3, R2               @   temp = ch
  LDRB R2, [R12]            @   ch = byte[address]
  SUB  R3, R2, R3           @   temp = ch - temp
  STRB R3, [R12]            @   byte[address] = temp
  ADD  R1, R1, #1           @   address = address + 1
  B    while                @  }
                            @ }

end:
  MOV  R0, R3               @ result = temp
  



  @ End of program ... check your result

End_Main:
  BX    lr

