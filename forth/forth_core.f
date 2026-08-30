
: 2* ( n -- n*2 )
  1 LSHIFT ;

: 2/ ( n -- n/2 )
  DUP 0< IF
    1 RSHIFT 0x8000 OR ELSE
    1 RSHIFT THEN ;
