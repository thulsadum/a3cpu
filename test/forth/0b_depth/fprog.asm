#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf




.test_depth_0:  ;;  DEPTH ( -- 0 )
    #res 1

    bne .fail

    lda DSP
    cmpi (DSP_ADDR + 1)
    bne .fail

    ret .test_depth_0

.test_depth_1:  ;;  DEPTH ( 1 2 -- 1 2 2 )
    #res 1

    cmpi 2
    bne .fail

    lda DSP
    cmpi (DSP_ADDR + 3)
    bne .fail

    ret .test_depth_1

.test_depth_2:  ;;  DEPTH ( 0 -- 0 1 )
    #res 1

    cmpi 1
    bne .fail

    lda DSP
    cmpi (DSP_ADDR + 2)
    bne .fail

    ret .test_depth_2





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
    #d16 test_depth_0
    #d16 test_depth_1
    #d16 test_depth_2
.dict_tc_end:

#include "program.asm"
