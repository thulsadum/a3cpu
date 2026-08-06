; Just the Fetch-Phase

#once

#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "urom_op_load_store.asm"
#include "../asmdef/ac3puasm_opcodes.asm"

#bank acpu

#ruledef alu_helper {
    __alu_bin_imm({alu_op},{alu_carry},{write_back}) => asm {
        uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
        uc SIG_RAM_READ
        uc {write_back} | SIG_ALU_OUT | SIG_FLAGS_UPDATE | {alu_op} | {alu_carry} | SIG_UPC_RESET
    }

    __alu_bin_dir({alu_op},{alu_carry},{write_back}) => asm {
        uc SIG_PC_INC | SIG_PC_OUT | SIG_MAR_IN
        uc SIG_RAM_READ
        uc SIG_MAR_IN | SIG_MDR_OUT
        uc SIG_RAM_READ
        uc {write_back} | SIG_ALU_OUT | SIG_FLAGS_UPDATE | {alu_op} | {alu_carry} | SIG_UPC_RESET
    }

    __alu_bin_imm({alu_op},{alu_carry}) => asm {
        __alu_bin_imm({alu_op},{alu_carry},SIG_ACC_IN)
    }

    __alu_bin_dir({alu_op},{alu_carry}) => asm {
        __alu_bin_dir({alu_op},{alu_carry},SIG_ACC_IN)
    }

    __alu_bin_imm({alu_op}) => asm {
        __alu_bin_imm({alu_op},0)
    }

    __alu_bin_dir({alu_op}) => asm {
        __alu_bin_dir({alu_op},0)
    }
}

; Register ACC -> Op A
; Register MDR -> Op B

;;;
;;; ADD
;;;
#bank acpu
op_addi: __alu_bin_imm(SIG_ALU_OP_ADC,SIG_ALU_CARRY_0)
op_add: __alu_bin_dir(SIG_ALU_OP_ADC,SIG_ALU_CARRY_0)

; set addresses of uprogs for opcodes into mapping rom
#bank mrom
#addr OC_ADDI
#d16 op_addi
#addr OC_ADD
#d16 op_add


;;;
;;; ADC
;;;
#bank acpu
op_adci: __alu_bin_imm(SIG_ALU_OP_ADC,SIG_ALU_CARRY_FLAG)
op_adc: __alu_bin_dir(SIG_ALU_OP_ADC,SIG_ALU_CARRY_FLAG)

; set addresses of uprogs for opcodes into mapping rom
#bank mrom
#addr OC_ADCI
#d16 op_adci
#addr OC_ADC
#d16 op_adc



;;;
;;; SUB
;;;
#bank acpu
op_subi: __alu_bin_imm(SIG_ALU_OP_SBB,SIG_ALU_CARRY_1)
op_sub: __alu_bin_dir(SIG_ALU_OP_SBB,SIG_ALU_CARRY_1)

#bank mrom
#addr OC_SUBI
#d16 op_subi
#addr OC_SUB
#d16 op_sub



;;;
;;; SBB
;;;
#bank acpu
op_sbbi: __alu_bin_imm(SIG_ALU_OP_SBB,SIG_ALU_CARRY_FLAG)
op_sbb: __alu_bin_dir(SIG_ALU_OP_SBB,SIG_ALU_CARRY_FLAG)

; set addresses of uprogs for opcodes into mapping rom
#bank mrom
#addr OC_SBBI
#d16 op_sbbi
#addr OC_SBB
#d16 op_sbb



;;;
;;; SHL
;;;
#bank acpu
op_shli: __alu_bin_imm(SIG_ALU_OP_SHL)
op_shl: __alu_bin_dir(SIG_ALU_OP_SHL)

#bank mrom
#addr OC_SHLI
#d16 op_shli
#addr OC_SHL
#d16 op_shl



;;;
;;; SHR
;;;
#bank acpu
op_shri: __alu_bin_imm(SIG_ALU_OP_SHR)
op_shr: __alu_bin_dir(SIG_ALU_OP_SHR)

#bank mrom
#addr OC_SHRI
#d16 op_shri
#addr OC_SHR
#d16 op_shr





;;;
;;; AND
;;;
#bank acpu
op_andi: __alu_bin_imm(SIG_ALU_OP_AND)
op_and: __alu_bin_dir(SIG_ALU_OP_AND)

#bank mrom
#addr OC_ANDI
#d16 op_andi
#addr OC_AND
#d16 op_and





;;;
;;; OR
;;;
#bank acpu
op_ori: __alu_bin_imm(SIG_ALU_OP_OR)
op_or: __alu_bin_dir(SIG_ALU_OP_OR)

#bank mrom
#addr OC_ORI
#d16 op_ori
#addr OC_OR
#d16 op_or





;;;
;;; XOR
;;;
#bank acpu
op_xori: __alu_bin_imm(SIG_ALU_OP_XOR)
op_xor: __alu_bin_dir(SIG_ALU_OP_XOR)

#bank mrom
#addr OC_XORI
#d16 op_xori
#addr OC_XOR
#d16 op_xor



;;;
;;; CMPI / CMP
;;;
#bank acpu
op_cmpi: __alu_bin_imm(SIG_ALU_OP_SBB,SIG_ALU_CARRY_1,SIG_MAR_IN)
op_cmp: __alu_bin_dir(SIG_ALU_OP_SBB,SIG_ALU_CARRY_1,SIG_MAR_IN)

#bank mrom
#addr OC_CMPI
#d16 op_cmpi
#addr OC_CMP
#d16 op_cmp



