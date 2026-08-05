#include "../asmdef/ac3puasm_def.asm"

ISR_RET_VEC = 0x02

#addr 0x00
jmp __start ; jump to program entry point after boot

#addr ISR_RET_VEC
#res 1      ; return vector for isr
jmp __isr   ; jump to isr
