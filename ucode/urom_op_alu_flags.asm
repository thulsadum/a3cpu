#once
#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "urom_op_alu.asm"
#include "../asmdef/ac3puasm_opcodes.asm"


;;;
;;; sec / clc --- carry flag manipulation
;;;

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



;;;
;;; sez / clz --- zero flag manipulation
;;;

#bank acpu
op_sez:
    uc set_flag(SIG_FLAG_SEL_ZERO,1) | SIG_UPC_RESET
op_clz:
    uc set_flag(SIG_FLAG_SEL_ZERO,0) | SIG_UPC_RESET

#bank mrom
#addr OC_FLAG_ZERO_1
#d16 op_sez
#addr OC_FLAG_ZERO_0
#d16 op_clz
