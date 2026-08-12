#include "../../../asmdef/ac3puasm_def.asm"



test_sign_pl:
    ldi 5
    subi 3
    bmi .failure
    bpl .success
        ldi 0xff ; should not run ever
        taf
    .failure:
        ldi 0xff
        taf
    .success:



test_sign_mi:
    ldi 3
    subi 5
    bpl .failure
    bmi .success
        ldi 0xff ; should not run ever
        taf
    .failure:
        ldi 0xff
        taf
    .success:



test_bge_1:
    ldi 8
    cmpi 7
    bls .failure
    beq .failure
    bge .success
    .failure:
        ldi 0xff
        taf
    .success:



test_bge_2:
    ldi 8
    cmpi 8
    blt .failure
    bge .success
    .failure:
        ldi 0xff
        taf
    .success:




test_bls_1:
    ldi 7
    cmpi 8
    bge .failure
    beq .failure
    bls .success
    .failure:
        ldi 0xff
        taf
    .success:



test_bls_2:
    ldi 7
    cmpi 7
    bhi .failure
    bls .success
    .failure:
        ldi 0xff
        taf
    .success:



test_bhi_1:
    ldi 8
    cmpi 7
    blt .failure
    beq .failure
    bhi .success
    .failure:
        ldi 0xff
        taf
    .success:



test_bhi_2:
    ldi 9
    cmpi 9
    blt .failure
    bhi .failure
    beq .success
    .failure:
        ldi 0xff
        taf
    .success:




test_blt_1:
    ldi 7
    cmpi 8
    bhi .failure
    beq .failure
    blt .success
    .failure:
        ldi 0xff
        taf
    .success:



test_blt_2:
    ldi 13
    cmpi 13
    blt .failure
    bhi .failure
    beq .success
    .failure:
        ldi 0xff
        taf
    .success:

test_ble_1:
    ldi 6
    cmpi 7
    bgt .failure
    beq .failure
    ble .success
.failure:
    ldi 0xff
    taf
.success:


test_ble_2:
    ldi -6
    cmpi -6
    bgt .failure
    ble .success
.failure:
    ldi 0xff
    taf
.success:


test_bgt_1:
    ldi 7
    cmpi 6
    ble .failure
    beq .failure
    bgt .success
.failure:
    ldi 0xff
    taf
.success:



test_bgt_2:
    ldi -6
    cmpi -7
    ble .failure
    beq .failure
    bgt .success
.failure:
    ldi 0xff
    taf
.success:


test_blo_1:
    ldi 7
    cmpi 8
    bhs .failure
    beq .failure
    blo .success
    .failure:
        ldi 0xff
        taf
    .success:



test_blo_2:
    ldi -8
    cmpi -7
    bhs .failure
    beq .failure
    blo .success
.failure:
    ldi 0xff
    taf
.success:

test_bhs_1:
    ldi 1000
    cmpi 500
    blo .failure
    beq .failure
    bhs .success
.failure:
    ldi 0xff
    taf
.success:


test_bgs_2:
    ldi -87
    cmpi -87
    blo .failure
    bhs .success
.failure:
    ldi 0xff
    taf
.success:

halt
