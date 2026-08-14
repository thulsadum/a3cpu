

[ASM test_create_0: #res 1 ]

CREATE alias_foo
VARIABLE foo
alias_foo foo = 
[ASM   jal __assert.test_create_0 ]

[ASM ret test_create_0 ]





[ASM test_create_1: #res 1 ]

CREATE before
CREATE bar 5 CELLS ALLOT
CREATE after
after before -

[ASM   jal __assert.test_create_1 ]

[ASM ret test_create_1 ]



