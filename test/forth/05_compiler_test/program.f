
[ASM test_add: ]
[ASM #res 1 ]
42 17 +
[ASM jal __assert.test_add ]
[ASM ret test_add ]

[ASM test_sub: ]
[ASM #res 1 ]
42 17 -
[ASM jal __assert.test_sub ]
[ASM ret test_sub ]


[ASM test_and: ]
[ASM #res 1 ]
42 17 AND
[ASM jal __assert.test_and ]
[ASM ret test_and ]


[ASM test_or: ]
[ASM #res 1 ]
42 17 OR
[ASM jal __assert.test_or ]
[ASM ret test_or ]


[ASM test_fetch: ]
[ASM #res 1 ]
[ASM push(pad.fetch) ] @
[ASM jal __assert.test_fetch ]
[ASM ret test_fetch ]


[ASM test_store: ]
[ASM #res 1 ]
0xfe 0xca 8 LSHIFT or
[ASM push(pad.store) ] !
[ASM jal __assert.test_store ]
[ASM ret test_store ]

[ASM pad: .fetch: #d16 0xf00b ]
[ASM      .store: #d16 0 ]


