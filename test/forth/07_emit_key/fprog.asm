#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf



.test_emit:
    #res 1

    lda DSP
    cmpi 0x20
    bne .fail

    ret .test_emit



.test_key:
    #res 1

    cmpi "i"
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_key





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
.max:   #d16 (.dict_tc_end - .dict_tc)
.dict_tc:
    #d16 test_emit
    #d16 test_key
.dict_tc_end:

#include "program.asm"
