#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf




.test_variable_0:  ;;  VARIABLE foo 1000 foo !      \ ( -- )
    #res 1

    lda DSP
    cmpi (DSP_ADDR)
    bne .fail

    lda DBP
    beq .fail ;; DBP should not be zero.
    lia
    cmpi 1000
    bne .fail

    ret .test_variable_0



.test_variable_1:  ;;  foo @        \ ( -- 1000 )
    #res 1

    cmpi 1000
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+1)
    bne .fail

    lda DBP
    lia
    cmpi 1000
    bne .fail

    ret .test_variable_1


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
    #d16 test_variable_store
    #d16 test_variable_fetch
.dict_tc_end:

#include "program.asm"
