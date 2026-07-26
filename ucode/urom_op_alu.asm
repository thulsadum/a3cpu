; Just the Fetch-Phase

#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "urom_op_load_store.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

#bank acpu

#ruledef alu_helper {
    __alu_bin_imm({alu_op}) => asm {
        uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
        uc SIG_RAM_READ
        uc SIG_ALU_OUT | SIG_ACC_IN | {alu_op} | SIG_UPC_RESET
    }

    __alu_bin_dir({alu_op}) => asm {
        uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
        uc SIG_RAM_READ
        uc SIG_MAR_IN | SIG_MDR_OUT
        uc SIG_RAM_READ
        uc SIG_ALU_OUT | SIG_ACC_IN | {alu_op} | SIG_UPC_RESET
    }
}

; Register ACC -> Op A
; Register MDR -> Op B

op_addi: __alu_bin_imm(SIG_ALU_OP_ADD)
op_add: __alu_bin_dir(SIG_ALU_OP_ADD)

op_subi: __alu_bin_imm(SIG_ALU_OP_SUB)
op_sub: __alu_bin_dir(SIG_ALU_OP_SUB)

op_shli: __alu_bin_imm(SIG_ALU_OP_SHL)
op_shl: __alu_bin_dir(SIG_ALU_OP_SHL)

op_shri: __alu_bin_imm(SIG_ALU_OP_SHR)
op_shr: __alu_bin_dir(SIG_ALU_OP_SHR)

op_andi: __alu_bin_imm(SIG_ALU_OP_AND)
op_and: __alu_bin_dir(SIG_ALU_OP_AND)



; set addresses of uprogs for opcodes into mapping rom

#bank mrom

#addr OC_ADDI
#d16 op_addi
#addr OC_ADD
#d16 op_add

#addr OC_SUBI
#d16 op_subi
#addr OC_SUB
#d16 op_sub

#addr OC_SHLI
#d16 op_shli
#addr OC_SHL
#d16 op_shl

#addr OC_SHRI
#d16 op_shri
#addr OC_SHR
#d16 op_shr

#addr OC_ANDI
#d16 op_andi
#addr OC_AND
#d16 op_and

