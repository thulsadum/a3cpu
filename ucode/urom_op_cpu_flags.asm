#once

#include "urom_def.asm"
#include "urom_fetch.asm"
#include "urom_op_simple.asm"
#include "urom_op_alu.asm"
#include "urom_op_alu_short.asm"
#include "../asmdef/ac3puasm_opcodes.asm"


;       FLAG register:
; | high nibble: ALU | low nibble: CPU |
; |      N - Z C     |    - - IE HLT   |
;
; ALU:
; N: Negative
; Z: Zero
; C: Carry
;
; CPU:
; IE: Interrupts enabled
; HLT: Halt -> use ALU flags for error indication (all cleared -> regular exit)

#bank acpu
op_sei:
    uc set_flag(SIG_FLAG_SEL_IE,1) | SIG_UPC_RESET
op_cli:
    uc set_flag(SIG_FLAG_SEL_IE,0) | SIG_UPC_RESET

#bank mrom
#addr OC_FLAG_IE_1
#d16 op_sei
#addr OC_FLAG_IE_0
#d16 op_cli

;;;
;;; tfa / taf: flag transfer
;;;

#bank acpu
op_tfa:
    uc SIG_FLAGS_OUT | SIG_ACC_IN | SIG_UPC_RESET
op_taf:
    uc SIG_ACC_OUT | SIG_FLAGS_IN | SIG_UPC_RESET

#bank mrom
#addr OC_TFA
#d16 op_tfa
#addr OC_TAF
#d16 op_taf



;;;
;;; tst: Test
;;;

#bank acpu
op_tst:
    uc SIG_FLAGS_UPDATE | SIG_ACC_OUT | SIG_MAR_IN | SIG_UPC_RESET

#bank mrom
#addr OC_TST
#d16 op_tst
