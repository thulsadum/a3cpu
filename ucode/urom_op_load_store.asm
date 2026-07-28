#once
#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

#bank acpu

op_lda:
    uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_ACC_IN | SIG_FLAGS_UPDATE | SIG_UPC_RESET

op_ldaz:
    uc SIG_IR_IMM8_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_ACC_IN | SIG_FLAGS_UPDATE | SIG_UPC_RESET

op_ldi:
    uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_ACC_IN | SIG_FLAGS_UPDATE | SIG_UPC_RESET

op_ldi8:
    uc SIG_IR_IMM8_OUT | SIG_ACC_IN | SIG_FLAGS_UPDATE | SIG_UPC_RESET


op_sta:
    uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_MDR_IN | SIG_ACC_OUT
    uc SIG_RAM_WRITE | SIG_UPC_RESET

op_staz:
    uc SIG_IR_IMM8_OUT | SIG_MAR_IN
    uc SIG_MDR_IN | SIG_ACC_OUT
    uc SIG_RAM_WRITE | SIG_UPC_RESET


; set addresses of uprogs for opcodes into mapping rom

#bank mrom

#addr OC_LDA
#d16 op_lda

#addr OC_LDAZ
#d16 op_ldaz

#addr OC_LDI
#d16 op_ldi

#addr OC_LDI8
#d16 op_ldi8

#addr OC_STA
#d16 op_sta

#addr OC_STAZ
#d16 op_staz

