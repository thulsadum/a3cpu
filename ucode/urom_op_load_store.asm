; Just the Fetch-Phase

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

op_ldi:
    uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_ACC_IN | SIG_FLAGS_UPDATE | SIG_UPC_RESET


op_sta:
    uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_MDR_IN | SIG_ACC_OUT
    uc SIG_RAM_WRITE | SIG_UPC_RESET


; set addresses of uprogs for opcodes into mapping rom

#bank mrom

#addr OC_LDA
#d16 op_lda

#addr OC_LDI
#d16 op_ldi

#addr OC_STA
#d16 op_sta

