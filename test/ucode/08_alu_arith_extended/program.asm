#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program


ldi 0
inc ; 0x0001
subi 1 ;dec ; 0x0000
neg ; 0xffff
halt
