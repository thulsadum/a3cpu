#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

;;;
;;; sec / clc --- carry flag manipulation
#bank acpu
op_sec:
    uc SIG_FLAG_CHANGE | SIG_FLAG_CARRY_1 | SIG_UPC_RESET

#bank mrom
#addr OC_FLAG_CARRY_1
#d16 op_sec
