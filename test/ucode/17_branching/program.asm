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

halt

; variables
#addr 0x7f
tmp:     #res 1
counter: #res 1
result:  #d16 0
data:    #d16 "H","i","!", 0`16 ; A string with length 3
