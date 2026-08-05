#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#include "ac3dev.h"
#include "devices/dev_simif.h"

device_handler_t simif_hdl = {0};
static int timer = 0;

device_handler_t *simif_init() {
    simif_hdl.desc.length_exp = SIMIF_LENGTH_EXP;
    simif_hdl.desc.can_read = 1;
    simif_hdl.desc.can_write = 1;

    simif_hdl.read = simif_read;
    simif_hdl.write = simif_write;
    simif_hdl.tick = simif_tick;
    return &simif_hdl;
}

uint16_t simif_read(uint16_t offset) {
    switch(offset) {
        case SIMIF_STATUS:
            return (SIMIF_MAGIC<<8) | hdl2stat(&simif_hdl);
        case SIMIF_GETC:
            return getchar();
        case SIMIF_TIMER:
            simif_hdl.irq = 0;
            return timer;
        default:
            return 0xDEAD;
    }
}

void simif_write(uint16_t offset, uint16_t val) {
    switch (offset) {
        case SIMIF_EXIT:
            printf("simulator exit with %d by program.\n", val);
            exit(val);
            break;
        case SIMIF_PUTC:
            printf("putc('%c');\n", (uint8_t) val);
            break;
        case SIMIF_TIMER:
            printf("Timer set to %d cycles.\n", val);
            timer = val;
            break;
        default:
        // ignore
    }
}

int simif_tick(int cycle) {
    (void)(cycle);
    if(timer) {
        timer--;
        if(!timer) {
            printf("Timer triggered!\n");
            simif_hdl.irq = 1;
        }
    }
    return 0;
}
