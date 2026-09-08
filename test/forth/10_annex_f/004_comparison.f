
\ F.6.1.0270
\ 0=
T{        0 0= -> <TRUE>  }T
T{        1 0= -> <FALSE> }T
T{        2 0= -> <FALSE> }T
T{       -1 0= -> <FALSE> }T
T{ MAX-UINT 0= -> <FALSE> }T
T{ MIN-INT  0= -> <FALSE> }T
T{ MAX-INT  0= -> <FALSE> }T


\ F.6.1.0530
\ =
T{  0  0 = -> <TRUE>  }T
T{  1  1 = -> <TRUE>  }T
T{ -1 -1 = -> <TRUE>  }T
T{  1  0 = -> <FALSE> }T
T{ -1  0 = -> <FALSE> }T
T{  0  1 = -> <FALSE> }T
T{  0 -1 = -> <FALSE> }T
[ASM tc_min_eq_msg:] T{ MIN-INT MSB = -> <TRUE> }T

\ F.6.1.0250
\ 0<
[ASM tc_lt0_0:] T{       0 0< -> <FALSE> }T
[ASM tc_lt0_1:] T{      -1 0< -> <TRUE>  }T
[ASM tc_lt0_2:] T{ MIN-INT 0< -> <TRUE>  }T
[ASM tc_lt0_3:] T{       1 0< -> <FALSE> }T
[ASM tc_lt0_4:] T{ MAX-INT 0< -> <FALSE> }T


\ F.6.1.0480
\ <
[ASM tc_lt_0:] T{       0       1 < -> <TRUE>  }T
[ASM tc_lt_1:] T{       1       2 < -> <TRUE>  }T
[ASM tc_lt_2:] T{      -1       0 < -> <TRUE>  }T
[ASM tc_lt_3:] T{      -1       1 < -> <TRUE>  }T
[ASM tc_lt_4:] T{ MIN-INT       0 < -> <TRUE>  }T
[ASM tc_lt_5:] T{ MIN-INT MAX-INT < -> <TRUE>  }T
[ASM tc_lt_6:] T{       0 MAX-INT < -> <TRUE>  }T
[ASM tc_lt_7:] T{       0       0 < -> <FALSE> }T
[ASM tc_lt_8:] T{       1       1 < -> <FALSE> }T
[ASM tc_lt_9:] T{       1       0 < -> <FALSE> }T
[ASM tc_lt_a:] T{       2       1 < -> <FALSE> }T
[ASM tc_lt_b:] T{       0      -1 < -> <FALSE> }T
[ASM tc_lt_c:] T{       1      -1 < -> <FALSE> }T
[ASM tc_lt_d:] T{       0 MIN-INT < -> <FALSE> }T
[ASM tc_lt_e:] T{ MAX-INT MIN-INT < -> <FALSE> }T
[ASM tc_lt_f:] T{ MAX-INT       0 < -> <FALSE> }T
