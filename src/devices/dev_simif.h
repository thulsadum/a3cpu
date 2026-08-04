#ifndef DEV_SIMIF_H
#define DEV_SIMIF_H 1

#include "ac3dev.h"

#define SIMIF_MAGIC 0x53
#define SIMIF_LENGTH_EXP 4

extern device_handler_t simif_hdl;

device_handler_t *simif_init(void);

uint16_t simif_read(uint16_t offset);
void simif_write(uint16_t offset, uint16_t val);
int simif_tick(int);

typedef enum {
    SIMIF_STATUS = 0,
    SIMIF_EXIT,
    SIMIF_PUTC,
    SIMIF_GETC,
    SIMIF_TIMER,
} simif_offset_t;

#endif
