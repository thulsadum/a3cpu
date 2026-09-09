
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
[ASM tc_eq_0:] T{  0  0 = -> <TRUE>  }T
[ASM tc_eq_1:] T{  1  1 = -> <TRUE>  }T
[ASM tc_eq_2:] T{ -1 -1 = -> <TRUE>  }T
[ASM tc_eq_3:] T{  1  0 = -> <FALSE> }T
[ASM tc_eq_4:] T{ -1  0 = -> <FALSE> }T
[ASM tc_eq_5:] T{  0  1 = -> <FALSE> }T
[ASM tc_eq_6:] T{  0 -1 = -> <FALSE> }T
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



\ F.6.1.0540
\ >
[ASM tc_gt_0 :] T{       0       1 > -> <FALSE> }T
[ASM tc_gt_1 :] T{       1       2 > -> <FALSE> }T
[ASM tc_gt_2 :] T{      -1       0 > -> <FALSE> }T
[ASM tc_gt_3 :] T{      -1       1 > -> <FALSE> }T
[ASM tc_gt_4 :] T{ MIN-INT       0 > -> <FALSE> }T
[ASM tc_gt_5 :] T{ MIN-INT MAX-INT > -> <FALSE> }T
[ASM tc_gt_6 :] T{       0 MAX-INT > -> <FALSE> }T
[ASM tc_gt_7 :] T{       0       0 > -> <FALSE> }T
[ASM tc_gt_8 :] T{       1       1 > -> <FALSE> }T
[ASM tc_gt_9 :] T{       1       0 > -> <TRUE>  }T
[ASM tc_gt_10:]  T{       2       1 > -> <TRUE>  }T
[ASM tc_gt_11:]  T{       0      -1 > -> <TRUE>  }T
[ASM tc_gt_12:]  T{       1      -1 > -> <TRUE>  }T
[ASM tc_gt_13:]  T{       0 MIN-INT > -> <TRUE>  }T
[ASM tc_gt_14:]  T{ MAX-INT MIN-INT > -> <TRUE>  }T
[ASM tc_gt_15:]  T{ MAX-INT       0 > -> <TRUE>  }T



\ F.6.1.2340
\ U<
[ASM tc_ult_0 :] T{        0        1 U< -> <TRUE>  }T
[ASM tc_ult_1 :] T{        1        2 U< -> <TRUE>  }T
[ASM tc_ult_2 :] T{        0 MID-UINT U< -> <TRUE>  }T
[ASM tc_ult_3 :] T{        0 MAX-UINT U< -> <TRUE>  }T
[ASM tc_ult_4 :] T{ MID-UINT MAX-UINT U< -> <TRUE>  }T
[ASM tc_ult_5 :] T{        0        0 U< -> <FALSE> }T
[ASM tc_ult_6 :] T{        1        1 U< -> <FALSE> }T
[ASM tc_ult_7 :] T{        1        0 U< -> <FALSE> }T
[ASM tc_ult_8 :] T{        2        1 U< -> <FALSE> }T
[ASM tc_ult_9 :] T{ MID-UINT        0 U< -> <FALSE> }T
[ASM tc_ult_10:]  T{ MAX-UINT        0 U< -> <FALSE> }T
[ASM tc_ult_11:]  T{ MAX-UINT MID-UINT U< -> <FALSE> }T




\ F.6.1.1870
\ MAX
[ASM tc_max_0 :] T{       0       1 MAX ->       1 }T
[ASM tc_max_1 :] T{       1       2 MAX ->       2 }T
[ASM tc_max_2 :] T{      -1       0 MAX ->       0 }T
[ASM tc_max_3 :] T{      -1       1 MAX ->       1 }T
[ASM tc_max_4 :] T{ MIN-INT       0 MAX ->       0 }T
[ASM tc_max_5 :] T{ MIN-INT MAX-INT MAX -> MAX-INT }T
[ASM tc_max_6 :] T{       0 MAX-INT MAX -> MAX-INT }T
[ASM tc_max_7 :] T{       0       0 MAX ->       0 }T
[ASM tc_max_8 :] T{       1       1 MAX ->       1 }T
[ASM tc_max_9 :] T{       1       0 MAX ->       1 }T
[ASM tc_max_10:]  T{       2       1 MAX ->       2 }T
[ASM tc_max_11:]  T{       0      -1 MAX ->       0 }T
[ASM tc_max_12:]  T{       1      -1 MAX ->       1 }T
[ASM tc_max_13:]  T{       0 MIN-INT MAX ->       0 }T
[ASM tc_max_14:]  T{ MAX-INT MIN-INT MAX -> MAX-INT }T
[ASM tc_max_15:]  T{ MAX-INT       0 MAX -> MAX-INT }T



\ F.6.1.1880
\ MIN
[ASM tc_min_0 :] T{       0       1 MIN ->       0 }T
[ASM tc_min_1 :] T{       1       2 MIN ->       1 }T
[ASM tc_min_2 :] T{      -1       0 MIN ->      -1 }T
[ASM tc_min_3 :] T{      -1       1 MIN ->      -1 }T
[ASM tc_min_4 :] T{ MIN-INT       0 MIN -> MIN-INT }T
[ASM tc_min_5 :] T{ MIN-INT MAX-INT MIN -> MIN-INT }T
[ASM tc_min_6 :] T{       0 MAX-INT MIN ->       0 }T
[ASM tc_min_7 :] T{       0       0 MIN ->       0 }T
[ASM tc_min_8 :] T{       1       1 MIN ->       1 }T
[ASM tc_min_9 :] T{       1       0 MIN ->       0 }T
[ASM tc_min_10:]  T{       2       1 MIN ->       1 }T
[ASM tc_min_11:]  T{       0      -1 MIN ->      -1 }T
[ASM tc_min_12:]  T{       1      -1 MIN ->      -1 }T
[ASM tc_min_13:]  T{       0 MIN-INT MIN -> MIN-INT }T
[ASM tc_min_14:]  T{ MAX-INT MIN-INT MIN -> MIN-INT }T
[ASM tc_min_15:]  T{ MAX-INT       0 MIN ->       0 }T
