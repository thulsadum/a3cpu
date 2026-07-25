; Definition of the ucode.

#once

#bankdef mrom
{
    bits = 16
    outp = 0
    size = 255
    fill = 0
}

#bankdef acpu
{
  bits = 16
  outp = 16*256
  addr = 0x0000
}

; BUS CONTROL
BUS_OFFSET = 0 ; offset of bus control signals 
SIG_PC_OUT  = 1 << BUS_OFFSET + 0 ; PC to bus
SIG_MAR_IN  = 1 << BUS_OFFSET + 1 ; MAR from bus
SIG_MDR_IN = 1 << BUS_OFFSET + 2 ; MDR from bus
SIG_MDR_OUT = 1 << BUS_OFFSET + 3 ; MDR to bus
SIG_IR_IN   = 1 << BUS_OFFSET + 4 ; IR from bus
SIG_ACC_IN  = 1 << BUS_OFFSET + 5 ; ACC from bus
SIG_ACC_OUT  = 1 << BUS_OFFSET + 6 ; ACC to bus
SIG_ALU_OUT  = 1 << BUS_OFFSET + 7 ; ALU to bus
BUS_END = BUS_OFFSET + 8

; uPC CONTOL
UPC_OFFSET = BUS_END
SIG_UPC_RESET = 1 <<  UPC_OFFSET + 0
;SIG_UPC_INC = 1 <<  UPC_OFFSET + 1
SIG_UPC_FROM_mROM = 1 << UPC_OFFSET +1
UPC_END = UPC_OFFSET + 2

; PC CONTROL
PC_OFFSET = UPC_END
SIG_PC_INC  = 1 << PC_OFFSET + 0 ; PC increment
PC_END = PC_OFFSET + 1

; RAM CONTROL
RAM_OFFSET = PC_END ; offset of ram control signals
SIG_RAM_READ = 1 << RAM_OFFSET + 0 ; read from RAM (to MDR)
SIG_RAM_WRITE = 1 << RAM_OFFSET + 1 ; write to RAM (from MDR)
RAM_END = RAM_OFFSET + 2

; CPU CONTROL
CPU_OFFSET = RAM_END
SIG_CPU_HALT = 1 << CPU_OFFSET + 0
CPU_END = CPU_OFFSET + 1

ALU_OFFSET = CPU_END
SIG_ALU_OP_ADD = 1 << ALU_OFFSET + 0 ; ALU: A + B [A <- ACC, B <- MDR]
ALU_END = ALU_OFFSET + 1

; ucode definition

#ruledef ucode
{
    uc {signals} => signals`16
}
