#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "ac3dev.h"
#include "devices/dev_ioif.h"

device_handler_t ioif_hdl = {0};

static int ret_putc = 0;

device_handler_t *ioif_init() {
    ioif_hdl.desc.length_exp = IOIF_LENGTH_EXP;
    ioif_hdl.desc.can_read = 1;
    ioif_hdl.desc.can_write = 1;

    ioif_hdl.read = ioif_read;
    ioif_hdl.write = ioif_write;
    ioif_hdl.tick = ioif_tick;

    return &ioif_hdl;
}

uint16_t ioif_read(uint16_t offset) {
    switch(offset) {
        case IOIF_STATUS:
            return (IOIF_MAGIC<<8) | hdl2stat(&ioif_hdl);

        case IOIF_GETC:
            return getchar();

        case IOIF_PUTC:
            return ret_putc;

        default:
            return 0xDEAD;
    }
}

void ioif_write(uint16_t offset, uint16_t val) {
    switch (offset) {
        case IOIF_PUTC:
            ret_putc = putchar((int) val);
            break;

        default:
        // ignore
    }
}

int ioif_tick(int cycle) {
    (void)(cycle);
    return 0;
}
