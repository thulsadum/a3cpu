#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <arpa/inet.h>

#include <stdint.h>

#include "ac3pu-sim.h"
#include "ac3dev.h"

#include "devices/dev_simif.h"

static uint16_t PRINT_TRACE_BEGIN = 0xffff;
static uint16_t PRINT_TRACE_END   = 0xffff;
static uint16_t MMIO_BEGIN   = 0x8000;
static int SILENT = 0;
static int REGISTER_DEFAULT_DEVICES = 1;




void print_cpu_state(int cycle, cpu_t *cpu) {
    if(SILENT) return;
    printf("CYCLE:%03d | PC:0x%04X | MAR:0x%04X | MDR:0x%04X | IR:0x%04X | ACC:0x%04X | FLAGS:0x%04X\n",
           cycle, cpu->pc, cpu->mar, cpu->mdr, cpu->ir.raw, cpu->acc, cpu->flags.raw);
}



int16_t alu(cpu_t *cpu, uinstruction_t uc, uint8_t *carry_out) {
    uint16_t a,b;
    uint16_t alu_carry;
    uint32_t result = 0;

    a = cpu->acc;
    b = cpu->mdr;

    switch (uc.signals.alu_op) {
    case ALU_ADC:
        alu_carry = uc.signals.alu_carry_value;
        if (uc.signals.alu_carry_mux) {
            alu_carry = cpu->flags.flags.carry;
        }
        result = a+b+alu_carry;
        *carry_out = (result > 0xffff);
        return result;
    case ALU_SBB:
        alu_carry = uc.signals.alu_carry_value;
        if (uc.signals.alu_carry_mux) {
            alu_carry = cpu->flags.flags.carry;
        }
        result = a + (0xffff & ~b) + alu_carry;
        *carry_out = (result > 0xffff);
        return result;
    case ALU_SHL:
        return a<<b;
    case ALU_SHR:
        return a>>b;
    case ALU_AND:
        return a & b;
    case ALU_OR:
        return a | b;
    case ALU_XOR:
        return a ^ b;
    default:
        assert(0 && "Undefined ALU operation");
    }

    return 0;
}



static int is_exec_enable(cpu_t *cpu, uinstruction_t uc) {
    switch (uc.signals.exec_sel) {
        case EXEC_ALWAYS:
            return 1 ^ uc.signals.exec_inv;
        case EXEC_IF_CARRY:
            return cpu->flags.flags.carry ^ uc.signals.exec_inv;
        case EXEC_IF_ZERO:
            return cpu->flags.flags.zero ^ uc.signals.exec_inv;
        case EXEC_IF_NEG:
            return cpu->flags.flags.neg ^ uc.signals.exec_inv;
        case EXEC_IF_ZERO_OR_NO_BORROW:
            return (cpu->flags.flags.zero | !cpu->flags.flags.carry) ^ uc.signals.exec_inv;
        default:
            fprintf(stderr, "uc.signals.exec_sel: %03b (%d)\n",uc.signals.exec_sel, uc.signals.exec_sel);
            assert(0 && "Undefined exec conditional code");
            return 0;
    }
}



static int write_bus(cpu_t *cpu, uinstruction_t uc, uint16_t *pbus, uint8_t* alu_carry_out) {
    int bus_drivers = 0;
    int bus = 0;

    if (!uc.signals.bus_write_en) return 0;

    switch (uc.signals.bus_write_sel) {
        case BUS_WRITE_SEL_PC: bus = cpu->pc; bus_drivers++; break;
        case BUS_WRITE_SEL_MAR: bus = cpu->mar; bus_drivers++; break;
        case BUS_WRITE_SEL_MDR: bus = cpu->mdr; bus_drivers++; break;
        case BUS_WRITE_SEL_ACC: bus = cpu->acc; bus_drivers++; break;
        case BUS_WRITE_SEL_IR: bus = cpu->ir.simple.immediate; bus_drivers++; break;
        case BUS_WRITE_SEL_ALU: bus = alu(cpu, uc, alu_carry_out); bus_drivers++; break;
        case BUS_WRITE_SEL_FLAGS: bus = cpu->flags.raw & 0xff; bus_drivers++; break;
        case BUS_WRITE_SEL_ADDR_VEC: bus = RAM_ISR_RET_VEC; bus_drivers++; break;
        case BUS_WRITE_SEL_ADDR_ISR: bus = RAM_ISR_ENTRY; bus_drivers++; break;
        default:
            assert(0 && "Illegal bus_write_sel value.");
    }

    *pbus = bus;

    return bus_drivers;
}



