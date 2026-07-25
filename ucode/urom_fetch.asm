; Just the Fetch-Phase

#once

#include "urom_def.asm"

#bank acpu
FETCH:
    uc SIG_PC_OUT | SIG_MAR_IN ; MAR <- PC
    uc SIG_RAM_READ ; MBR <- ram
    uc SIG_MDR_OUT | SIG_IR_IN | SIG_PC_INC | SIG_UPC_FROM_mROM ; IR <- MDR, PC <- PC + 1, decode
