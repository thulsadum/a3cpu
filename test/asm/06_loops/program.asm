#include "../../../asmdef/ac3puasm_def.asm"



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
    cmpi 0x18
    beq .success
    ldi 0xff
    taf
.success:


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
        cmpi 3
        beq .success
        ldi 0xff
        taf
    .success:


halt



; variables
#addr 0xcf
tmp:     #res 1
counter: #res 1
result:  #d16 0
data:    #d16 "H","i","!", 0`16 ; A string with length 3
