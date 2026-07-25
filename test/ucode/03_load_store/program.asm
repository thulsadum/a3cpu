#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

; test lda

lda A
sta C
lda B
lda C
halt

A:
    #d16 0xbeef
B:
    #d16 0xcafe
C:
    #res 1
