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
OP_LDI = OC_LDI << OP_OFFSET
OP_STA = OC_STA << OP_OFFSET

#ruledef load_store {
    lda {addr:u16} => OP_LDA`16 @ addr`16
    ldi {imm:u16} => OP_LDI`16 @ imm`16

    sta {addr:u16} => OP_STA`16 @ addr`16
}


OP_ALU_ADDI = OC_ADDI << OP_OFFSET
OP_ALU_ADD  = OC_ADD  << OP_OFFSET
OP_ALU_SUBI = OC_SUBI << OP_OFFSET
OP_ALU_SUB  = OC_SUB  << OP_OFFSET
OP_ALU_SHLI = OC_SHLI << OP_OFFSET
OP_ALU_SHL  = OC_SHL  << OP_OFFSET
OP_ALU_SHRI = OC_SHRI << OP_OFFSET
OP_ALU_SHR  = OC_SHR  << OP_OFFSET

#ruledef alu {
    addi {imm:u16} => OP_ALU_ADDI`16 @ imm`16
    subi {imm:u16} => OP_ALU_SUBI`16 @ imm`16
    shli {imm:u16} => OP_ALU_SHLI`16 @ imm`16
    shri {imm:u16} => OP_ALU_SHRI`16 @ imm`16

    add {addr:u16} => OP_ALU_ADD`16  @ addr`16
    sub {addr:u16} => OP_ALU_SUB`16  @ addr`16
    shl {addr:u16} => OP_ALU_SHL`16  @ addr`16
    shr {addr:u16} => OP_ALU_SHR`16  @ addr`16
}
