
[ASM test_eq0: ]
[ASM #res 1 ]
0 0=
[ASM jal __assert.test_eq0_0 ]
1 0=
[ASM jal __assert.test_eq0_1 ]
-1 0=
[ASM jal __assert.test_eq0_2 ]
[ASM ret test_eq0 ]


[ASM test_eq: ]
[ASM #res 1 ]
42 42 =
[ASM jal __assert.test_eq_0 ]
0 0 =
[ASM jal __assert.test_eq_1 ]
0 1 =
[ASM jal __assert.test_eq_2 ]
-42 42 =
[ASM jal __assert.test_eq_3 ]
[ASM ret test_eq ]


[ASM test_lt: ]
[ASM #res 1 ]
0 1 <
[ASM jal __assert.test_lt_0 ]
-1 1 <
[ASM jal __assert.test_lt_1 ]
1 1 <
[ASM jal __assert.test_lt_2 ]
1 -1 <
[ASM jal __assert.test_lt_3 ]
[ASM ret test_lt ]

[ASM test_lt0:
  #res 1 ]
 1 0<
[ASM   jal __assert.test_lt0_0 ]
 0 0<
[ASM   jal __assert.test_lt0_1 ]
-1 0<
[ASM   jal __assert.test_lt0_2 ]
[ASM   ret test_lt0 ]


[ASM test_gt:
  #res 1 ]
 1 0 >
[ASM   jal __assert.test_gt_0 ]
 0 0 >
[ASM   jal __assert.test_gt_1 ]
-1 0 >
[ASM   jal __assert.test_gt_2 ]
[ASM   ret test_gt ]

