#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf




;; 0 0= IF 42 ELSE 21 THEN
.test_if_else_0: ;; ( -- 42 )
    #res 1
    cmpi 42
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+1)
    bne .fail

    ret .test_if_else_0



;; 7 0= IF 42 ELSE 21 THEN
.test_if_else_1: ;; ( -- 21 )
    #res 1

    cmpi 21
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+1)
    bne .fail

    ret .test_if_else_1


;; 0 0= IF 42 THEN
.test_if_0: ;; ( -- 42 )
    #res 1
    cmpi 42
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+1)
    bne .fail

    ret .test_if_0


;; 1 0= IF 42 THEN
.test_if_1: ;; ( -- )
    #res 1

    lda DSP
    cmpi (DSP_ADDR)
    bne .fail

    ret .test_if_1


;; 0 0= IF 1 ELSE 2 ELSE 3 ELSE 4 ELSE 5 THEN
.test_if_melse_0: ;; ( -- 1 3 5 )
    #res 1

    stia DSP

    lda DSP
    cmpi (DSP_ADDR+3)
    bne .fail

    lda DSP
    subi 0
    lia
    cmpi 5
    bne .fail

    lda DSP
    subi 1
    lia
    cmpi 3
    bne .fail

    lda DSP
    subi 2
    lia
    cmpi 1
    bne .fail

    ret .test_if_melse_0

;; 1 0= IF 1 ELSE 2 ELSE 3 ELSE 4 ELSE 5 THEN
.test_if_melse_1: ;; ( -- 2 4 )
    #res 1

    stia DSP

    lda DSP
    cmpi (DSP_ADDR+2)
    bne .fail

    lda DSP
    subi 0
    lia
    cmpi 4
    bne .fail

    lda DSP
    subi 1
    lia
    cmpi 2
    bne .fail

    ret .test_if_melse_1


;; 0 IF ELSE 0xf3 THEN
.test_if_else_only: ;; ( -- 0xf3 )
    #res 1

    stia DSP

    lda DSP
    cmpi (DSP_ADDR+1)
    bne .fail

    lda DSP
    lia
    cmpi 0xf3
    bne .fail

    ret .test_if_else_only



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
    #d16 test_if_else_0
    #d16 test_if_else_1
    #d16 test_if_0
    #d16 test_if_1
    #d16 test_if_melse_0
    #d16 test_if_melse_1
    #d16 test_if_else_only
.dict_tc_end:

#include "program.asm"
