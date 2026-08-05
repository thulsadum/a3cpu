#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "ac3dev.h"
#include "devices/dev_testif.h"

device_handler_t testif_hdl = {0};

device_handler_t *testif_init() {
    testif_hdl.desc.length_exp = TESTIF_LENGTH_EXP;
    testif_hdl.desc.can_read = 1;
    testif_hdl.desc.can_write = 1;

    testif_hdl.read = testif_read;
    testif_hdl.write = testif_write;
    testif_hdl.tick = testif_tick;
    return &testif_hdl;
}

uint16_t testif_read(uint16_t offset) {
    switch(offset) {
        case TESTIF_STATUS:
            return (TESTIF_MAGIC<<8) | hdl2stat(&testif_hdl);
        default:
            return 0xDEAD;
    }
}

void testif_write(uint16_t offset, uint16_t val) {
    switch (offset) {
        default:
        // ignore
    }
}

int testif_tick(int cycle) {
    (void)(cycle);
    return 0;
}
