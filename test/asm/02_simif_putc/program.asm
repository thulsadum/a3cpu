#include "../../../asmdef/ac3puasm_def.asm"

MMIO_BEGIN = 0x8000

SIMIF_STATUS = MMIO_BEGIN + 0
SIMIF_EXIT   = MMIO_BEGIN + 1
SIMIF_PUTC   = MMIO_BEGIN + 2

jmp main

main:
    lda MMIO_BEGIN
    shri 8
    xori "S"        ; detect simif
    bne panic

    ldi "H"
    sta SIMIF_PUTC

success:
    ldi 0
    sta SIMIF_EXIT
    halt

panic:
    ldi 0xff
    taf
