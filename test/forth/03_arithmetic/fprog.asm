#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test

DICT:

test_add:
    #res 1

    push(42)
    push(17)
    jal xt_add

    jal __assert.test_add
    ret test_add



test_sub:
    #res 1

    push(42)
    push(17)
    jal xt_sub

    jal __assert.test_sub

    ret test_sub



test_and:
    #res 1

    push(42)
    push(17)
    jal xt_and

    jal __assert.test_and

    ret test_and



test_or:
    #res 1

    push(42)
    push(17)
    jal xt_or

    jal __assert.test_or

    ret test_or




__assert:

.fail:
    ldi setup_test.next
    dec
    shli 4
    ori 0xf
    taf



.test_add:
    #res 1

    cmpi 59
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_add



.test_sub:
    #res 1

    cmpi (42-17)
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_sub




.test_and:
    #res 1

    cmpi (42 & 17)
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_and




.test_or:
    #res 1

    cmpi (42 | 17)
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_or





setup_test:
    ldi DSP_ADDR
    sta DSP
    ldi RSP_ADDR
    sta RSP
    lda .next
    inc
    sta .next
    dec
    addi .dict
    lia
    jla
    lda .next
    cmp .max
    bne setup_test
    halt
.next:  #d16 0
.max:   #d16 4
.dict:
    #d16 test_add
    #d16 test_sub
    #d16 test_and
    #d16 test_or
