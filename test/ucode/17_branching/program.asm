#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program


count_down:
    ldi 0x08
    .loop:
        sta counter
        lda result
        addi 3
        sta result
        lda counter
        dec
        bne .loop
    ; "assert" (infact preparation of that)
    lda result
    xori 0x18
    ;; acc: 0x0000 flag: zero


string_length:
    ldi 0
    sta counter
    .loop:
        ldi data
        add counter
        lia
        beq .end
        lda counter
        inc
        sta counter
        jmp .loop
    .end:
        lda counter
        xori 3 ;; should success: acc: 0, flags: zero


test_sign_pl:
    ldi 5
    subi 3
    bmi .failure
    bpl .success
        ldi 0xff ; should not run ever
        taf
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:

test_sign_mi:
    ldi 3
    subi 5
    bpl .failure
    bmi .success
        ldi 0xff ; should not run ever
        taf
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:



test_bge_1:
    ldi 8
    cmpi 7
    bls .failure
    beq .failure
    bge .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:

test_bge_2:
    ldi 8
    cmpi 8
    blt .failure
    bge .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:


test_bls_1:
    ldi 7
    cmpi 8
    bge .failure
    beq .failure
    bls .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:

test_bls_2:
    ldi 7
    cmpi 7
    bhi .failure
    bls .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:



test_bhi_1:
    ldi 8
    cmpi 7
    blt .failure
    beq .failure
    bhi .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:

test_bhi_2:
    ldi 9
    cmpi 9
    blt .failure
    bhi .failure
    beq .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:


test_blt_1:
    ldi 7
    cmpi 8
    bhi .failure
    beq .failure
    blt .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:

test_blt_2:
    ldi 13
    cmpi 13
    blt .failure
    bhi .failure
    beq .success
    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:
halt



_aliases:
    jmp aliases.test

    eq_zs:
    .a:    beq aliases
    .b:    bzs aliases
    ne_zc:
    .a:    bne aliases
    .b:    bzc aliases
    ge_cs:
    .a:    bge aliases
    .b:    bcs aliases
    lt_cc:
    .a:    blt aliases
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

        lda ge_cs.a
        xor ge_cs.b
        andi 0xff00
        bne .failure

        lda lt_cc.a
        xor lt_cc.b
        andi 0xff00
        bne .failure

    .failure:
        ldi 0xff
        jmp .end
    .success:
        ldi 0x00
    .end:

halt



; variables
#addr 0xcf
tmp:     #res 1
counter: #res 1
result:  #d16 0
data:    #d16 "H","i","!", 0`16 ; A string with length 3
