#ifndef DEV_TESTIF_H
#define DEV_TESTIF_H 1

#include "ac3dev.h"

#define TESTIF_MAGIC '!'
#define TESTIF_LENGTH_EXP 2

extern device_handler_t testif_hdl;

device_handler_t *testif_init(void);

uint16_t testif_read(uint16_t offset);
void testif_write(uint16_t offset, uint16_t val);
int testif_tick(int);

typedef enum {
    TESTIF_STATUS = 0,
    TESTIF_ASSERT,
    TESTIF_ASSERT_NOT,
} testif_offset_t;

#endif
