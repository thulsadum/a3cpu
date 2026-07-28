#once
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
OP_LDAZ = OC_LDAZ << OP_OFFSET
OP_LDI = OC_LDI << OP_OFFSET
OP_LDI8 = OC_LDI8 << OP_OFFSET
OP_STA = OC_STA << OP_OFFSET
OP_STAZ = OC_STAZ << OP_OFFSET

#ruledef load_store {
    lda {addr:u8} => {
        assert(addr<=0xff)
        asm { lda.zp {addr} }
    }
    lda {addr:u16} => asm { lda.l {addr} }
    lda.l {addr:u16} => OP_LDA`16 @ addr`16
    lda.zp {addr:u8} => (OP_LDAZ | addr)`16

    ldi {imm:u8}  => {
        assert(imm<=0xff)
        asm { ldi.8 {imm}`8 }
    }
    ldi {imm:u16} => asm { ldi.16 {imm} }
    ldi.8  {imm:u8} => (OP_LDI8 | (imm & 0xff))`16
    ldi.16 {imm:u16} => OP_LDI`16 @ imm`16

    sta {addr:u8} => {
        assert(addr<=0xff)
        asm { sta.zp {addr} }
    }
    sta {addr:u16} => asm { sta.l {addr} }
    sta.l {addr:u16} => OP_STA`16 @ addr`16
    sta.zp {addr:u8} => (OP_STAZ | addr)`16
}


OP_ALU_ADDI = OC_ADDI << OP_OFFSET
OP_ALU_ADD  = OC_ADD  << OP_OFFSET
OP_ALU_ADDZ  = OC_ADDZ  << OP_OFFSET
OP_ALU_SUBI = OC_SUBI << OP_OFFSET
OP_ALU_SUB  = OC_SUB  << OP_OFFSET
OP_ALU_SUBZ  = OC_SUBZ  << OP_OFFSET
OP_ALU_SHLI = OC_SHLI << OP_OFFSET
OP_ALU_SHL  = OC_SHL  << OP_OFFSET
OP_ALU_SHLZ  = OC_SHLZ  << OP_OFFSET
OP_ALU_SHRI = OC_SHRI << OP_OFFSET
OP_ALU_SHR  = OC_SHR  << OP_OFFSET
OP_ALU_SHRZ  = OC_SHRZ  << OP_OFFSET

#ruledef alu_arithmetic {
    addi {imm:u8}  => {
        assert(imm<=0xff)
        asm { addi.8  {imm} }
    }
    addi {imm:u16} => asm { addi.16 {imm} }
    subi {imm:u8}  => {
        assert(imm<=0xff)
        asm { subi.8  {imm} }
    }
    subi {imm:u16} => asm { subi.16 {imm} }
    shli {imm:u8}  => {
        assert(imm<=0xff)
        asm { shli.8  {imm} }
    }
    shli {imm:u16} => asm { shli.16 {imm} }
    shri {imm:u8}  => {
        assert(imm<=0xff)
        asm { shri.8  {imm} }
    }
    shri {imm:u16} => asm { shri.16 {imm} }

    add {addr:u8}  => {
        assert(addr<=0xff)
        asm { add.zp {addr} }
    }
    add {addr:u16} => asm { add.l  {addr} }
    sub {addr:u8}  => {
        assert(addr<=0xff)
        asm { sub.zp {addr} }
    }
    sub {addr:u16} => asm { sub.l  {addr} }
    shl {addr:u8}  => {
        assert(addr<=0xff)
        asm { shl.zp {addr} }
    }
    shl {addr:u16} => asm { shl.l  {addr} }
    shr {addr:u8}  => {
        assert(addr<=0xff)
        asm { shr.zp {addr} }
    }
    shr {addr:u16} => asm { shr.l  {addr} }


    add.zp {addr:u8} => (OP_ALU_ADDZ | addr)`16
    sub.zp {addr:u8} => (OP_ALU_SUBZ | addr)`16
    shl.zp {addr:u8} => (OP_ALU_SHLZ | addr)`16
    shr.zp {addr:u8} => (OP_ALU_SHRZ | addr)`16

    add.l {addr:u16} => OP_ALU_ADD`16  @ addr`16
    sub.l {addr:u16} => OP_ALU_SUB`16  @ addr`16
    shl.l {addr:u16} => OP_ALU_SHL`16  @ addr`16
    shr.l {addr:u16} => OP_ALU_SHR`16  @ addr`16
}

OP_ALU_ADCI = OC_ADCI << OP_OFFSET
OP_ALU_SBBI = OC_SBBI << OP_OFFSET
OP_ALU_ADC  = OC_ADC  << OP_OFFSET
OP_ALU_ADCZ  = OC_ADCZ  << OP_OFFSET
OP_ALU_SBB  = OC_SBB  << OP_OFFSET
OP_ALU_SBBZ  = OC_SBBZ  << OP_OFFSET

