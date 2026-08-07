#include "../../../asmdef/ac3puasm_def.asm"


jal.zp sub_routine
xori 0x0f0f
halt

sub_routine: #res 1 ; reserve a word for return address
    xori 0xf0f0
    ret sub_routine
