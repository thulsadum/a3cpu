#include "../../../asmdef/ac3puasm_def.asm"


; test lda

lda A
sta C
lda B
ldi 0x1337
sta D
lda C
lda D
halt

A:
    #d16 0xbeef
B:
    #d16 0xcafe
C:
    #res 1
D:
    #res 1
