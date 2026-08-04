#include "../../../asmdef/ac3puasm_def.asm"

MMIO_BEGIN = 0x8000

SIMIF_MAGIC = "S"
SIMIF_STATUS = MMIO_BEGIN + 0
SIMIF_EXIT   = MMIO_BEGIN + 1
SIMIF_PUTC   = MMIO_BEGIN + 2

jmp main

msg:    #d utf16be("Hello, World!") @ 0x0000

print_msg:
    #res 1 ; return

.loop:
    ldi msg         ; ptr
    add ._counter   ; + offset
    lia             ; deref
    beq .end        ; zero check

    sta SIMIF_PUTC  ; putc

    lda ._counter   ; counter increment
    inc
    sta ._counter
    bra .loop       ; loop

.end:
    ret print_msg
._counter: #d16 0

main:
    lda MMIO_BEGIN
    shri 8
    xori SIMIF_MAGIC  ; detect simif
    bne panic

    jal print_msg

success:
    ldi 0
    sta SIMIF_EXIT
    halt

panic:
    ldi 0xff
    taf
