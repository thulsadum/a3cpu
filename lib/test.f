\ definitions for testing

VARIABLE start-depth
VARIABLE actual-depth
VARIABLE cursor
CREATE actual-results 20 CELLS ALLOT

: T{ ( -- )
   DEPTH start-depth ! ;

: -> ( ... -- )
   DEPTH DUP actual-depth !
   start-depth @ > IF
      actual-depth @ start-depth @ - cursor !
      BEGIN
         cursor @ 1- cursor !
         actual-results cursor @ CELLS + !
         cursor @ 0=
      UNTIL
   THEN ;

: }T ( ... -- )
   DEPTH start-depth @ -   actual-depth @ start-depth @ -   = IF 
      actual-depth @  start-depth @  -  DUP  cursor ! IF
         BEGIN
            cursor @ 1- cursor !
            actual-results cursor @ CELLS + @
            = IF
               \ Match -> Weiter
            ELSE
               0xf2 FAIL
            THEN
            cursor @ 0=
         UNTIL
      THEN
   ELSE
      0xf1 FAIL
   THEN ;
