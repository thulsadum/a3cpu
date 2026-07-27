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
  bits = 32
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
SIG_IR_IMM8_OUT = 1 << BUS_OFFSET + 5 ; IR from bus
SIG_ACC_IN  = 1 << BUS_OFFSET + 6 ; ACC from bus
SIG_ACC_OUT  = 1 << BUS_OFFSET + 7 ; ACC to bus
SIG_ALU_OUT  = 1 << BUS_OFFSET + 8 ; ALU to bus
BUS_END = BUS_OFFSET + 9

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
; currently empty, halt moved to flag control below.
CPU_END = CPU_OFFSET + 0

; ALU CONTROL
ALU_OFFSET = CPU_END
ALU_OP_SEL_LEN = 4
SIG_ALU_OP_ADC = 0 << ALU_OFFSET  ; ALU: A + B [A <- ACC, B <- MDR]
SIG_ALU_OP_SBB = 1 << ALU_OFFSET  ; ALU: A - B [A <- ACC, B <- MDR]
SIG_ALU_OP_SHL = 2 << ALU_OFFSET  ; ALU: A << B [A <- ACC, B <- MDR]
SIG_ALU_OP_SHR = 3 << ALU_OFFSET  ; ALU: A >> B [A <- ACC, B <- MDR]
SIG_ALU_OP_AND = 4 << ALU_OFFSET  ; ALU: A & B [A <- ACC, B <- MDR]
SIG_ALU_OP_OR  = 5 << ALU_OFFSET  ; ALU: A | B [A <- ACC, B <- MDR]
SIG_ALU_OP_XOR = 6 << ALU_OFFSET  ; ALU: A ^ B [A <- ACC, B <- MDR]
SIG_ALU_CARRY_0 = 0b00 << ALU_OFFSET + ALU_OP_SEL_LEN + 0  ; ALU[Carry_in] = 0
SIG_ALU_CARRY_1 = 0b01 << ALU_OFFSET + ALU_OP_SEL_LEN + 0  ; ALU[Carry_in] = 1
SIG_ALU_CARRY_FLAG = 0b10 << ALU_OFFSET + ALU_OP_SEL_LEN + 0  ; ALU[Carry_in] = FLAG[CARRY]
ALU_END = ALU_OFFSET + ALU_OP_SEL_LEN + 2

; FLAGS CONTROL
FLAGS_OFFSET = ALU_END
SIG_FLAGS_CLEAR = 1 << FLAGS_OFFSET + 0    ; signals CPU to update a single flag
SIG_FLAG_CHANGE = 1 << FLAGS_OFFSET + 1    ; signals CPU to update a single flag
SIG_FLAG_VALUE  = 0 << FLAGS_OFFSET + 2   ; the value to update to, will be determined later
FLAG_SEL_OFFSET = FLAGS_OFFSET + 3
FLAG_SEL_LEN = 2
SIG_FLAG_SEL_HALT  = 0 << FLAG_SEL_OFFSET
SIG_FLAG_SEL_CARRY = 1 << FLAG_SEL_OFFSET
SIG_FLAG_SEL_ZERO  = 2 << FLAG_SEL_OFFSET
FLAGS_END = FLAGS_OFFSET + FLAG_SEL_LEN



#fn set_flag(flag,value) => SIG_FLAG_CHANGE | {flag} | {value} << (FLAG_SEL_OFFSET-1)

; ucode definition

#ruledef ucode
{
    uc {signals} => signals`32
}
