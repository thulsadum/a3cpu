#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "ac3dev.h"
#include "devices/dev_forthif.h"

device_handler_t forthif_hdl = {0};

device_handler_t *forthif_init() {
    forthif_hdl.desc.length_exp = FORTHIF_LENGTH_EXP;
    forthif_hdl.desc.can_read = 1;
    forthif_hdl.desc.can_write = 1;

    forthif_hdl.read = forthif_read;
    forthif_hdl.write = forthif_write;
    forthif_hdl.tick = forthif_tick;
    return &forthif_hdl;
}

uint16_t forthif_read(uint16_t offset) {
    switch(offset) {
        case FORTHIF_STATUS:
            return (FORTHIF_MAGIC<<8) | hdl2stat(&forthif_hdl);
        default:
            return 0xDEAD;
    }
}

void forthif_write(uint16_t offset, uint16_t val) {
    switch (offset) {
        default:
        // ignore
    }
}

int forthif_tick(int cycle) {
    (void)(cycle);
    return 0;
}
