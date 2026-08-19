\ F.6.1.0720
\ AND

T{ 0 0 AND -> 0 }T
T{ 0 1 AND -> 0 }T
T{ 1 0 AND -> 0 }T
T{ 1 1 AND -> 1 }T

T{ 0 INVERT 1 AND -> 1 }T
T{ 1 INVERT 1 AND -> 0 }T

\ TO DO should be reenabled later
\ T{ 0S 0S AND -> 0S }T
\ T{ 0S 1S AND -> 0S }T
\ T{ 1S 0S AND -> 0S }T
\ T{ 1S 1S AND -> 1S }T




\ F.6.1.1720
\ INVERT

\ T{ 0S INVERT -> 1S }T
\ T{ 1S INVERT -> 0S }T



\ F.6.1.0950
\ CONSTANT
T{ 123 CONSTANT X123 -> }T
T{ X123 -> 123 }T

\ T{ : EQU CONSTANT ; -> }T
\ T{ X123 EQU Y123 -> }T
\ T{ Y123 -> 123 }T


