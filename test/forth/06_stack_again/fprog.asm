#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf



.test_drop:
    #res 1

    cmpi 1
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_drop



.test_dup:
    #res 1

    cmpi 2
    bne .fail

    lda DSP
    cmpi 0x23
    bne .fail

    dec
    lia
    cmpi 2
    bne .fail

    lda DSP
    subi 2
    lia
    cmpi 1
    bne .fail

    ret .test_dup




.test_swap:
    #res 1

    cmpi 1
    bne .fail

    lda DSP
    cmpi 0x22
    bne .fail

    dec
    lia
    cmpi 2
    bne .fail

    ret .test_swap




.test_over:
    #res 1

    cmpi 1
    bne .fail

    lda DSP
    cmpi 0x23
    bne .fail

    dec
    lia
    cmpi 2
    bne .fail

    lda DSP
    subi 2
    lia
    cmpi 1
    bne .fail

    ret .test_over





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
    #d16 test_drop
    #d16 test_dup
    #d16 test_swap
    #d16 test_over
.dict_tc_end:

#include "program.asm"
