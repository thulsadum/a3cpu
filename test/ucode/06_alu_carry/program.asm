#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

sec
clc

sez
clz

ldi  0x01
sec
adci.16 0x01
;; should give: 0x03


ldi 0x01
sec
adc.l foobar
;; should give: 0x44

ldi  0x01
clc
adci.16 0x01
;; should give: 0x02

ldi 0x01
clc
adc.l foobar
;; should give: 0x43



ldi  0x03
sec
sbbi.16 0x01
;; should give: 0x02


ldi 0x49
sec
sbb.l foobar
;; should give: 0x07

ldi  0x03
clc
sbbi.16 0x01
;; should give: 0x01

ldi 0x49
clc
sbb.l foobar
;; should give: 0x06

halt

foobar: #d16 0x42
