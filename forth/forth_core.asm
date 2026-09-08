#include "forth_def.asm"
#include "../lib/zp.asm"

#ruledef forth {
    push({value}) => asm {
        stia DSP
        lda DSP
        inc
        sta DSP
        ldi {value}
    }

    drop => asm {
        lda DSP
        dec
        sta DSP
        lia
    }

    movR => asm {
        stia RSP
        lda RSP
        dec
        sta RSP

        drop

    }

    pullR => asm {
        stia DSP

        lda DSP
        inc
        sta DSP

        lda RSP
        inc
        sta RSP
        lia
    }

    copyR => asm {
        stia DSP

        lda DSP
        inc
        sta DSP

        lda RSP
        inc
        lia
    }

    dup => asm {
        stia DSP
        lda DSP
        inc
        sta DSP
        dec
        lia
    }

    swap => asm {
        sta TMP
        lda DSP
        dec
        sta TMP2
        lia
        stia DSP
        lda TMP
        stia TMP2
        ldia DSP
    }

    over => asm {
        stia DSP
        lda DSP
        inc
        sta DSP
        subi 2
        lia
    }

    add => asm {
        sta TMP
        lda DSP
        dec
        sta DSP
        lia
        add TMP
        stia DSP
    }

    sub => asm {
        sta TMP
        lda DSP
        dec
        sta DSP
        lia
        sub TMP
        stia DSP
    }

    shl => asm {
        sta TMP
        lda DSP
        dec
        sta DSP
        lia
        shl TMP
        stia DSP
    }

    shr => asm {
        sta TMP
        lda DSP
        dec
        sta DSP
        lia
        shr TMP
        stia DSP
    }

    or => asm {
        sta TMP
        lda DSP
        dec
        sta DSP
        lia
        or TMP
        stia DSP
    }

    and => asm {
        sta TMP
        lda DSP
        dec
        sta DSP
        lia
        and TMP
        stia DSP
    }

    xor => asm {
        sta TMP
        lda DSP
        dec
        sta DSP
        lia
        xor TMP
        stia DSP
    }

    fetch => asm {
        lia
    }

    store => asm {
        sta TMP ; addr -> TMP
        lda DSP ; DSP -= 2
        subi 2
        sta DSP
        inc     ; fetch NOS
        lia
        stia TMP ; store
        ; restore stack invariant (TOS -> ACC)
        ldia DSP
    }

    emit => asm {
        stia OUTPUT
        lda DSP
        dec
        sta DSP
        lia
    }

    key => asm {
        stia DSP
        lda DSP
        inc
        sta DSP
        ldia INPUT
    }

    depth => asm {
        stia DSP
        lda DSP
        inc
        sta DSP
        dec
        subi DSP_ADDR
    }

   invert => asm {
        xori 0xFFFF
   }

}


#bank forth_system

xt_drop: ; ( x -- ), no_tmp, atomic
    #res 1

    drop

    ret xt_drop



xt_dup: ; ( x -- xx ), no_tmp, atomic
    #res 1

    dup

    ret xt_dup



xt_swap: ; ( a b -- b a ), no_tmp, atomic
    #res 1

    swap

    ret xt_swap




xt_over: ; ( a b -- a b a ), no_tmp, atomic
    #res 1

    over

    ret xt_over


xt_add: ; ( a b -- a+b )
    #res 1

    add

    ret xt_add



xt_sub: ; ( a b -- a-b )
    #res 1

    sub

    ret xt_sub





xt_shl: ; ( a b -- a<<b )
    #res 1

    shl

    ret xt_shl





xt_and: ; ( a b -- a&b )
    #res 1

    and

    ret xt_and





xt_or: ; ( a b -- a|b )
    #res 1

    or

    ret xt_or



xt_fetch:   ;; ( addr -- x )
    #res 1

    fetch

    ret xt_fetch



xt_store:   ;; ( x addr -- )
    #res 1

    store

    ret xt_store



xt_emit: ;; ( ch -- )
    #res 1

    emit

    ret xt_emit



xt_key: ;; ( -- ch )
    #res 1

    key

    ret xt_key


xt_eq0: ;; ( x -- flags )
    #res 1
    beq .success
    ldi FALSE
    ret xt_eq0
.success:
    ldi TRUE
    ret xt_eq0



xt_lt0: ;; ( x -- flags )
    #res 1
    tst
    bmi .success
    ldi FALSE
    ret xt_lt0
.success:
    ldi TRUE
    ret xt_lt0



xt_eq: ;; ( x y -- flags )
    #res 1

    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    cmp TMP

    beq .success
    ldi FALSE
    ret xt_eq
.success:
    ldi TRUE
    ret xt_eq


xt_lt: ;; ( x y -- flags )
    #res 1

    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    cmp TMP

    blt .success
    ldi FALSE
    ret xt_lt
.success:
    ldi TRUE
    ret xt_lt


xt_gt: ;; ( x y -- flags )
    #res 1
    sta TMP
    lda DSP
    dec
    sta DSP
    lia
    cmp TMP

    bgt .success
    ldi FALSE
    ret xt_gt
.success:
    ldi TRUE
    ret xt_gt



xt_movR:  ;; ( x -- ), R( -- x )
    #res 1
    movR
    ret xt_movR



xt_pullR:  ;; ( -- x ), R( x -- )
    #res 1
    pullR
    ret xt_pullR

xt_copyR:  ;; ( -- x ), R( x -- x )
    #res 1
    copyR
    ret xt_copyR

xt_depth:  ;; ( -- +n )
    #res 1

    depth

    ret xt_depth

xt_invert:  ;; ( n -- ~n )
    #res 1

    invert

    ret xt_invert
