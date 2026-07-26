#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

ldi 0x8000
addi 5
;; should give: 0x8005

sec
adci 3
;; should give: 0x8009

shri 4
;; should give: 0x0800

shli 4
;; should give: 0x8000

subi 1
;; should give: 0x7fff

clc
sbbi 1
;; should give: 0x7ffd

halt
