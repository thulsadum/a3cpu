
#include "../../../forth/forth.asm"

#bank forth_text
    jal fexit
    lda 0xff
    taf ; should not be reached

DICT:
