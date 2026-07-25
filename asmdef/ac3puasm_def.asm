#include "ac3puasm_opcodes.asm"

#bankdef ac3pu_program {
    bits = 16
    outp = 0
}

OP_OFFSET = 8
OP_HALT = OC_HALT << OP_OFFSET
OP_NOP = OC_NOP << OP_OFFSET

#ruledef misc {
    halt => OP_HALT`16
    nop => OP_NOP`16
}

OP_LDA = OC_LDA << OP_OFFSET
OP_STA = OC_STA << OP_OFFSET

#ruledef load_store {
    lda {addr:u16} => OP_LDA`16 @ addr`16

    sta {addr:u16} => OP_STA`16 @ addr`16
}
