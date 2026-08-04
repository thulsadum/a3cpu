#once
#include "urom_def.asm"
#include "../asmdef/ac3puasm_opcodes.asm"


;;;
;;; jmp
;;;

#bank acpu
op_jmp:
    uc SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_PC_IN | SIG_UPC_RESET

op_jmpz:
    uc SIG_IR_IMM8_OUT | SIG_PC_IN | SIG_UPC_RESET

op_jpa:
    uc SIG_ACC_OUT | SIG_PC_IN | SIG_UPC_RESET

#bank mrom
#addr OC_JMP
#d16 op_jmp
#addr OC_JMPZ
#d16 op_jmpz
#addr OC_JPA
#d16 op_jpa


;;;
;;; jal
;;;

#bank acpu
op_jal:
    uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_MDR_IN  | SIG_PC_OUT
    uc SIG_RAM_WRITE | SIG_MAR_OUT | SIG_PC_IN
    uc SIG_PC_INC | SIG_UPC_RESET

op_jalz:
    uc SIG_IR_IMM8_OUT | SIG_MAR_IN
    uc SIG_MDR_IN  | SIG_PC_OUT
    uc SIG_RAM_WRITE | SIG_IR_IMM8_OUT | SIG_PC_IN
    uc SIG_PC_INC | SIG_UPC_RESET

#bank mrom
#addr OC_JAL
#d16 op_jal
#addr OC_JALZ
#d16 op_jalz



;;;
;;; ret
;;;

#bank acpu
op_ret:
    uc SIG_PC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT  | SIG_PC_IN | SIG_UPC_RESET

op_retz:
    uc SIG_IR_IMM8_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT  | SIG_PC_IN | SIG_UPC_RESET

#bank mrom
#addr OC_RET
#d16 op_ret
#addr OC_RETZ
#d16 op_retz
