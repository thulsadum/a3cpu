#once
#include "../asmdef/ac3puasm_def_no_bank.asm"

#bankdef zp {
    bits = 16
    outp = 0
    addr = 0x00
    addr_end = 0x100
}


ISR_RET_VEC = 0x02

#addr 0x00
jmp __start ; jump to program entry point after boot

#addr ISR_RET_VEC
#res 1      ; return vector for isr
jmp __isr   ; jump to isr
