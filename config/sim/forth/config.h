#ifndef CONFIG_H
#define CONFIG_H 1

#define CFG_DEVICE(DEV) hdl = (DEV ## _init()); if(!hdl) return 1; register_device(hdl)

#define CFG_DEFAULT_DEVICES 0

#define CFG_DEVICE_REGISTRATION \
    CFG_DEVICE(ioif); \
    CFG_DEVICE(forthif); \
    CFG_DEVICE(testif); \
    ;
#endif
