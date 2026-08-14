#include "forth_def.asm"
#include "../lib/zp.asm"

#bank zp
; global var
#addr 0x10
DSP:    #d16 DSP_ADDR
RSP:    #d16 RSP_ADDR
TMP:    #res 1
TMP2:   #res 1
INPUT:  #res 1
OUTPUT: #res 1


#bank forth_system

__isr:          ; should not be called
    ldi 0xff
    taf
    reti ISR_RET_VEC



__start:
    jal init_hw
    sei
    jmp __forth_start



init_hw: #res 1 ; return addr
    ldi 0x8000  ; init with mmio begin
    sta ._addr

.loop:
    ldia ._addr ; read mapped status register
    beq .end    ; if 0x0000 end of device chain

    shri 8       ; shift magic id into lower byte
    cmpi 0x26    ; '&' stands for simple I/O devices
    beq .drv_io ; jump to driver

.end_loop:
    ldia ._addr ; read status again
    andi 0xf    ; mask offset_len_exp
    sta ._len_exp
    ldi 1       ; calculate offset
    shl ._len_exp
    add ._addr  ; add offset
    sta ._addr
    jmp .loop
.end:
    ret init_hw

.drv_io:
    lda ._addr
    inc
    sta INPUT
    inc
    sta OUTPUT
    jmp .end_loop

._addr:
    #res 1
._len_exp:
    #res 1


fexit:
    #res 1
    halt

fputc:
    #res 1
    stia OUTPUT
    ret fputc

fgetc:
    #res 1
    ldia INPUT
    ret fgetc



