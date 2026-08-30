#include "../../../forth/forth.asm"

#bank forth_text

jmp setup_test

DICT:

pad:
    .fetch: #d16 0xf00b
    .store: #d16 0

test_fetch:
    #res 1

    push(pad.fetch)
    jal xt_fetch

    jal __assert.test_fetch
    ret test_fetch



test_store:
    #res 1

    push(0xcafe)
    push(pad.store)
    jal xt_store

    jal __assert.test_store

    ret test_store



test_store_invariant:
    #res 1

    push(42)
    push(21)
    push(pad.store)
    jal xt_store

    jal __assert.test_store_invariant

    ret test_store_invariant




__assert:

.fail:
    ldi setup_test.next
    dec
    shli 4
    ori 0xf
    taf



.test_fetch:
    #res 1

    cmpi 0xf00b
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    ret .test_fetch



.test_store:
    #res 1

    lda DSP
    cmpi 0x20
    bne .fail

    lda pad.store
    cmpi 0xcafe
    bne .fail

    ret .test_store



;; 42 21 pad.store ! ( 42 21 pad.store_addr -- 42 )
.test_store_invariant:
    #res 1

    cmpi 42
    bne .fail

    lda DSP
    cmpi 0x21
    bne .fail

    lda pad.store
    cmpi 21
    bne .fail

    ret .test_store_invariant





setup_test:
    ldi DSP_ADDR
    sta DSP
    ldi RSP_ADDR
    sta RSP
    lda .next
    inc
    sta .next
    dec
    addi .dict
    lia
    jla
    lda .next
    cmp .max
    bne setup_test
    halt
.next:  #d16 0
.max:   #d16 3
.dict:
    #d16 test_fetch
    #d16 test_store
    #d16 test_store_invariant
