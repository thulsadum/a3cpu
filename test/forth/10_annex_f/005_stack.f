
\ F.6.1.1260
\ DROP
[ASM tc_drop_0:] T{ 1 2 DROP -> 1 }T
[ASM tc_drop_1:] T{ 0   DROP ->   }T


\ F.6.1.1290
\ DUP
[ASM tc_dup:] T{ 1 DUP -> 1 1 }T


\ F.6.1.1990
\ OVER
[ASM tc_over:] T{ 1 2 OVER -> 1 2 1 }T


\ F.6.1.2160
\ ROT
[ASM tc_rot:] T{ 1 2 3 ROT -> 2 3 1 }T


\ F.6.1.2260
\ SWAP
[ASM tc_swap:] T{ 1 2 SWAP -> 2 1 }T



\\\ two cell stack operations

\ F.6.1.0370
\ 2DROP
[ASM tc_2drop:] T{ 1 2 2DROP -> }T


\ F.6.1.0380
\ 2DUP
[ASM tc_2dup:] T{ 1 2 2DUP -> 1 2 1 2 }T


\ F.6.1.0430
\ 2SWAP
[ASM tc_2swap:] T{ 1 2 3 4 2SWAP -> 3 4 1 2 }T


\ F.6.1.0400
\ 2OVER
[ASM tc_2over:] T{ 1 2 3 4 2OVER -> 1 2 3 4 1 2 }T

