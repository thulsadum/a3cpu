#once

#include "urom_def.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

;;;
;;; beq / bne - branch if equal, and branch if not equal (aka bz, bnz)
;;;

#bank acpu

op_beq:
    uc SIG_EXEC_SEL_ZERO | SIG_PC_ADD_OFFSET | SIG_UPC_RESET
    uc SIG_UPC_RESET

op_bne:
    uc SIG_EXEC_SEL_ZERO | SIG_EXEC_INV | SIG_PC_ADD_OFFSET | SIG_UPC_RESET
    uc SIG_UPC_RESET

#bank mrom
#addr OC_BEQ
#d16 op_beq
#addr OC_BNE
#d16 op_bne
