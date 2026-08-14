#include "../../../forth/forth.asm"

#bank forth_text

    ldi "H"
    jal fputc
    jal fgetc
    jal fputc
    jal fexit

DICT:
