
CFLAGS = -Wall -Wextra -O2 -g

CASM = customasm
CASMFLAGS = 

SIM = src/ac3pu-sim
DEFAULT_UROM = ucode/urom_full.bin

.PHONY: all test clean test-ucode test-asm

all: $(SIM) $(UROM)

$(SIM): src/*.c
	$(CC) $(CFLAGS) $< -o $@

$(UROM): ucode/urom_fetch.asm ucode/urom_def.asm

ucode/%.bin: ucode/%.asm ucode/urom_def.asm
	$(CASM) $(CASMFLAGS) -o $@ $<

test: test-ucode

test-ucode: test-ucode-01_decode test-ucode-02_pipe test-ucode-03_load_store test-ucode-04_alu_arithmetic test-ucode-05_alu_logic test-ucode-06_alu_flags test-ucode-07_alu_short test-ucode-08_alu_arith_extended

test-ucode-%: all
	@echo "Testing ucode $* ..."
	$(CASM) $(CASMFLAGS) -f binary -o test/ucode/$*/ram.bin test/ucode/$*/program.asm
	@UROM=$$(cat test/ucode/$*/UROM 2>/dev/null || echo "$(DEFAULT_UROM)") && \
	make $$UROM && \
	$(SIM) $$UROM test/ucode/$*/ram.bin > test/ucode/$*/actual.txt
	@diff -u test/ucode/$*/expected.txt test/ucode/$*/actual.txt && echo "Test ucode $* ... ok"
	@rm -f test/ucode/$*/{ram.bin,actual.txt}

clean:
	rm -f $(SIM) ucode/*.bin ucode/*.hex