static void handle_flags(cpu_t *cpu, uinstruction_t uc, uint8_t alu_carry_out, uint16_t bus) {

    const uint8_t flag_offsets[4] = { 0, 1, 4, 5 };

    if(uc.signals.flags_clear) {
        cpu->flags.raw = 0;
    }

    if(uc.signals.flags_update) {
        cpu->flags.flags.zero = (bus == 0);
        cpu->flags.flags.carry = alu_carry_out;
        cpu->flags.flags.neg = ((bus & 0x8000) != 0);
    }

    if(uc.signals.flag_change) {

        if(uc.signals.flag_value) {
            // flag set
            cpu->flags.raw |= 1 << flag_offsets[uc.signals.flag_sel];
        } else {
            // flag cleared
            cpu->flags.raw &= 0xff ^ (1 << flag_offsets[uc.signals.flag_sel]);
        }
    }
}



static void bus_read(cpu_t *cpu, uinstruction_t uc, uint16_t bus) {
    if(!uc.signals.bus_read_en) return;
    switch(uc.signals.bus_read_sel) {
        case BUS_READ_SEL_PC:
            cpu->pc = bus;
            break;
        case BUS_READ_SEL_MAR:
            cpu->mar = bus;
            break;
        case BUS_READ_SEL_MDR:
            cpu->mdr = bus;
            break;
        case BUS_READ_SEL_IR:
            cpu->ir = (cinstruction_t)bus;
            break;
        case BUS_READ_SEL_ACC:
            cpu->acc = bus;
            break;
        case BUS_READ_SEL_FLAGS:
            cpu->flags.raw = (bus & 0xff);
            break;
        default:
            assert(0 && "Illegal bus_read_sel value.");
    }
}



static void handle_memory_read(cpu_t *cpu) {
    if(cpu->mar < MMIO_BEGIN) {
        cpu->mdr = cpu->ram[cpu->mar & (RAM_SIZE - 1)];
    } else {
        if (handle_read(cpu->mar, &(cpu->mdr))) {
            /* do panic! */
        }
    }

    if(PRINT_TRACE_BEGIN <= cpu->mar && cpu->mar <= PRINT_TRACE_END) {
        printf("mem[0x%04X]> 0x%04X\n", cpu->mar, cpu->mdr);
    }
}



static void handle_memory_write(cpu_t *cpu) {
    if(PRINT_TRACE_BEGIN <= cpu->mar && cpu->mar <= PRINT_TRACE_END) {
        printf("mem[0x%04X]< 0x%04X\n", cpu->mar, cpu->mdr);
    }
    if(cpu->mar < MMIO_BEGIN) {
        cpu->ram[cpu->mar & (RAM_SIZE - 1)] = cpu->mdr;
    } else {
        if (handle_write(cpu->mar, cpu->mdr)) {
            /* do panic! */
        }
    }
}



static void handle_memory_access(cpu_t *cpu, uinstruction_t uc) {

    if (uc.signals.ram_read) {
        handle_memory_read(cpu);
    }

    if (uc.signals.ram_write) {
        handle_memory_write(cpu);
    }

}



