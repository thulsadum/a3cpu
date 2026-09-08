
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
