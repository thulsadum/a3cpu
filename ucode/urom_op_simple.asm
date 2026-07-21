; Just the Fetch-Phase

#include "urom_def.asm"
#include "urom_fetch.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

op_nop:
    uc SIG_UPC_RESET

op_halt:
    uc SIG_CPU_HALT



; set addresses of uprogs for opcodes into mapping rom

#bank mrom

#addr OC_NOP
#d16 op_nop

#addr OC_HALT
#d16 op_halt

