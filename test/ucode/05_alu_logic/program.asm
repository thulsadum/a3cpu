#include "../../../asmdef/ac3puasm_def.asm"


ldi 0x8001
andi 0x8000

ldi 0x8001
and.l mask

lda.l mask
andi 0x1234

lda.l mask
and.l mask



ldi 0x8001
ori 0x8000

ldi 0x8001
or.l mask

lda.l mask
ori 0x1234

lda.l mask
or.l mask



ldi 0x8001
xori 0x8000

ldi 0x8001
xor.l mask

lda.l mask
xori 0x1234

lda.l mask
xor.l mask

halt

mask:
    #d16 0xff00
