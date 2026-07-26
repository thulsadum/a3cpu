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

#ruledef alu_arithmetic {
    addi {imm:u16} => OP_ALU_ADDI`16 @ imm`16
    subi {imm:u16} => OP_ALU_SUBI`16 @ imm`16
    shli {imm:u16} => OP_ALU_SHLI`16 @ imm`16
    shri {imm:u16} => OP_ALU_SHRI`16 @ imm`16

    add {addr:u16} => OP_ALU_ADD`16  @ addr`16
    sub {addr:u16} => OP_ALU_SUB`16  @ addr`16
    shl {addr:u16} => OP_ALU_SHL`16  @ addr`16
    shr {addr:u16} => OP_ALU_SHR`16  @ addr`16
}

OP_ALU_ADCI = OC_ADCI << OP_OFFSET
OP_ALU_SBBI = OC_SBBI << OP_OFFSET
OP_ALU_ADC  = OC_ADC  << OP_OFFSET
OP_ALU_SBB  = OC_SBB  << OP_OFFSET

#ruledef alu_arithmetic_with_carry {
    adci {imm:u16} => OP_ALU_ADCI`16 @ imm`16
    sbbi {imm:u16} => OP_ALU_SBBI`16 @ imm`16

    adc {addr:u16} => OP_ALU_ADC`16  @ addr`16
    sbb {addr:u16} => OP_ALU_SBB`16  @ addr`16
}

OP_ALU_ANDI = OC_ANDI << OP_OFFSET
OP_ALU_AND  = OC_AND  << OP_OFFSET
OP_ALU_ORI = OC_ORI << OP_OFFSET
OP_ALU_OR  = OC_OR  << OP_OFFSET
OP_ALU_XORI = OC_XORI << OP_OFFSET
OP_ALU_XOR  = OC_XOR  << OP_OFFSET

#ruledef alu_logic {
    andi {imm:u16} => OP_ALU_ANDI`16 @ imm`16
    ori {imm:u16} => OP_ALU_ORI`16 @ imm`16
    xori {imm:u16} => OP_ALU_XORI`16 @ imm`16

    and {addr:u16} => OP_ALU_AND`16  @ addr`16
    or {addr:u16} => OP_ALU_OR`16  @ addr`16
    xor {addr:u16} => OP_ALU_XOR`16  @ addr`16
}

OP_FLAG_CARRY_0 = OC_FLAG_CARRY_0 << OP_OFFSET
OP_FLAG_CARRY_1 = OC_FLAG_CARRY_1 << OP_OFFSET
OP_FLAG_ZERO_0 = OC_FLAG_ZERO_0 << OP_OFFSET
OP_FLAG_ZERO_1 = OC_FLAG_ZERO_1 << OP_OFFSET

#ruledef flags {
    clc => OP_FLAG_CARRY_0`16
    sec => OP_FLAG_CARRY_1`16

    clz => OP_FLAG_ZERO_0`16
    sez => OP_FLAG_ZERO_1`16
}
