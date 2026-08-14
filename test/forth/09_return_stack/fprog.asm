#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf



.test_movR_0:  ;;  123 >R  \ ( 123 -- ) R( -- 123 )
    #res 1

    lda DSP
    cmpi DSP_ADDR
    bne .fail

    lda RSP
    cmpi (RSP_ADDR - 1)
    bne .fail

    inc
    lia
    cmpi 123
    bne .fail

    ret .test_movR_0



.test_pullR_0:  ;; 123 >R R>  \ ( 123 -- ) R( -- )
    #res 1

    cmpi 123
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+1)
    bne .fail

    lda RSP
    cmpi (RSP_ADDR)
    bne .fail

    ret .test_pullR_0


.test_copyR_0:  ;; 123 >R R@    \ ( 123 -- 123 ) R( -- 123 )
    #res 1

    cmpi 123
    bne .fail

    lda DSP
    cmpi (DSP_ADDR+1)
    bne .fail

    lda RSP
    cmpi (RSP_ADDR-1)
    bne .fail

    inc
    lia
    cmpi 123
    bne .fail

    ret .test_copyR_0


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
    #d16 test_movR
    #d16 test_pullR
    #d16 test_copyR
.dict_tc_end:

#include "program.asm"
