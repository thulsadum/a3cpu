; Just the Fetch-Phase

#include "urom_def.asm"

uc SIG_PC_OUT | SIG_MAR_IN ; MAR <- PC
uc SIG_RAM_READ ; MBR <- ram
uc SIG_MDR_OUT | SIG_IR_IN | SIG_PC_INC ; IR <- MDR, PC <- PC + 1
 
