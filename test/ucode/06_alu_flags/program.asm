#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

sec
clc

sez
clz

sec
ldi  0x01
adci 0x01
;; should give: 0x03


sec
ldi 0x01
adc foobar
;; should give: 0x44

clc
ldi  0x01
adci 0x01
;; should give: 0x02

clc
ldi 0x01
adc foobar
;; should give: 0x43
halt

halt

foobar: #d16 0x42
