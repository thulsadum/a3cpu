#once
#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "urom_op_alu.asm"
#include "urom_op_alu_flags.asm"
#include "../asmdef/ac3puasm_opcodes.asm"


#ruledef alu_short_words {
  __alu_bin_imm8({alu_op},{alu_carry},{write_back}) => asm {
    uc SIG_MDR_IN | SIG_IR_IMM8_OUT
    uc SIG_ALU_OUT | {write_back} | SIG_FLAGS_UPDATE | {alu_op} | {alu_carry} | SIG_UPC_RESET
  }
  __alu_bin_imm8({alu_op},{alu_carry}) => asm {
    __alu_bin_imm8({alu_op},{alu_carry},SIG_ACC_IN)
  }

  __alu_bin_dir_zp({alu_op},{alu_carry},{write_back}) => asm {
        uc SIG_IR_IMM8_OUT | SIG_MAR_IN
        uc SIG_RAM_READ
        uc {write_back} | SIG_ALU_OUT | SIG_FLAGS_UPDATE | {alu_op} | {alu_carry} | SIG_UPC_RESET
  }

  __alu_bin_dir_zp({alu_op},{alu_carry}) => asm {
    __alu_bin_dir_zp({alu_op},{alu_carry},SIG_ACC_IN)
  }
}

;;;
;;; short word alu instructions
;;;

#bank acpu
op_addi8: __alu_bin_imm8(SIG_ALU_OP_ADC,SIG_ALU_CARRY_0)
op_adci8: __alu_bin_imm8(SIG_ALU_OP_ADC,SIG_ALU_CARRY_FLAG)

#bank mrom
#addr OC_ADDI8
#d16 op_addi8
#addr OC_ADCI8
#d16 op_adci8


#bank acpu
op_subi8: __alu_bin_imm8(SIG_ALU_OP_SBB, SIG_ALU_CARRY_1)
op_sbbi8: __alu_bin_imm8(SIG_ALU_OP_SBB, SIG_ALU_CARRY_FLAG)
op_cmpi8: __alu_bin_imm8(SIG_ALU_OP_SBB, SIG_ALU_CARRY_1, SIG_MAR_IN)

#bank mrom
#addr OC_SUBI8
#d16 op_subi8
#addr OC_CMPI8
#d16 op_cmpi8
#addr OC_SBBI8
#d16 op_sbbi8


#bank acpu
op_shli8: __alu_bin_imm8(SIG_ALU_OP_SHL,SIG_ALU_CARRY_0)
op_shri8: __alu_bin_imm8(SIG_ALU_OP_SHR,SIG_ALU_CARRY_0)

#bank mrom
#addr OC_SHLI8
#d16 op_shli8
#addr OC_SHRI8
#d16 op_shri8


#bank acpu
op_addz: __alu_bin_dir_zp(SIG_ALU_OP_ADC,SIG_ALU_CARRY_0)
op_adcz: __alu_bin_dir_zp(SIG_ALU_OP_ADC,SIG_ALU_CARRY_FLAG)

#bank mrom
#addr OC_ADDZ
#d16 op_addz
#addr OC_ADCZ
#d16 op_adcz

#bank acpu
op_subz: __alu_bin_dir_zp(SIG_ALU_OP_SBB,SIG_ALU_CARRY_1)
op_sbbz: __alu_bin_dir_zp(SIG_ALU_OP_SBB,SIG_ALU_CARRY_FLAG)
op_cmpz: __alu_bin_dir_zp(SIG_ALU_OP_SBB,SIG_ALU_CARRY_1,SIG_MAR_IN)

#bank mrom
#addr OC_SUBZ
#d16 op_subz
#addr OC_SBBZ
#d16 op_sbbz
#addr OC_CMPZ
#d16 op_cmpz

#bank acpu
op_shlz: __alu_bin_dir_zp(SIG_ALU_OP_SHL,SIG_ALU_CARRY_0)
op_shrz: __alu_bin_dir_zp(SIG_ALU_OP_SHR,SIG_ALU_CARRY_0)

#bank mrom
#addr OC_SHLZ
#d16 op_shlz
#addr OC_SHRZ
#d16 op_shrz



#bank acpu
op_andz: __alu_bin_dir_zp(SIG_ALU_OP_AND,SIG_ALU_CARRY_0)
op_orz: __alu_bin_dir_zp(SIG_ALU_OP_OR,SIG_ALU_CARRY_0)
op_xorz: __alu_bin_dir_zp(SIG_ALU_OP_XOR,SIG_ALU_CARRY_0)

#bank mrom
#addr OC_ANDZ
#d16 op_andz
#addr OC_ORZ
#d16 op_orz
#addr OC_XORZ
#d16 op_xorz

#bank acpu
op_andi8: __alu_bin_imm8(SIG_ALU_OP_AND,SIG_ALU_CARRY_0)
op_ori8: __alu_bin_imm8(SIG_ALU_OP_OR,SIG_ALU_CARRY_0)
op_xori8: __alu_bin_imm8(SIG_ALU_OP_XOR,SIG_ALU_CARRY_0)

#bank mrom
#addr OC_ANDI8
#d16 op_andi8
#addr OC_ORI8
#d16 op_ori8
#addr OC_XORI8
#d16 op_xori8
