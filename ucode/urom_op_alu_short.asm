#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "urom_op_alu.asm"
#include "urom_op_alu_flags.asm"
#include "../asmdef/ac3puasm_opcodes.asm"


#ruledef alu_short_words {
  __alu_bin_imm8({alu_op},{alu_carry}) => asm {
    uc SIG_MDR_IN | SIG_IR_IMM8_OUT
    uc SIG_ACC_IN | SIG_ALU_OUT | {alu_op} | {alu_carry} | SIG_UPC_RESET
  }
}

;;;
;;; short word alu instructions
;;;

#bank acpu
op_addi8: __alu_bin_imm8(SIG_ALU_OP_ADC,SIG_ALU_CARRY_0)
op_adci8: __alu_bin_imm8(SIG_ALU_OP_ADC,SIG_ALU_CARRY_FLAG)

op_subi8: __alu_bin_imm8(SIG_ALU_OP_SBB, SIG_ALU_CARRY_1)
op_sbbi8: __alu_bin_imm8(SIG_ALU_OP_SBB, SIG_ALU_CARRY_FLAG)

op_shli8: __alu_bin_imm8(SIG_ALU_OP_SHL,0)
op_shri8: __alu_bin_imm8(SIG_ALU_OP_SHR,0)

#bank mrom
#addr OC_ADDI8
#d16 op_addi8
#addr OC_ADCI8
#d16 op_adci8
#addr OC_SUBI8
#d16 op_subi8
#addr OC_SBBI8
#d16 op_sbbi8
#addr OC_SHLI8
#d16 op_shli8
#addr OC_SHRI8
#d16 op_shri8
