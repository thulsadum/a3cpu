#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf




;; 6 BEGIN DUP 1+ DUP 5 > UNTIL
.test_begin_until_0: ;; ( -- 6 7 )
    #res 1

    cmpi 7
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+2)
    bne .fail

    dec
    lia
    cmpi 6
    bne .fail

    ret .test_begin_until_0

;; 3 BEGIN DUP 1+ DUP 5 > UNTIL
.test_begin_until_1: ;; ( -- 3 4 5 6 )
    #res 1

    cmpi 6
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+4)
    bne .fail

    lda DSP
    subi 1
    lia
    cmpi 5
    bne .fail

    lda DSP
    subi 2
    lia
    cmpi 4
    bne .fail

    lda DSP
    subi 3
    lia
    cmpi 3
    bne .fail

    ret .test_begin_until_1


;; 0 BEGIN DUP 1+ DUP 5 > UNTIL
.test_begin_until_2: ;; ( -- 0 1 2 3 4 5 6 )
    #res 1

    cmpi 6
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+7)
    bne .fail

    ret .test_begin_until_2





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
    #d16 test_begin_until_0
    #d16 test_begin_until_1
    #d16 test_begin_until_2
.dict_tc_end:

#include "program.asm"
