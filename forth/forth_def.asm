
#bankdef forth_system {
    bits = 16
    outp = 0x100 * 16
    addr = 0x100
    addr_end = 0x1000
}

#bankdef forth_text {
    bits = 16
    outp = 0x1000 * 16
    addr = 0x1000
    addr_end = 0x8000
}

#bankdef mmio {
    bits = 16
    addr = 0x8000
    addr_end = 0x10000
}

#const DSP_ADDR = 0x20
#const RSP_ADDR = 0xff

