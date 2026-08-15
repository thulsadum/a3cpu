

[ASM test_if_else_0: #res 1 ]

0 0=
IF 42 ELSE 21 THEN

[ASM   jal __assert.test_if_else_0 ]

[ASM ret test_if_else_0 ]





[ASM test_if_else_1: #res 1 ]

7 0=
IF 42 ELSE 21 THEN

[ASM   jal __assert.test_if_else_1 ]

[ASM ret test_if_else_1 ]



[ASM test_if_0: #res 1 ]
 0 0= IF 42 THEN
[ASM   jal __assert.test_if_0 ]
[ASM ret test_if_0 ]

[ASM test_if_1: #res 1 ]
 7 0= IF 42 THEN
[ASM   jal __assert.test_if_1 ]
[ASM ret test_if_1 ]


[ASM test_if_melse_0: #res 1 ]
 0 0= IF 1 ELSE 2 ELSE 3 ELSE 4 ELSE 5 THEN
[ASM   jal __assert.test_if_melse_0 ]
[ASM ret test_if_melse_0 ]

[ASM test_if_melse_1: #res 1 ]
 1 0= IF 1 ELSE 2 ELSE 3 ELSE 4 ELSE 5 THEN
[ASM   jal __assert.test_if_melse_1 ]
[ASM ret test_if_melse_1 ]

