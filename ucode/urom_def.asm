; Definition of the ucode.

#once

; Phase 1: Fetch Instructions
#bankdef acpu
{
  bits = 7
}

; BUS CONTROL
SIG_BUS_OFFSET = 0 ; offset of bus control signals 
SIG_PC_OUT  = 1 << SIG_BUS_OFFSET + 0 ; PC to bus
SIG_MAR_IN  = 1 << SIG_BUS_OFFSET + 1 ; MAR from bus
SIG_MDR_OUT = 1 << SIG_BUS_OFFSET + 2 ; MDR to bus
SIG_IR_IN   = 1 << SIG_BUS_OFFSET + 3 ; IR from bus
SIG_PC_INC  = 1 << SIG_BUS_OFFSET + 4 ; PC increment
SIG_ACC_IN  = 1 << SIG_BUS_OFFSET + 5 ; ACC from bus

; RAM CONTROL
SIG_RAM_OFFSET = SIG_BUS_OFFSET + 6 ; offset of ram control signals
SIG_RAM_READ = 1 << SIG_RAM_OFFSET + 0 ; read from RAM (to MDR)

