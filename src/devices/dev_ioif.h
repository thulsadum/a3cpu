#ifndef DEV_IOIF_H
#define DEV_IOIF_H 1

#include "ac3dev.h"

#define IOIF_MAGIC ('i' ^ 'O')  // = '&' 0x38
#define IOIF_LENGTH_EXP 2

extern device_handler_t ioif_hdl;

device_handler_t *ioif_init(void);

uint16_t ioif_read(uint16_t offset);
void ioif_write(uint16_t offset, uint16_t val);
int ioif_tick(int);

typedef enum {
    IOIF_STATUS = 0,
    IOIF_GETC,
    IOIF_PUTC,
} ioif_offset_t;

#endif
