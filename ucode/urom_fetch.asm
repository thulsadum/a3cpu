; Just the Fetch-Phase

#once

#include "urom_def.asm"

#bank acpu

#addr 0x00
FETCH:
    uc SIG_PC_OUT | SIG_MAR_IN ; MAR <- PC
    uc SIG_RAM_READ ; MBR <- ram
    uc SIG_MDR_OUT | SIG_IR_IN | SIG_PC_INC | SIG_UPC_FROM_mROM ; IR <- MDR, PC <- PC + 1, decode

#addr 0x10
IRQ_HANDLE:
    uc SIG_CONST_ADDR_VEC_OUT | SIG_MAR_IN ; MAR <- 0x0002 address of isr return vector
    uc SIG_PC_OUT | SIG_MDR_IN ; save pc
    uc SIG_RAM_WRITE | SIG_PC_IN | SIG_CONST_ADDR_ISR_OUT
    uc set_flag(SIG_FLAG_SEL_IE,0)
    uc SIG_UPC_RESET
