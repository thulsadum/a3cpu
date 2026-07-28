#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

ldi.16 5
sec  ;; set carry flag to make update visible
tst  ;; flags: none

ldi.16 0xffff
sec
tst  ;; flags: neg

ldi.16 0
sec
tst ;; flags: zero

ldi.16 0x5
cmpi 0x5 ;; flags: zero, carry (EQ)
cmpi 0x6 ;; flags: neg (LT)
cmpi 0x3 ;; flags: carry (GT)

ldi.16 0x100
cmp.l memory ;; flags: carry

ldi.16 0x000
cmp.l memory ;; flags: neg

ldi.16 0xff
cmp.l memory ;; flags: zero,carry

halt

memory: #d16 0x00ff
