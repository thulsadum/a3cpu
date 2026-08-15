\ include test facilities.

REQUIRE lib/test.f

T{ -> }T \ simplest test case

\ T{ 0xBAD -> }T \ should fail

 ( 40 2   -- 42 )
T{ 40 2 + -> 42 }T

[ASM halt ]
