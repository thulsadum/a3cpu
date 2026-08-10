#include "forth_def.asm"
#include "../lib/zp.asm"

#ruledef forth {
    push({value}) => asm {
        stia DSP
        lda DSP
        inc
        sta DSP
        ldi {value}
    }
}


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




xt_drop: ; ( x -- ), no_tmp, atomic
    #res 1

    lda DSP
    dec
    sta DSP
    lia

    ret xt_drop



xt_dup: ; ( x -- xx ), no_tmp, atomic
    #res 1

    stia DSP
    lda DSP
    inc
    sta DSP
    dec
    lia

    ret xt_dup



xt_swap: ; ( a b -- b a ), no_tmp, atomic
    #res 1

    sta TMP
    lda DSP
    dec
    sta TMP2
    lia
    stia DSP
    lda TMP
    stia TMP2
    ldia DSP

    ret xt_swap




xt_over: ; ( a b -- a b a ), no_tmp, atomic
    #res 1

    stia DSP
    lda DSP
    inc
    sta DSP
    subi 2
    lia

    ret xt_over


xt_add: ; ( a b -- a+b )
    #res 1

    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    add TMP
    stia DSP

    ret xt_add



xt_sub: ; ( a b -- a-b )
    #res 1

    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    sub TMP
    stia DSP

    ret xt_sub





xt_shl: ; ( a b -- a<<b )
    #res 1

    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    shl TMP
    stia DSP

    ret xt_shl





xt_and: ; ( a b -- a&b )
    #res 1

    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    and TMP
    stia DSP

    ret xt_and





xt_or: ; ( a b -- a|b )
    #res 1

    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    or TMP
    stia DSP

    ret xt_or



xt_fetch:   ;; ( addr -- x )
    #res 1

    lia

    ret xt_fetch



xt_store:   ;; ( x addr -- )
    #res 1

    sta TMP ; addr -> TMP
    lda DSP ; DSP -= 2
    subi 2
    sta DSP
    inc     ; fetch NOS
    lia
    stia TMP

    ret xt_store

#bank forth_text
__forth_start:
