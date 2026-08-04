#ifndef DEV_SIMIF_H
#define DEV_SIMIF_H 1

#include "ac3dev.h"

extern device_handler_t simif_hdl;

device_handler_t *simif_init(void);

uint16_t simif_read(uint16_t offset);
void simif_write(uint16_t offset, uint16_t val);

typedef enum {
    SIMIF_STATUS = 0,
    SIMIF_EXIT = 1,
    SIMIF_PUTC = 2,
} simif_offset_t;

#endif
