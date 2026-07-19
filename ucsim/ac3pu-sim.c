#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <assert.h>

#define UROM_BIT_WIDTH 7
#define RAM_SIZE 256
#define UPROGRAM_SIZE 512

typedef struct {
    uint8_t pc_out : 1;
    uint8_t mar_in : 1;
    uint8_t mdr_out : 1;
    uint8_t ir_in : 1;
    uint8_t acc_in : 1;
    uint8_t pc_inc : 1;
    uint8_t ram_read : 1;
} cbits_t;

typedef union {
    uint8_t raw;
    cbits_t signals;
} uinstruction_t;

typedef struct {
    uint16_t pc;
    uint16_t mar;
    uint16_t mdr;
    uint16_t ir;
    uint16_t acc;
    uint16_t ram[256];
} cpu_t;


void print_cpu_state(int cycle, cpu_t *cpu) {
    printf("CYCLE:%03d | PC:0x%04X | MAR:0x%04X | MDR:0x%04X | IR:0x%04X | ACC:0x%04X\n",
           cycle, cpu->pc, cpu->mar, cpu->mdr, cpu->ir, cpu->acc);
}


void tick(cpu_t *cpu, uinstruction_t uc) {
    uint16_t bus = 0;
    int bus_drivers = 0;

    /* write to bus */
    if (uc.signals.pc_out) { bus = cpu->pc; bus_drivers++; }
    if (uc.signals.mdr_out) { bus = cpu->mdr; bus_drivers++; }

    /* check for bus conflicts */
    assert(bus_drivers <= 1 && "BUS-CONFLICT: parallel write to data bus detected");

    /* read from bus */
    if (uc.signals.mar_in) cpu->mar = bus;
    if (uc.signals.ir_in) cpu->ir = bus;
    if (uc.signals.acc_in) cpu->acc = bus;

    /* misc */
    if (uc.signals.ram_read) {
        cpu->mdr = cpu->ram[cpu->mar & (RAM_SIZE - 1)];
    }

    /* branch logic */
    if (uc.signals.pc_inc) {
        cpu->pc++;
    }
}


int main(int argc, const char ** argv) {

    if(argc < 3) {
        fprintf(stderr, "usage: %s <ucode-file.bin> <ram-file.bin>\n", argv[0]);
        return 1;
    }

    cpu_t cpu = {0};
    uinstruction_t ucode[UPROGRAM_SIZE] = {0};
    int ucode_len = 0;

    /* load ucode from file */
    FILE *u_file = fopen(argv[1], "rb");
    if(!u_file) {
        perror("Error opening ucode file");
        return 1;
    }

    ucode_len = fread(ucode, sizeof(uinstruction_t), UPROGRAM_SIZE, u_file);
    fclose(u_file);

    /* load ram from file */
    FILE *ram_file = fopen(argv[2], "rb");
    if(!ram_file) {
        perror("Error opening ram file");
        return 1;
    }
    fread(cpu.ram, sizeof(uint16_t), RAM_SIZE, ram_file);
    fclose(ram_file);

    int cycle = 0;
    print_cpu_state(cycle, &cpu);

    for (int upc = 0; upc < ucode_len; upc++) {
        cycle++;
        tick(&cpu, ucode[upc]);
        print_cpu_state(cycle, &cpu);
    }

    return 0;

}
