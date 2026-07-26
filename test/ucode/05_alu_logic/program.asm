#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

ldi 0x8001
andi 0x8000

ldi 0x8001
and mask

lda mask
andi 0x1234

lda mask
and mask



ldi 0x8001
ori 0x8000

ldi 0x8001
or mask

lda mask
ori 0x1234

lda mask
or mask

halt

ldi 0x8001
xori 0x8000

ldi 0x8001
xor mask

lda mask
xori 0x1234

lda mask
xor mask

halt

mask:
    #d16 0xff00
