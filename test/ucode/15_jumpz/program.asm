#include "../../../asmdef/ac3puasm_def.asm"


jmp far_away

end:    halt

sub_routine: #res 1 ; reserve a word for return address
    xori 0xf0f0
    ret sub_routine


#addr 0x200
far_away:
    ldi 0xf0
    shli 8
    ori 0xf0
    jal sub_routine
    jmp end
