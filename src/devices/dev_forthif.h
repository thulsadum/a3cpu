#ifndef DEV_FORTHIF_H
#define DEV_FORTHIF_H 1

#include "ac3dev.h"

#define FORTHIF_MAGIC 0x53
#define FORTHIF_LENGTH_EXP 4

extern device_handler_t forthif_hdl;

device_handler_t *forthif_init(void);

uint16_t forthif_read(uint16_t offset);
void forthif_write(uint16_t offset, uint16_t val);
int forthif_tick(int);

typedef enum {
    FORTHIF_STATUS = 0,
    FORTHIF_EXIT,
    FORTHIF_PUTC,
    FORTHIF_GETC,
    FORTHIF_TIMER,
} forthif_offset_t;

#endif
