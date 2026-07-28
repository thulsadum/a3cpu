#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

jmp far_away

end:    halt



#addr 0x200
far_away:
    ldi 0xf0
    shli 8
    ori 0xf0
    jmp end
