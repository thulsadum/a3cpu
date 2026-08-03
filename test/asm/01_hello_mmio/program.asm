#include "../../../asmdef/ac3puasm_def.asm"

MMIO_BEGIN = 0x8000

jmp main

main:
    lda MMIO_BEGIN
    shri 8
    xori "S"
    bne panic
    ldi 0
    sta MMIO_BEGIN+1
    halt

panic:
    ldi 0xff
    taf
