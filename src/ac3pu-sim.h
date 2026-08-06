#ifndef AC3PU_SIM_H
#define AC3PU_SIM_H 1

#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
    #define ntohll(x) __builtin_bswap64(x)
    #define htonll(x) __builtin_bswap64(x)
#else
    #define ntohll(x) (x)
    #define htonll(x) (x)
#endif

#define to_be(x) ntohl(x)

#define MAP_ROM_SIZE 256
#define RAM_SIZE 0x10000
#define UPROGRAM_SIZE 1024

#define UROM_FETCH 0x0000
#define UROM_IRQ   0x0010

#define RAM_ISR_RET_VEC 0x0002
#define RAM_ISR_ENTRY   0x0003

typedef uint32_t sig_t;

typedef enum {
    ALU_ADC,
    ALU_SBB,
    ALU_SHL,
    ALU_SHR,
    ALU_AND,
    ALU_OR,
    ALU_XOR,
} alu_op_t;

typedef enum {
    EXEC_ALWAYS = 0,
    EXEC_IF_CARRY = 1,
    EXEC_IF_ZERO = 2,
    EXEC_IF_ZERO_OR_NO_BORROW = 3,
    EXEC_IF_NEG = 7,
} exec_sel_t;

typedef enum {
    BUS_READ_SEL_PC = 0,
    BUS_READ_SEL_MAR,
    BUS_READ_SEL_MDR,
    BUS_READ_SEL_IR,
    BUS_READ_SEL_ACC,
    BUS_READ_SEL_FLAGS,
} bus_read_sel_t;

typedef enum {
    BUS_WRITE_SEL_PC = 0,
    BUS_WRITE_SEL_MAR,
    BUS_WRITE_SEL_MDR,
    BUS_WRITE_SEL_IR,
    BUS_WRITE_SEL_ACC,
    BUS_WRITE_SEL_ALU,
    BUS_WRITE_SEL_FLAGS,
    BUS_WRITE_SEL_ADDR_VEC,
    BUS_WRITE_SEL_ADDR_ISR,
} bus_write_sel_t;



typedef struct {

    sig_t bus_read_sel : 3;

    sig_t bus_write_sel : 4;
    sig_t bus_access : 1;

    sig_t upc_reset : 1;
    sig_t upc_from_mrom : 1;
    sig_t pc_inc : 1;
    sig_t pc_add_offset : 1;

    sig_t ram_read  : 1;
    sig_t ram_write : 1;
    sig_t           : 3; // padding for ALU

    sig_t flags_clear  : 1;
    sig_t flags_update : 1;
    sig_t flag_change  : 1;
    sig_t flag_value   : 1;
    sig_t flag_sel     : 2;

    sig_t exec_sel : 3;
    sig_t exec_inv : 1;
} cbits_ram_t;

typedef struct {

    sig_t bus_read_sel : 3;

    sig_t bus_write_sel : 4;
    sig_t bus_access : 1;

    sig_t upc_reset : 1;
    sig_t upc_from_mrom : 1;
    sig_t pc_inc : 1;
    sig_t pc_add_offset : 1;

    sig_t alu_op          : 3;
    sig_t alu_carry_value : 1;
    sig_t alu_carry_mux   : 1;

    sig_t flags_clear  : 1;
    sig_t flags_update : 1;
    sig_t flag_change  : 1;
    sig_t flag_value   : 1;
    sig_t flag_sel     : 2;

    sig_t exec_sel : 3;
    sig_t exec_inv : 1;
} cbits_alu_t;


typedef union {
    sig_t raw;
    cbits_ram_t ram;
    cbits_alu_t signals; // named signals for backwards compability
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
    uint8_t halt  : 1;
    uint8_t ie    : 1;
    uint8_t       : 2;
    uint8_t carry : 1;
    uint8_t zero  : 1;
    uint8_t       : 1;
    uint8_t neg   : 1;
} flags_t;

typedef struct {
    uint8_t low  : 4;
    uint8_t high : 4;
} nibble_t;

typedef union {
    uint8_t raw;
    nibble_t nibbles;
    flags_t  flags;
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


void print_cpu_state(int cycle, cpu_t *cpu);

int16_t alu(cpu_t *cpu, uinstruction_t uc, uint8_t *carry_out);

void tick(cpu_t *cpu, int cycle);

#endif
