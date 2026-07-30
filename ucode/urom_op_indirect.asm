#once

#include "urom_def.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

;;;
;;; lia - load indirect via accumulator
;;;

#bank acpu
op_lia:
    uc SIG_ACC_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_FLAGS_UPDATE | SIG_ACC_IN | SIG_UPC_RESET

#bank mrom
#addr OC_LIA
#d16 op_lia



;;;
;;; ldia / ldia.z - load indirect address
;;;

#bank acpu
op_ldia:
    uc SIG_PC_OUT | SIG_PC_INC | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_FLAGS_UPDATE | SIG_ACC_IN | SIG_UPC_RESET

op_ldiaz:
    uc SIG_IR_IMM8_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_FLAGS_UPDATE | SIG_ACC_IN | SIG_UPC_RESET

#bank mrom
#addr OC_LDIA
#d16 op_ldia
#addr OC_LDIAZ
#d16 op_ldiaz


;;;
;;; stia / stia.z - load indirect address
;;;

#bank acpu
op_stia:
    uc SIG_PC_OUT | SIG_PC_INC | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_ACC_OUT | SIG_MDR_IN
    uc SIG_RAM_WRITE | SIG_UPC_RESET

op_stiaz:
    uc SIG_IR_IMM8_OUT | SIG_MAR_IN
    uc SIG_RAM_READ
    uc SIG_MDR_OUT | SIG_MAR_IN
    uc SIG_ACC_OUT | SIG_MDR_IN
    uc SIG_RAM_WRITE | SIG_UPC_RESET

#bank mrom
#addr OC_STIA
#d16 op_stia
#addr OC_STIAZ
#d16 op_stiaz
