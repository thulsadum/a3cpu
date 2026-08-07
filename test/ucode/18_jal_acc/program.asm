#include "../../../asmdef/ac3puasm_def.asm"


jmp main

x: #d16 0
sr_ptr: #d16 sr_foo

sr_foo:
    #res 1
    ldi 0x0f
    ret sr_foo

sr_bar:
    #res 1
    ldi 0xf0
    ret sr_bar


main:
    lda sr_ptr
    jla
    sta x
    ldi sr_bar
    sta sr_ptr
    lda sr_ptr
    jla
    xor x
    cmpi 0xff
    bne .failure

.success:
    ldi 0x00
    bra .end

.failure:
    ldi 0xff

.end:
    halt
