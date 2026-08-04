#include "../../../asmdef/ac3puasm_def.asm"

MMIO_BEGIN = 0x8000

SIMIF_MAGIC = "S"
SIMIF_STATUS = MMIO_BEGIN + 0
SIMIF_EXIT   = MMIO_BEGIN + 1
SIMIF_PUTC   = MMIO_BEGIN + 2
SIMIF_GETC   = MMIO_BEGIN + 3
SIMIF_TIMER  = MMIO_BEGIN + 4

jmp main

#addr 0x02
isr:
    .return: #res 1

    sta .acc
    tfa
    sta .flags

    lda SIMIF_TIMER ; read to clear interrupt

    ldi 1
    sta exit_flag

    lda .flags
    taf
    lnf .acc

    reti isr

    .flags: #res 1
    .acc: #res 1


wait:
    #res 1
    .loop:
        lda exit_flag
        beq .loop
    ret wait

main:
    lda MMIO_BEGIN
    shri 8
    xori SIMIF_MAGIC  ; detect simif
    bne panic

    sei ; enable interrupts
    ldi 0xff
    sta SIMIF_TIMER

    jal wait

success:
    ldi 0
    sta SIMIF_EXIT
    halt

panic:
    ldi 0xff
    taf

exit_flag: #d16 0x0000