#ruledef alu_arithmetic_with_carry {
    adci {imm:u8}  => {
        assert(imm<=0xff)
        asm { adci.8  {imm} }
    }
    adci {imm:u16} => asm { adci.16 {imm} }
    sbbi {imm:u8}  => {
        assert(imm<=0xff)
        asm { sbbi.8  {imm} }
    }
    sbbi {imm:u16} => asm { sbbi.16 {imm} }

    adc {addr:u8}  => {
        assert(addr<=0xff)
        asm { adc.zp {addr} }
    }
    adc {addr:u16} => asm { adc.l  {addr} }
    sbb {addr:u8}  => {
        assert(addr<=0xff)
        asm { sbb.zp {addr} }
    }
    sbb {addr:u16} => asm { sbb.l  {addr} }

    adc.zp {addr:u8} => (OP_ALU_ADCZ | addr)`16
    adc.l {addr:u16} => OP_ALU_ADC`16  @ addr`16
    sbb.zp {addr:u8} => (OP_ALU_SBBZ | addr)`16
    sbb.l {addr:u16} => OP_ALU_SBB`16  @ addr`16
}

OP_ALU_ADCI8 = OC_ADCI8 << OP_OFFSET
OP_ALU_ADDI8 = OC_ADDI8 << OP_OFFSET
OP_ALU_SBBI8 = OC_SBBI8 << OP_OFFSET
OP_ALU_SUBI8 = OC_SUBI8 << OP_OFFSET
OP_ALU_SHLI8 = OC_SHLI8 << OP_OFFSET
OP_ALU_SHRI8 = OC_SHRI8 << OP_OFFSET

#ruledef alu_arithmetic_imm8 {
    adci.8  {imm:u8}  => (OP_ALU_ADCI8 | (imm & 0xff))`16
    adci.16 {imm:u16} => OP_ALU_ADCI`16 @ imm`16
    addi.8  {imm:u8}  => (OP_ALU_ADDI8 | (imm & 0xff))`16
    addi.16 {imm:u16} => OP_ALU_ADDI`16 @ imm`16

    sbbi.8  {imm:u8}  => (OP_ALU_SBBI8 | (imm & 0xff))`16
    sbbi.16 {imm:u16} => OP_ALU_SBBI`16 @ imm`16
    subi.8  {imm:u8}  => (OP_ALU_SUBI8 | (imm & 0xff))`16
    subi.16 {imm:u16} => OP_ALU_SUBI`16 @ imm`16

    shli.8  {imm:u8}  => (OP_ALU_SHLI8 | (imm & 0xff))`16
    shli.16 {imm:u16} => OP_ALU_SHLI`16 @ imm`16
    shri.8  {imm:u8}  => (OP_ALU_SHRI8 | (imm & 0xff))`16
    shri.16 {imm:u16} => OP_ALU_SHRI`16 @ imm`16
}



#ruledef alu_arithmetic_derived {
    inc => asm { addi.8 1  }
    dec => asm { subi.8 1 }
    neg => asm { xori 0xffff }
}


OP_ALU_ANDI = OC_ANDI  << OP_OFFSET
OP_ALU_ANDI8 = OC_ANDI8  << OP_OFFSET
OP_ALU_AND  = OC_AND   << OP_OFFSET
OP_ALU_ANDZ  = OC_ANDZ << OP_OFFSET
OP_ALU_ORI = OC_ORI  << OP_OFFSET
OP_ALU_ORI8 = OC_ORI8  << OP_OFFSET
OP_ALU_OR  = OC_OR   << OP_OFFSET
OP_ALU_ORZ  = OC_ORZ << OP_OFFSET
OP_ALU_XORI = OC_XORI  << OP_OFFSET
OP_ALU_XORI8 = OC_XORI8  << OP_OFFSET
OP_ALU_XOR  = OC_XOR   << OP_OFFSET
OP_ALU_XORZ  = OC_XORZ << OP_OFFSET

