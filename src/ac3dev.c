#include <stdint.h>

#include "ac3dev.h"

static device_handler_t *devices[AC3DEV_NO_DEVS];
static int devices_count = 0;

int register_device(device_handler_t * hdl) {
    if (devices_count == AC3DEV_NO_DEVS) return -1;
    if  (devices_count) {
        hdl->begin = devices[devices_count - 1]->end + 1;
    } else {
        hdl->begin = AC3DEV_MMIO_BEGIN;
    }
    hdl->end = hdl->begin + (1 << hdl->desc.length_exp);

    devices[devices_count] = hdl;
    devices_count++;

    return devices_count;
}

int handle_read(uint16_t addr, uint16_t *val) {
    const device_handler_t *hdl;
    for(int i = 0; i < devices_count; i++) {
        hdl = devices[i];
        if (hdl->begin <= addr && addr <= hdl->end) {
        /* match! */
            if(hdl->desc.can_read) {
                *val = hdl->read(addr - hdl->begin);
                return 0;
            } else {
                return -2; // cannot read!
            }
        }
    }

    return -1;
}

int handle_write(uint16_t addr, uint16_t val) {
    const device_handler_t *hdl;
    for(int i = 0; i < devices_count; i++) {
        hdl = devices[i];
        if (hdl->begin <= addr && addr <= hdl->end) {
        /* match! */
            if(hdl->desc.can_write) {
                hdl->write(addr - hdl->begin, val);
                return 0;
            } else {
                return -2; // cannot write!
            }
        }
    }

    return -1;
}

int devdesc2int(device_descriptor_t desc) {
    return ((desc.can_write & 1) << 5 | (desc.can_read & 1) << 4 | desc.length_exp) & 0xff;
}
