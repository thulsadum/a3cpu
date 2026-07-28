#include "../../../asmdef/ac3puasm_def.asm"

#bank ac3pu_program

ldi.16 0
;; should set zero flag

dec
;; should set negative flag

inc
;; should set carry flag and zero flag

sei
;; should set interrupt flag

cli
;; should clear intrrupt flag

ldi.16 0
sec
tfa

;; ACC should contain flags

ldi.16 1
taf
;; flags schould be 0x01 (halt)

