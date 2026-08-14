#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test



__assert:

.fail:
    ldi setup_test.next
    ldi 0xff
    taf



;; CREATE alias_foo
;; VARIABLE foo
;; alias_foo foo =
.test_create_0:
    #res 1

    cmpi TRUE
    bne .fail

    ret .test_create_0




;;  CREATE before 0 CELLS ALLOT ( -- )
;;  CREATE foo 5 CELLS ALLOT ( -- )
;;  CREATE after 0 CELLS ALLOT ( -- )
;;  after before - (  -- 5 )
.test_create_1:
    #res 1

    cmpi 5
    bne .fail

    ret .test_create_1




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
    #d16 test_create_0
    #d16 test_create_1
.dict_tc_end:

#include "program.asm"
