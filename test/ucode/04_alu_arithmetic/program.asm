#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

; test lda

ldi 3
addi.16 5

ldi 3
add answer

lda answer
addi.16 3

lda answer
add answer


ldi 5
subi.16 3

ldi 0x44
sub answer

ldi 1
shli.16 3

ldi 1
shl two

ldi 16
shri.16 3

ldi 16
shr two


halt

answer:
    #d16 0x0042
two:
    #d16 0x0002
