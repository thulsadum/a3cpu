; Just the Fetch-Phase

#include "urom_def.asm"
#include "urom_fetch.asm"

op_noop:
    uc SIG_UPC_RESET

op_halt:
    uc SIG_CPU_HALT
