#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

; test lda

lda.l A
sta.l C
lda.l B
ldi 0x1337
sta.l D
lda.l C
lda.l D
halt

A:
    #d16 0xbeef
B:
    #d16 0xcafe
C:
    #res 1
D:
    #res 1