#ruledef alu_logic {
    andi {imm:u8} =>  {
        assert(imm<=0xff)
        asm { andi.8 {imm} }
    }
    ori {imm:u8} =>  {
        assert(imm<=0xff)
        asm { ori.8 {imm} }
    }
    xori {imm:u8} =>  {
        assert(imm<=0xff)
        asm { xori.8 {imm} }
    }
    andi {imm:u16} => asm { andi.16 {imm} }
    ori {imm:u16} => asm { ori.16 {imm} }
    xori {imm:u16} => asm { xori.16 {imm} }

    andi.8 {imm:u8} => (OP_ALU_ANDI8 | imm)`16
    ori.8 {imm:u8} => (OP_ALU_ORI8 | imm)`16
    xori.8 {imm:u8} => (OP_ALU_XORI8 | imm)`16
    andi.16 {imm:u16} => OP_ALU_ANDI`16 @ imm`16
    ori.16 {imm:u16} => OP_ALU_ORI`16 @ imm`16
    xori.16 {imm:u16} => OP_ALU_XORI`16 @ imm`16

    and {addr:u8}  => {
        assert(addr<=0xff)
        asm { and.zp {addr} }
    }
    and {addr:u16} => asm { and.l  {addr} }
    or {addr:u8}  => {
        assert(addr<=0xff)
        asm { or.zp {addr} }
    }
    or {addr:u16} => asm { or.l  {addr} }
    xor {addr:u8}  => {
        assert(addr<=0xff)
        asm { xor.zp {addr} }
    }
    xor {addr:u16} => asm { xor.l  {addr} }

    and.zp {addr:u8} => (OP_ALU_ANDZ | addr)`16
    and.l {addr:u16} => OP_ALU_AND`16  @ addr`16
    or.zp {addr:u8} => (OP_ALU_ORZ | addr)`16
    or.l {addr:u16} => OP_ALU_OR`16  @ addr`16
    xor.zp {addr:u8} => (OP_ALU_XORZ | addr)`16
    xor.l {addr:u16} => OP_ALU_XOR`16  @ addr`16
}

OP_FLAG_CARRY_0 = OC_FLAG_CARRY_0 << OP_OFFSET
OP_FLAG_CARRY_1 = OC_FLAG_CARRY_1 << OP_OFFSET
OP_FLAG_ZERO_0 = OC_FLAG_ZERO_0 << OP_OFFSET
OP_FLAG_ZERO_1 = OC_FLAG_ZERO_1 << OP_OFFSET
OP_FLAG_INTERRUPT_EN_0 = OC_FLAG_IE_0 << OP_OFFSET
OP_FLAG_INTERRUPT_EN_1 = OC_FLAG_IE_1 << OP_OFFSET

OP_TFA = OC_TFA << OP_OFFSET
OP_TAF = OC_TAF << OP_OFFSET

#ruledef flags {

; flag transfer
    tfa => OP_TFA`16
    taf => OP_TAF`16

    clc => OP_FLAG_CARRY_0`16
    sec => OP_FLAG_CARRY_1`16

    clz => OP_FLAG_ZERO_0`16
    sez => OP_FLAG_ZERO_1`16

    cli => OP_FLAG_INTERRUPT_EN_0`16
    sei => OP_FLAG_INTERRUPT_EN_1`16
}

OP_TST = OC_TST << OP_OFFSET
OP_CMPI8 = OC_CMPI8 << OP_OFFSET
OP_CMPI = OC_CMPI << OP_OFFSET
OP_CMP = OC_CMP << OP_OFFSET
OP_CMPZ = OC_CMPZ << OP_OFFSET

#ruledef comparison {
    tst  => OP_TST`16

    cmpi.8 {imm:u8} => (OP_CMPI8 | imm)`16
    cmpi.16 {imm:u16} => OP_CMPI`16 @ imm`16
    cmpi {imm:u8} => {
        assert(imm<=0xff)
        asm { cmpi.8 {imm} }
    }
    cmpi {imm:u16} => asm { cmpi.16 {imm} }

    cmp {addr:u8} => {
        assert(addr<=0xff)
        asm { cmp.zp {addr} }
    }
    cmp {addr:u16} => asm { cmp.l {addr} }

    cmp.zp {addr:u8} => (OP_CMPZ | addr)`16
    cmp.l {addr:u16} => OP_CMP`16 @ addr`16
}


OP_JMPZ = OC_JMPZ << OP_OFFSET
OP_JMP  = OC_JMP  << OP_OFFSET
OP_JALZ = OC_JALZ << OP_OFFSET
OP_JAL  = OC_JAL  << OP_OFFSET
OP_RETZ = OC_RETZ << OP_OFFSET
OP_RET  = OC_RET  << OP_OFFSET

#ruledef jumps {
    jmp {addr:u8} => {
        assert(addr <= 0xff)
        asm { jmp.zp {addr} }
    }
    jmp {addr:u16} => asm { jmp.l {addr} }

    jmp.zp {addr:u8} => (OP_JMPZ | addr)`16
    jmp.l  {addr:u16} => OP_JMP`16 @ addr`16


    jal {addr:u8} => {
        assert(addr <= 0xff)
        asm { jal.zp {addr} }
    }
    jal {addr:u16} => asm { jal.l {addr} }
    jal.zp {addr:u8} => (OP_JALZ | addr)`16
    jal.l  {addr:u16} => OP_JAL`16 @ addr`16


    ret {addr:u8} => {
        assert(addr <= 0xff)
        asm { ret.zp {addr} }
    }
    ret {addr:u16} => asm { ret.l {addr} }
    ret.zp {addr:u8} => (OP_RETZ | addr)`16
    ret.l  {addr:u16} => OP_RET`16 @ addr`16
}
