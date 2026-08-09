#include "forth_def.asm"
#include "../lib/zp.asm"

#ruledef forth {
    push({value}) => asm {
        sta TMP
        ldi {value}
        sta arg0
        lda TMP
        jal xt_push
    }
}


#bank zp
; global var
#addr 0x10
DSP: #d16 DSP_ADDR
RSP: #d16 RSP_ADDR
arg0:   #res 1
TMP:    #res 1
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


xt_push: ; ( -- arg0 ), no_tmp, atomic
    #res 1
    stia DSP ; TOP is always ACC
    lda DSP  ; update DSP
    inc
    sta DSP
    lda arg0
    ret xt_push



xt_drop: ; ( x -- ), no_tmp, atomic
    #res 1
    lda DSP
    dec
    sta DSP
    lia
    ret xt_drop





#bank forth_text
__forth_start:
