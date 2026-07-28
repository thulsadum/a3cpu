#once
#include "urom_def.asm"
#include "../asmdef/ac3puasm_opcodes.asm"


;;;
;;; jmp
;;;

#bank acpu
op_jmp:
    uc SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_PC_IN | SIG_UPC_RESET

op_jmpz:
    uc SIG_IR_IMM8_OUT | SIG_PC_IN | SIG_UPC_RESET

#bank mrom
#addr OC_JMP
#d16 op_jmp
#addr OC_JMPZ
#d16 op_jmpz
