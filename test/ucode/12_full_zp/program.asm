#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

; test lda

ldi 3
addi 5
;; ACC: 8, flags: 0

ldi 3
add answer
;; acc: 0x45, flags: 0

lda answer
addi 3
;; acc: 0x45, flags: 0

lda answer
add answer
;; acc: 0x84, flags: 0

ldi 5
subi 3
;; acc: 2, flags: carry

ldi 0x44
sub answer
;; acc: 2, flags: carry

ldi 1
shli 3
;; acc: 8, flags: 0

ldi 1
shl two
;; acc: 4, flags: 0

ldi 16
shri 3
;; acc: 2, flags: 0

ldi 16
shr two
;; acc: 4, flags: 0



ldi 0x8001
andi 0x8000
;; acc: 0x8000, flags: neg

ldi 0x8001
and mask
;; acc: 0x8000, flags: neg

lda mask
andi 0x1234
;; acc: 0x1200, flags: 0

lda mask
and mask
;; acc: 0xff00, flags: neg



ldi 0x8001
ori 0x8000
;; acc: 0x8001, flags: neg

ldi 0x8001
or mask
;; acc: 0xff01, flags: neg

lda mask
ori 0x1234
;; acc: 0xff34, flags: neg

lda mask
or mask
;; acc: 0xff00, flags: neg


ldi 0x8001
xori 0x8000
;; acc: 0x0001, flags: 0

ldi 0x8001
xor mask
;; acc: 0x7f01, flags: 0

lda mask
xori 0x1234
;; acc: 0xed34, flags: neg

lda mask
xor mask
;; acc: 0x0000, flags: zero




ldi  0x01
sec
adci 0x01
;; should give: 0x03


ldi 0x01
sec
adc foobar
;; should give: 0x44

ldi  0x01
clc
adci 0x01
;; should give: 0x02

ldi 0x01
clc
adc foobar
;; should give: 0x43

ldi  0x03
sec
sbbi 0x01
;; should give: 0x02

ldi 0x49
sec
sbb foobar
;; should give: 0x07

ldi  0x03
clc
sbbi 0x01
;; should give: 0x01

ldi 0x49
clc
sbb foobar
;; should give: 0x06




ldi 0x5
cmpi 0x5 ;; flags: zero, carry (EQ)
cmpi 0x6 ;; flags: neg (LT)
cmpi 0x3 ;; flags: carry (GT)

ldi 0x100
cmp memory ;; flags: carry

ldi 0x00
cmp memory ;; flags: neg

ldi 0xff
cmp memory ;; flags: zero,carry

halt

answer: #d16 0x0042
two:    #d16 0x0002
mask:   #d16 0xff00
foobar: #d16 0x42
memory: #d16 0x00ff
