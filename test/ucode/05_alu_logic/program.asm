#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

ldi 0x8001
andi 0x8000

ldi 0x8001
and mask

lda.l mask
andi 0x1234

lda.l mask
and mask



ldi 0x8001
ori 0x8000

ldi 0x8001
or mask

lda.l mask
ori 0x1234

lda.l mask
or mask



ldi 0x8001
xori 0x8000

ldi 0x8001
xor mask

lda.l mask
xori 0x1234

lda.l mask
xor mask

halt

mask:
    #d16 0xff00
