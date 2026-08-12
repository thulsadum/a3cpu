#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf



.test_eq0_0:  ;;  0 0=
    #res 1

    cmpi TRUE
    bne .fail

    ret .test_eq0_0

.test_eq0_1:  ;;  1 0=
    #res 1

    cmpi FALSE
    bne .fail

    ret .test_eq0_1

.test_eq0_2:  ;;  -1 0=
    #res 1

    cmpi FALSE
    bne .fail

    ret .test_eq0_2




.test_eq_0:   ;; 42 42 =
    #res 1

    cmpi TRUE
    bne .fail

    ret .test_eq_0

.test_eq_1:   ;; 0 0 =
    #res 1

    cmpi TRUE
    bne .fail

    ret .test_eq_1

.test_eq_2:   ;; 0 1 =
    #res 1

    cmpi FALSE
    bne .fail

    ret .test_eq_2

.test_eq_3:   ;; -42 42 =
    #res 1

    cmpi FALSE
    bne .fail

    ret .test_eq_3




.test_lt_0:   ;; 0 1 <
    #res 1

    cmpi TRUE
    bne .fail

    ret .test_lt_0

.test_lt_1:   ;; -1 1 <
    #res 1

    cmpi TRUE
    bne .fail

    ret .test_lt_1

.test_lt_2:   ;; 1 1 <
    #res 1

    cmpi FALSE
    bne .fail

    ret .test_lt_2

.test_lt_3:   ;; 1 -1 <
    #res 1

    cmpi FALSE
    bne .fail

    ret .test_lt_3






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
    #d16 test_eq0
    #d16 test_eq
    #d16 test_lt
.dict_tc_end:

#include "program.asm"
