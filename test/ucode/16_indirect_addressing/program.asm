#include "../../../asmdef/ac3puasm_def.asm"



program:
    lda ptr
    lia  ; load indirect by ACC
    xori 0xC0FF ;; expected: ACC = 0x0000, flags: zero

    lda ptr
    inc
    lia
    xori 0xBEEF ;; expected: ACC = 0x0000, flags: zero

    ldia ptr
    xori 0xC0FF ;; expected: ACC = 0x0000, flags: zero

    ldi  0x1337
    stia ptr

    ldia ptr_far
    lia  ; this double deref
    xori 0x1337 ;; expected: ACC = 0x0000, flags: zero


    ldia ptr_far_target
    xori 0xffff         ;; expect succsss.

    ldi  0x4242
    stia ptr_far_target
    ldia ptr_far_target
    xori 0x4242         ;; expected: ACC = 0x0000, flags: zero

halt

#addr 0x7f
ptr: #d16 var
#addr 0x8f
var: #d16 0xC0FF, 0xBEEF

#addr 0x100
ptr_far: #d16 ptr

#addr 0x200
#d16 0xffff
ptr_far_target: #d16 $-1
