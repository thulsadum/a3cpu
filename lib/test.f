\ definitions for testing

VARIABLE start-depth
VARIABLE actual-depth
VARIABLE cursor
CREATE actual-results 20 CELLS ALLOT

: T{ ( -- ) 
\ save the stack depth before test
    DEPTH start-depth !   ;


: -> ( ... -- ) 
\ save all values since test beginning to RAM
    DEPTH       ( -- d )
       DUP actual-depth !   ( -- d)
       start-depth @ > IF   ( -- )
          actual-depth @  start-depth @   -   cursor !      ( -- )
          BEGIN
             cursor @ 1- cursor !             ( -- )
             actual-results cursor @ + !      ( x -- ) \ Sichert direkt an cursor-offset
             cursor @ 0=   UNTIL   THEN   ;


: }T ( ... -- ) 
\ assert expected stack depth and expected values

   DEPTH  start-depth @ -   actual-depth @  start-depth @ - DUP cursor !  = NOT IF
      0xf1 FAIL THEN
      cursor @  IF   BEGIN
         cursor @ 1- cursor !                 ( -- )
         actual-results cursor @ + @          ( -- actual-results[c] )
         = NOT   IF   0xf2 FAIL  THEN
         cursor @ 0=   UNTIL THEN  ;
