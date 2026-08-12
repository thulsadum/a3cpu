#include "../../../asmdef/ac3puasm_def.asm"


_aliases:
    jmp aliases.test

    eq_zs:
    .a:    beq aliases
    .b:    bzs aliases
    ne_zc:
    .a:    bne aliases
    .b:    bzc aliases
    hs_cs:
    .a:    bhs aliases
    .b:    bcs aliases
    lo_cc:
    .a:    blo aliases
    .b:    bcc aliases

aliases:

    .test:

        lda eq_zs.a
        xor eq_zs.b
        andi 0xff00
        bne .failure

        lda ne_zc.a
        xor ne_zc.b
        andi 0xff00
        bne .failure

        lda hs_cs.a
        xor hs_cs.b
        andi 0xff00
        bne .failure

        lda lo_cc.a
        xor lo_cc.b
        andi 0xff00
        bne .failure
        bra .success

    .failure:
        ldi 0xff
        jmp .end

    .success:
        ldi 0x00

    .end:


halt
