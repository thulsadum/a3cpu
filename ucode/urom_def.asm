; Definition of the ucode.

#once

; Phase 1: Fetch Instructions
#bankdef acpu
{
  bits = 16
  outp = 0
}

; BUS CONTROL
BUS_OFFSET = 0 ; offset of bus control signals 
SIG_PC_OUT  = 1 << BUS_OFFSET + 0 ; PC to bus
SIG_MAR_IN  = 1 << BUS_OFFSET + 1 ; MAR from bus
SIG_MDR_OUT = 1 << BUS_OFFSET + 2 ; MDR to bus
SIG_IR_IN   = 1 << BUS_OFFSET + 3 ; IR from bus
SIG_ACC_IN  = 1 << BUS_OFFSET + 4 ; ACC from bus
BUS_END = BUS_OFFSET + 5

; uPC CONTOL
UPC_OFFSET = BUS_END
SIG_UPC_RESET = 1 <<  UPC_OFFSET + 0
SIG_UPC_INC = 1 <<  UPC_OFFSET + 1
SIG_UPC_FROM_mROM = 1 << UPC_OFFSET +2
UPC_END = UPC_OFFSET + 3

; PC CONTROL
PC_OFFSET = UPC_END
SIG_PC_INC  = 1 << PC_OFFSET + 0 ; PC increment
PC_END = PC_OFFSET + 1

; RAM CONTROL
RAM_OFFSET = PC_END ; offset of ram control signals
SIG_RAM_READ = 1 << RAM_OFFSET + 0 ; read from RAM (to MDR)
RAM_END = RAM_OFFSET + 1

; CPU CONTROL
CPU_OFFSET = RAM_END
SIG_CPU_HALT = 1 << CPU_OFFSET + 0
CPU_END = CPU_OFFSET + 1

; ucode definition

#ruledef ucode
{
    uc {signals} => signals`16
}
