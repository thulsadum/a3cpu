#once

#include "urom_def.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

#fn __branch_impl(selector,inverse) => selector | inverse | SIG_PC_ADD_OFFSET | SIG_UPC_RESET


;;;
;;; bra - branch always (aka relative jump)
;;;

#bank acpu

op_bra:
    uc __branch_impl(SIG_EXEC_SEL_ALWAYS, 0)


#bank mrom
#addr OC_BRA
#d16 op_bra



;;;
;;; beq / bne - branch if equal, and branch if not equal (aka bz, bnz)
;;;

#bank acpu

op_beq:
    uc __branch_impl(SIG_EXEC_SEL_ZERO, 0)
    uc SIG_UPC_RESET

op_bne:
    uc __branch_impl(SIG_EXEC_SEL_ZERO, SIG_EXEC_INV)
    uc SIG_UPC_RESET

#bank mrom
#addr OC_BEQ
#d16 op_beq
#addr OC_BNE
#d16 op_bne



;;;
;;; bpl / bmi - branch if positive (plus or zero), and branch if negative (minus)
;;;

#bank acpu

op_bpl:
    uc __branch_impl(SIG_EXEC_SEL_NEG, SIG_EXEC_INV)
    uc SIG_UPC_RESET

op_bmi:
    uc __branch_impl(SIG_EXEC_SEL_NEG, 0)
    uc SIG_UPC_RESET

#bank mrom
#addr OC_BPL
#d16 op_bpl
#addr OC_BMI
#d16 op_bmi



;;;
;;; bls / bhi - branch if less or same (unsigned <=), and branch if higher (unsigned >)
;;;

#bank acpu

op_bls:
    uc __branch_impl(SIG_EXEC_SEL_ZERO_NOBORROW, 0)
    uc SIG_UPC_RESET

op_bhi:
    uc __branch_impl(SIG_EXEC_SEL_ZERO_NOBORROW, SIG_EXEC_INV)
    uc SIG_UPC_RESET

#bank mrom
#addr OC_BLS
#d16 op_bls
#addr OC_BHI
#d16 op_bhi



;;;
;;; bge / blt - branch if greate or equal (unsigned >=), and branch if less than (unsigned <)
;;;

#bank acpu

op_bge:
    uc __branch_impl(SIG_EXEC_SEL_CARRY, 0)
    uc SIG_UPC_RESET

op_blt:
    uc __branch_impl(SIG_EXEC_SEL_CARRY, SIG_EXEC_INV)
    uc SIG_UPC_RESET

#bank mrom
#addr OC_BGE
#d16 op_bge
#addr OC_BLT
#d16 op_blt


