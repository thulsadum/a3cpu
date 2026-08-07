#include "../../../asmdef/ac3puasm_def.asm"


; test lda

ldi.16 3
addi.16 5

ldi.16 3
add.l answer

lda.l answer
addi.16 3

lda.l answer
add.l answer


ldi.16 5
subi.16 3

ldi.16 0x44
sub.l answer

ldi.16 1
shli.16 3

ldi.16 1
shl.l two

ldi.16 16
shri.16 3

ldi.16 16
shr.l two


halt

answer:
    #d16 0x0042
two:
    #d16 0x0002
