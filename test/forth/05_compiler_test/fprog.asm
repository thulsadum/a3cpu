#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
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


.test_fetch:
    #res 1

    cmpi 0xf00b
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_fetch



.test_store:
    #res 1

    lda DSP
    cmpi 0x20
    bne .fail

    lda pad.store
    cmpi 0xcafe
    bne .fail

    ret .test_store





setup_test:
    ldi DSP_ADDR
    sta DSP
    ldi RSP_ADDR
    sta RSP

    lda .next
    addi .dict_tc
    lia
    jla

    lda .next
    inc
    sta .next
    cmp .max
    bne setup_test
    halt
.next:  #d16 0
.max:   #d16 6
.dict_tc:
    #d16 test_add
    #d16 test_sub
    #d16 test_and
    #d16 test_or
    #d16 test_fetch
    #d16 test_store
.dict_ta:
    #d16 __assert.test_add
    #d16 __assert.test_sub
    #d16 __assert.test_and
    #d16 __assert.test_or
    #d16 __assert.test_fetch
    #d16 __assert.test_store


#include "program.asm"
