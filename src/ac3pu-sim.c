#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>
#include <arpa/inet.h>

#define MAP_ROM_SIZE 256
#define RAM_SIZE 256
#define UPROGRAM_SIZE 512

typedef uint32_t sig_t;

typedef enum {
    ALU_ADD = 0,
    ALU_ADC,
    ALU_SUB,
    ALU_SBB,
    ALU_SHL,
    ALU_SHR,
    ALU_AND,
    ALU_OR,
    ALU_XOR,
} alu_op_t;

typedef enum {
    FLAG_CARRY = 0,
} flag_sel_t;

typedef struct {
    sig_t pc_out : 1;
    sig_t mar_in : 1;
    sig_t mdr_in : 1;
    sig_t mdr_out : 1;
    sig_t ir_in : 1;
    sig_t acc_in : 1;
    sig_t acc_out : 1;
    sig_t alu_out : 1;
    sig_t upc_reset :1;
    sig_t upc_from_mrom :1;
    sig_t pc_inc : 1;
    sig_t ram_read : 1;
    sig_t ram_write : 1;
    alu_op_t alu_op : 4;
    sig_t alu_carry_value : 1;
    sig_t alu_carry_mux : 1;
    sig_t flag_change : 1;
    sig_t flag_value : 1;
    flag_sel_t flag_sel : 2;
} cbits_t;

typedef union {
    sig_t raw;
    cbits_t signals;
} uinstruction_t;

typedef struct {
    uint8_t immediate : 8;
    uint8_t opcode : 8;
} sinst_t;

typedef union {
    uint16_t raw;
    sinst_t simple;
} cinstruction_t;

typedef struct {
    uint16_t halt:1;
    uint16_t carry:1;
} flags_t;

typedef union {
    uint16_t raw;
    flags_t flags;
} flag_register_t;

typedef struct {
    uint16_t pc;
    uint16_t mar;
    uint16_t mdr;
    cinstruction_t ir;
    uint16_t acc;
    uint16_t upc;
    flag_register_t flags;
    uint16_t  mrom[MAP_ROM_SIZE];
    uinstruction_t urom[UPROGRAM_SIZE];
    uint16_t ram[RAM_SIZE];
} cpu_t;


void print_cpu_state(int cycle, cpu_t *cpu) {
    printf("CYCLE:%03d | PC:0x%04X | MAR:0x%04X | MDR:0x%04X | IR:0x%04X | ACC:0x%04X | FLAGS:0x%04X\n",
           cycle, cpu->pc, cpu->mar, cpu->mdr, cpu->ir.raw, cpu->acc, cpu->flags.raw);
}

int16_t alu(cpu_t *cpu, uinstruction_t uc) {
    uint16_t a,b;
    uint16_t alu_carry;

    a = cpu->acc;
    b = cpu->mdr;

    switch (uc.signals.alu_op) {
    case ALU_ADC:
        alu_carry = uc.signals.alu_carry_value;
        if (uc.signals.alu_carry_mux) {
            alu_carry = cpu->flags.flags.carry;
        }
        return a+b+alu_carry;
    case ALU_SUB:
        return a-b;
    case ALU_SBB:
        alu_carry = uc.signals.alu_carry_value;
        if (uc.signals.alu_carry_mux) {
            alu_carry = cpu->flags.flags.carry;
        }
        return a + ~b + (!alu_carry);
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
        assert(false && "Undefined ALU operation");
    }

    return 0;
}

void tick(cpu_t *cpu) {
    uint16_t bus = 0;
    int bus_drivers = 0;
    uinstruction_t uc = cpu->urom[cpu->upc];

    /* handling cpu signals */
    if (cpu->flags.flags.halt) return;

    /* flag manipulation */
    if(uc.signals.flag_change) {
        if(uc.signals.flag_value) {
            // flag set
            cpu->flags.raw |= 1 << uc.signals.flag_sel;
        } else {
            // flag cleared
            cpu->flags.raw &= 0xffff ^ (1 << uc.signals.flag_sel);
        }
    }

    /* write to bus */
    if (uc.signals.pc_out) { bus = cpu->pc; bus_drivers++; }
    if (uc.signals.mdr_out) { bus = cpu->mdr; bus_drivers++; }
    if (uc.signals.acc_out) { bus = cpu->acc; bus_drivers++; }
    if (uc.signals.alu_out) { bus = alu(cpu, uc); bus_drivers++; }

    /* check for bus conflicts */
    assert(bus_drivers <= 1 && "BUS-CONFLICT: parallel write to data bus detected");

    /* read from bus */
    if (uc.signals.mar_in) cpu->mar = bus;
    if (uc.signals.ir_in) cpu->ir = (cinstruction_t)bus;
    if (uc.signals.acc_in) cpu->acc = bus;
    if (uc.signals.mdr_in) cpu->mdr = bus;

    /* misc */
    if (uc.signals.ram_read) {
        cpu->mdr = cpu->ram[cpu->mar & (RAM_SIZE - 1)];
    }
    if (uc.signals.ram_write) {
        cpu->ram[cpu->mar & (RAM_SIZE - 1)] = cpu->mdr;
    }

    /* branch logic */
    if (uc.signals.pc_inc) {
        cpu->pc++;
    }

    /* upc management */
    cpu->upc++;
    if (uc.signals.upc_reset) {
        /* reset upc -> jump to fetch */
        cpu->upc = 0;
    }
    if (uc.signals.upc_from_mrom) {
        /* load upc from mapping rom */
        cpu->upc = cpu->mrom[cpu->ir.simple.opcode];
    }
}


int main(int argc, const char ** argv) {

    if(argc < 3) {
        fprintf(stderr, "usage: %s <ucode-file.bin> <ram-file.bin>\n", argv[0]);
        return 1;
    }

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
        return 1;
    }
    ucode_len = fread(cpu.urom, sizeof(uinstruction_t), UPROGRAM_SIZE, u_file);
    fclose(u_file);

    for(int i = 0; i < MAP_ROM_SIZE; i++) {
        cpu.mrom[i] = ntohs(cpu.mrom[i]);
    }
    for(int i = 0; i < ucode_len; i++) {
        cpu.urom[i].raw = ntohl(cpu.urom[i].raw);
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
        tick(&cpu);
        print_cpu_state(cycle, &cpu);
    }

    if(cpu.flags.flags.halt) {
        printf("--- CPU HALTED ---");
    }

    return 0;

}
