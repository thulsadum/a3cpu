
: 2* ( n -- n*2 )
  1 LSHIFT ;

: 2/ ( n -- n/2 )
  DUP 0< IF
    1 RSHIFT 0x8000 OR ELSE
    1 RSHIFT THEN ;

: ROT ( a b c --- b c a )
  >R SWAP R> SWAP ;

: 2DUP ( a b -- a b a b )
  OVER OVER ;

: 2SWAP ( a b c d -- c d a b )
  ROT >R ROT R> ;

: 2OVER ( a b c d -- a b c d a b )
  >R >R 2DUP R> R> 2SWAP ;
