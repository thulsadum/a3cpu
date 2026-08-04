#ifndef AC3DEV_H
#define AC3DEV_H 1

#ifndef AC3DEV_NO_DEVS
#define AC3DEV_NO_DEVS 16
#endif

#ifndef AC3DEV_MMIO_BEGIN
#define AC3DEV_MMIO_BEGIN 0x8000
#endif

typedef struct {
    int length_exp : 4;
    int can_read : 1;
    int can_write : 1;
} device_descriptor_t;

typedef uint16_t (*read_t)(uint16_t offset);
typedef void     (*write_t)(uint16_t offset, uint16_t value);
typedef int      (*tick_t)(int cycle);

typedef struct {
    uint16_t begin;
    uint16_t end;
    device_descriptor_t desc;
    int irq : 1;
    read_t read;
    write_t write;
    tick_t tick;
} device_handler_t;


int hdl2stat(device_handler_t *hdl);

int register_device(device_handler_t * hdl);

int is_pending_irq();
int handle_tick(int cycle);
int handle_read (uint16_t addr, uint16_t *val);
int handle_write(uint16_t addr, uint16_t val);

#endif
