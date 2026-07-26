#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

;;;
;;; sec / clc --- carry flag manipulation
#bank acpu
op_sec:
    uc set_flag(SIG_FLAG_SEL_CARRY,1) | SIG_UPC_RESET
op_clc:
    uc set_flag(SIG_FLAG_SEL_CARRY,0) | SIG_UPC_RESET

#bank mrom
#addr OC_FLAG_CARRY_1
#d16 op_sec
#addr OC_FLAG_CARRY_0
#d16 op_clc
