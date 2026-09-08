
[ASM tc_shifts_msb:] T{ MSB BITSSET? -> 0 0 }T

\ F.6.1.0320
\ 2*
[ASM tc_shifts_2mul_0:] T{   0S 2*       ->   0S }T
[ASM tc_shifts_2mul_1:] T{    1 2*       ->    2 }T
[ASM tc_shifts_2mul_2:] T{ 4000 2*       -> 8000 }T
[ASM tc_shifts_2mul_3:] T{   1S 2* 1 XOR ->   1S }T
[ASM tc_shifts_2mul_4:] T{  MSB 2*       ->   0S }T



\ F.6.1.0330
\ 2/
[ASM tc_shifts_2div_0:] T{          0S 2/ ->   0S }T
[ASM tc_shifts_2div_1:] T{           1 2/ ->    0 }T
[ASM tc_shifts_2div_2:] T{        4000 2/ -> 2000 }T
[ASM tc_shifts_2div_3:] T{          1S 2/ ->   1S }T \ MSB PROPOGATED
[ASM tc_shifts_2div_4:] T{    1S 1 XOR 2/ ->   1S }T
[ASM tc_shifts_2div_5:] T{ MSB 2/ MSB AND ->  MSB }T


\ F.6.1.1805
\ LSHIFT
[ASM tc_shifts_shl_0:] T{   1 0 LSHIFT ->    1 }T
[ASM tc_shifts_shl_1:] T{   1 1 LSHIFT ->    2 }T
[ASM tc_shifts_shl_2:] T{   1 2 LSHIFT ->    4 }T
[ASM tc_shifts_shl_3:] T{   1 0xF LSHIFT -> 0x8000 }T \ BIGGEST GUARANTEED SHIFT
[ASM tc_shifts_shl_4:] T{  1S 1 LSHIFT 1 XOR -> 1S }T
[ASM tc_shifts_shl_5:] T{ MSB 1 LSHIFT ->    0 }T



\ F.6.1.2162
\ RSHIFT
[ASM tc_shifts_shr_0:] T{    1 0 RSHIFT -> 1 }T
[ASM tc_shifts_shr_1:] T{    1 1 RSHIFT -> 0 }T
[ASM tc_shifts_shr_2:] T{    2 1 RSHIFT -> 1 }T
[ASM tc_shifts_shr_3:] T{    4 2 RSHIFT -> 1 }T
[ASM tc_shifts_shr_4:] T{ 0x8000 0xF RSHIFT -> 1 }T                \ Biggest
[ASM tc_shifts_shr_5:] T{  MSB 1 RSHIFT MSB AND ->   0 }T    \ RSHIFT zero fills MSBs
[ASM tc_shifts_shr_6:] T{  MSB 1 RSHIFT     2*  -> MSB }T

