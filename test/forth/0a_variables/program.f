

[ASM test_variable_store: #res 1 ]

VARIABLE foo
1000 foo !  [ASM   jal __assert.test_variable_0 ]

[ASM ret test_variable_store ]



[ASM test_variable_fetch: #res 1 ]

foo @  [ASM   jal __assert.test_variable_1 ]

[ASM ret test_variable_fetch ]



