; Definition of the ucode.

#once

; Phase 1: Fetch Instructions
#bankdef acpu
{
  bits = 8
  outp = 0
}

; BUS CONTROL
SIG_BUS_OFFSET = 0 ; offset of bus control signals 
SIG_PC_OUT  = 1 << SIG_BUS_OFFSET + 0 ; PC to bus
SIG_MAR_IN  = 1 << SIG_BUS_OFFSET + 1 ; MAR from bus
SIG_MDR_OUT = 1 << SIG_BUS_OFFSET + 2 ; MDR to bus
SIG_IR_IN   = 1 << SIG_BUS_OFFSET + 3 ; IR from bus
SIG_ACC_IN  = 1 << SIG_BUS_OFFSET + 4 ; ACC from bus

; PC CONTROL
SIG_PC_OFFSET = SIG_BUS_OFFSET + 5
SIG_PC_INC  = 1 << SIG_PC_OFFSET + 0 ; PC increment

; RAM CONTROL
SIG_RAM_OFFSET = SIG_PC_OFFSET + 1 ; offset of ram control signals
SIG_RAM_READ = 1 << SIG_RAM_OFFSET + 0 ; read from RAM (to MDR)


; ucode definition

#ruledef ucode
{
    uc {signals} => signals`8
}
