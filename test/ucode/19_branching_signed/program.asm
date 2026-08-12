#include "../../../asmdef/ac3puasm_def.asm"



test_bge_s:
    ldi  8
    cmpi -7
    blt .failure
    beq .failure
    bge .success
    .failure:
        ldi 0xff
        taf
    .success:
        ldi 0x00


test_blt_s:
    ldi  -8
    cmpi 7
    bge .failure
    beq .failure
    blt .success
    .failure:
        ldi 0xff
        taf
    .success:
        ldi 0x00



test_bhi_s: ;; bls is unsigned, thus -> -7 > 8
    ldi -7
    cmpi 8
    bls .failure
    beq .failure
    bhi .success
    .failure:
        ldi 0xff
        taf
    .success:
        ldi 0x00


test_bls_s: ;; bls is unsigned, thus -> 7 < -8
    ldi 7
    cmpi -8
    bhi .failure
    beq .failure
    bls .success
    .failure:
        ldi 0xff
        taf
    .success:
        ldi 0x00


test_blo_s: ; 42 <(unsigned) -1
    ldi 42
    cmpi -1
    bhs .failure
    beq .failure
    blo .success
.failure:
    ldi 0xff
    taf
.success:



test_bhs_s: ; -1 >=(unsigned) -42
    ldi  -1
    cmpi -42
    blo .failure
    beq .failure
    bhs .success
.failure:
    ldi 0xff
    taf
.success:



test_bgt_s:
    ldi 42
    cmpi -1
    ble .failure
    beq .failure
    bgt .success
.failure:
    ldi 0xff
    taf
.success:



test_ble_s:
    ldi -42
    cmpi 1
    bgt .failure
    beq .failure
    ble .success
.failure:
    ldi 0xff
    taf
.success:


halt

