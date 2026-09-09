
: 2* ( n -- n*2 )
  1 LSHIFT ;

: 2/ ( n -- n/2 )
  DUP 0< IF
    1 RSHIFT 0x8000 OR ELSE
    1 RSHIFT THEN ;

: ROT ( a b c --- b c a )
  >R SWAP R> SWAP ;
: 2SWAP ( a b c d -- c d a b )
  ROT >R ROT R> ;
