
CFLAGS = -Wall -Wextra -O2 -g

CASM = customasm
CASMFLAGS = 

SIM = src/ac3pu-sim
DEFAULT_UROM = ucode/urom.bin
UROM ?= $(DEFAULT_UROM)

UCODE_SRCS := $(wildcard ucode/*.asm)
UCODE_DEPS := $(UCODE_SRCS:.asm=.d)

.PHONY: all test clean test-ucode test-asm

all: $(SIM) $(UROM)

$(SIM): src/*.c
	$(CC) $(CFLAGS) $^ -o $@

ucode/%.bin: ucode/%.asm
	$(CASM) $(CASMFLAGS) -o $@ $<

ucode/%.d: ucode/%.asm
	@echo -n Create $@ ...
	@echo -n "ucode/$*.bin $@: $< " > $@
	@(grep "#include" $<  || true) | \
	sed -e 's/[[:space:]]*#include[[:space:]]*"/ucode\//;s/"[[:space:]]*//;' | \
	while read -r dep; do \
		echo -n "$$dep "; \
	done >> $@
	@echo "" >> $@
	@echo done.

-include $(UCODE_DEPS)

test: test-ucode

test-ucode: test-ucode-01_decode \
			test-ucode-02_pipe \
			test-ucode-03_load_store \
			test-ucode-04_alu_arithmetic \
			test-ucode-05_alu_logic \
			test-ucode-06_alu_carry \
			test-ucode-07_alu_short \
			test-ucode-08_alu_arith_extended \
			test-ucode-09_cpu_flags \
			test-ucode-10_comparison \
			test-ucode-11_load_store_zp \
			test-ucode-12_full_zp \
			test-ucode-13_dynamic_long_word_selection \
			test-ucode-14_jump \
			test-ucode-15_jumpz

test-ucode-%: all
	@echo "Testing ucode $* ..."
	$(CASM) $(CASMFLAGS) -f binary -o test/ucode/$*/ram.bin test/ucode/$*/program.asm
	@UROM=$$(cat test/ucode/$*/UROM 2>/dev/null || echo "$(DEFAULT_UROM)") && \
	$(MAKE) $$UROM && \
	$(SIM) $$UROM test/ucode/$*/ram.bin > test/ucode/$*/actual.txt
	@diff -u test/ucode/$*/expected.txt test/ucode/$*/actual.txt && echo "Test ucode $* ... ok"
	@rm -f test/ucode/$*/{ram.bin,actual.txt}

clean:
	rm -f $(SIM) ucode/*.bin ucode/*.hex $(UCODE_DEPS)

