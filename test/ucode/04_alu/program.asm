#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

; test lda

ldi 3
addi 5

ldi 5
subi 3

ldi 1
shli 3

ldi 16
shri 3

halt
