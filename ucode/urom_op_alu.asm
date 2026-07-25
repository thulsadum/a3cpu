; Just the Fetch-Phase

#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "urom_op_load_store.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

#bank acpu

; Register ACC -> Op A
; Register MDR -> Op B

op_addi:
    uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_ALU_OUT | SIG_ACC_IN | SIG_ALU_OP_ADD

; set addresses of uprogs for opcodes into mapping rom

#bank mrom

#addr OC_ADDI
#d16 op_addi

