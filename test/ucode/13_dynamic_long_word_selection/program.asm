#include "../../../asmdef/ac3puasm_def.asm"


; test lda

ldi 0x7003
addi 0x7005
;; ACC: 0xE008, flags: 0

ldi 0x7003
add answer
;; acc: 0x7045, flags: 0

lda answer
addi 0x7003
;; acc: 0x7045, flags: 0

lda answer
add answer
;; acc: 0x84, flags: 0

ldi 0x7005
subi 0x7003
;; acc: 2, flags: carry

ldi 0x7044
sub answer
;; acc: 0x7002, flags: carry

ldi 0x100
shli 3
;; acc: 0x0800, flags: 0

ldi 0x100
shl two
;; acc: 0x400, flags: 0

ldi 0x100
shri 3
;; acc: 0x20, flags: 0

ldi 0x100
shr two
;; acc: 0x40, flags: 0



ldi 0x8001
andi 0xff
;; acc: 0x01, flags: neg

ldi 0x8001
and mask
;; acc: 0x8000, flags: neg

lda mask
andi 0x12
;; acc: 0x00, flags: zero

lda mask
and mask
;; acc: 0xff00, flags: neg



ldi 0x8001
ori 0xf0
;; acc: 0x80f1, flags: neg

ldi 0x80
or mask
;; acc: 0xff80, flags: none

lda mask
ori 0x12
;; acc: 0xff12, flags: neg

lda mask
or mask
;; acc: 0xff00, flags: neg


ldi 0x80
xori 0x8000
;; acc: 0x8080, flags: 0

ldi 0x80
xor mask
;; acc: 0xff80, flags: nef

lda mask
xori 0x12
;; acc: 0xff12, flags: neg

lda mask
xor mask
;; acc: 0x0000, flags: zero




ldi 0x500
cmpi 0x500 ;; flags: zero, carry (EQ)
cmpi 0x600 ;; flags: neg (LT)
cmpi 0x300 ;; flags: carry (GT)

ldi 0x100
cmp memory ;; flags: carry

ldi 0x00
cmp memory ;; flags: neg

ldi 0xff
cmp memory ;; flags: zero,carry

halt

#addr 0x0100
#align 16
answer: #d16 0x0042
two:    #d16 0x0002
mask:   #d16 0xff00
foobar: #d16 0x42
memory: #d16 0x00ff
