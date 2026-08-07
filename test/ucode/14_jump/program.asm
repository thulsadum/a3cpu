#include "../../../asmdef/ac3puasm_def.asm"


jmp far_away

end:    halt

sub_routine: #res 1 ; reserve a word for return address
    xori 0xf0f0
    ret.l sub_routine



#addr 0x200
far_away:
    ldi 0xf0
    shli 8
    ori 0xf0
    jal.l sub_routine
    ldi 0x02

.test_foo:
    cmpi 0x01
    bne .test_bar
    ldi .switch_tab + 0
    lia
    jpa ; jump via acc

.test_bar:
    cmpi 0x02
    bne .test_baz
    ldi .switch_tab + 1
    lia
    jpa ; jump via acc

.test_baz:
    cmpi 0x03
    bne .test_bar
    ldi .switch_tab + 2
    lia
    jpa ; jump via acc
    jmp end

.test_fail:
    jmp end

.case_foo:
    ldi 0x77
    jmp end
.case_bar:
    ldi 0x00
    jmp end
.case_baz:
    ldi 0xff
    jmp end

.switch_tab:
    #d16 .case_foo
    #d16 .case_bar
    #d16 .case_baz
