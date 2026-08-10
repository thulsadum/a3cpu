#include "../../../forth/forth.asm"

#bank forth_text

    jal _assert.stack_init

    push("H")
    jal _assert.stack_pushed

    push("i")
    jal _assert.stack_pushed2

    jal xt_drop
    jal _assert.stack_dropped

    jal fexit


_assert:

    .fail:
        ldi 0xff
        taf

    .stack_init:
        #res 1
        lda DSP
        cmpi 0x20
        bne .fail
        lda RSP
        cmpi 0xff
        bne .fail

        ret .stack_init

    .stack_pushed:
        #res 1
        cmpi "H"
        bne .fail
        lda DSP
        cmpi 0x21
        bne .fail
        ldi "H" ; restore after test
        ret .stack_pushed

    .stack_pushed2:
        #res 1
        cmpi "i"
        bne .fail
        lda DSP
        cmpi 0x22
        bne .fail
        dec
        lia
        cmpi "H"
        bne .fail

        ldi 0x22 ; clean up test mess
        sta DSP
        ldi "i"
        ret .stack_pushed2

    .stack_dropped:
        #res 1
        cmpi "H"
        bne .fail
        lda DSP
        cmpi 0x21
        bne .fail
        ret .stack_dropped