void tick(cpu_t *cpu, int cycle) {

    uint16_t bus = 0;
    uinstruction_t uc = cpu->urom[cpu->upc];
    uint8_t alu_carry_out = 0;

    /* handling cpu signals */

    if (cpu->flags.flags.halt) return;


    /* determine if ucode is executred */
    if (!is_exec_enable(cpu,uc)) {
        cpu->upc++;
        return;
    }

    /* write to bus */
    int bus_drivers = write_bus(cpu, uc, &bus, &alu_carry_out);
    /* check for bus conflicts */
    assert(bus_drivers <= 1 && "BUS-CONFLICT: parallel write to data bus detected");

    /* flag manipulation */
    handle_flags(cpu, uc, alu_carry_out, bus);

    /* read from bus */
    bus_read(cpu, uc, bus);

    /* misc */
    /* tick hw */
    handle_tick(cycle);
    /* handle memory access */
    handle_memory_access(cpu, uc);

    /* branch logic (i.e. relative jumps) */
    if (uc.signals.pc_inc) {
        cpu->pc++;
    }

    if (uc.signals.pc_add_offset) {
        cpu->pc += (int8_t) cpu->ir.simple.immediate;
    }

    /* upc management */
    cpu->upc++;
    if (uc.signals.upc_reset) {
        /* reset upc -> jump to fetch or irq */
        int pending_irq = is_pending_irq();
        /* hardware intercept for IRQ */
        cpu->upc = (cpu->flags.flags.ie && pending_irq) ? UROM_IRQ : UROM_FETCH;
    }
    if (uc.signals.upc_from_mrom) {
        /* load upc from mapping rom */
        cpu->upc = cpu->mrom[cpu->ir.simple.opcode];
    }
}


static int parse_args(int argc, const char ** argv) {
    for(int i = 0; i < argc; i++) {
        if(strcmp("--silent", argv[i]) == 0) SILENT = 1;
        if(strcmp("--mt-begin",argv[i]) == 0 && i + 1 < argc) {
            PRINT_TRACE_BEGIN = strtol(argv[i+1], NULL, 0);
            i++;
        }
        if(strcmp("--mt-end",argv[i]) == 0 && i + 1 < argc) {
            PRINT_TRACE_END = strtol(argv[i+1], NULL, 0);
            i++;
        }
    }
    return 0;
}



static int register_default_devices() {
    device_handler_t *hdl;
    hdl = simif_init();
    if(!hdl) return 1;
    register_device(hdl);

    return 0;
}



int main(int argc, const char ** argv) {

    if(argc < 3) {
        fprintf(stderr, "usage: %s <ucode-file.bin> <ram-file.bin>\n", argv[0]);
        return 1;
    }

    int ret = parse_args(argc - 3, argv + 3);
    if(ret) return ret;

    if(REGISTER_DEFAULT_DEVICES) ret = register_default_devices();
    if(ret) return ret;

    cpu_t cpu = {0};
    int ucode_len = 0;

    /* load mapping rom and ucode from a single file */
    FILE *u_file = fopen(argv[1], "rb");
    if(!u_file) {
        perror("Error opening ucode file");
        return 1;
    }
    /* read mapping rom first */
    if (fread(cpu.mrom, sizeof(uint16_t), MAP_ROM_SIZE, u_file) < MAP_ROM_SIZE) {
        fprintf(stderr, "error reading ucode file: %s\n", "end of file reached unexpectedly.");
        fclose(u_file);
        return 1;
    }
    ucode_len = fread(cpu.urom, sizeof(uinstruction_t), UPROGRAM_SIZE, u_file);
    fclose(u_file);

    for(int i = 0; i < MAP_ROM_SIZE; i++) {
        cpu.mrom[i] = ntohs(cpu.mrom[i]);
    }
    for(int i = 0; i < ucode_len; i++) {
        cpu.urom[i].raw = ntohll(cpu.urom[i].raw);
    }

    /* load ram from file */
    FILE *ram_file = fopen(argv[2], "rb");
    if(!ram_file) {
        perror("Error opening ram file");
        return 1;
    }
    fread(cpu.ram, sizeof(uint16_t), RAM_SIZE, ram_file);
    fclose(ram_file);

    for(int i = 0; i < RAM_SIZE; i++) {
        cpu.ram[i] = ntohs(cpu.ram[i]);
    }

    int cycle = 0;
    print_cpu_state(cycle, &cpu);

    for (cpu.upc = 0; cpu.upc < ucode_len && cpu.flags.flags.halt == 0; ) {
        cycle++;
        tick(&cpu, cycle);
        print_cpu_state(cycle, &cpu);
    }

    if(cpu.flags.flags.halt) {
        if ((cpu.flags.raw & 0xf0) > 3) {
            printf("!!! CPU PANIC !!!");
            return 1;
        } else {
            printf("--- CPU HALTED ---");
        }
    }

    return 0;

}
