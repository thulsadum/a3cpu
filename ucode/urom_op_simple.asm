; Just the Fetch-Phase

#once

#include "urom_def.asm"
#include "urom_fetch.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

#bank acpu

op_nop:
    uc SIG_UPC_RESET

op_halt:
    uc set_flag(SIG_FLAG_SEL_HALT,1)



; set addresses of uprogs for opcodes into mapping rom

#bank mrom

#addr OC_NOP
#d16 op_nop

#addr OC_HALT
#d16 op_halt

