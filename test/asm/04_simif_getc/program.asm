#include "../../../asmdef/ac3puasm_def.asm"

MMIO_BEGIN = 0x8000

SIMIF_MAGIC = "S"
SIMIF_STATUS = MMIO_BEGIN + 0
SIMIF_EXIT   = MMIO_BEGIN + 1
SIMIF_PUTC   = MMIO_BEGIN + 2
SIMIF_GETC   = MMIO_BEGIN + 3

jmp main

echoc:
    #res 1
    lda SIMIF_GETC
    sta SIMIF_PUTC
    ret echoc

main:
    lda MMIO_BEGIN
    shri 8
    xori SIMIF_MAGIC  ; detect simif
    bne panic

    jal echoc

success:
    ldi 0
    sta SIMIF_EXIT
    halt

panic:
    ldi 0xff
    taf
