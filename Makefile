
CFLAGS = -Wall -Wextra -O2 -g

CASM = customasm
CASMFLAGS = 

SIM = src/ac3pu-sim
UROM = ucode/urom_fetch.bin

.PHONY: all test clean test-ucode test-asm

all: $(SIM) $(UROM)

$(SIM): src/*.c
	$(CC) $(CFLAGS) $< -o $@

$(UROM): ucode/urom_fetch.asm ucode/urom_def.asm
	$(CASM) $(CASMFLAGS) -o $@ ucode/urom_fetch.asm

test: test-ucode

test-ucode: test-ucode-00_fetch test-ucode-01_decode

test-ucode-%: all
	@echo "Testing ucode $* ..."
	@$(CASM) $(CASMFLAGS) -f binary -o test/ucode/$*/ram.bin test/ucode/$*/program.asm
	@$(SIM) $(UROM) test/ucode/$*/ram.bin > test/ucode/$*/actual.txt
	@diff -u test/ucode/$*/expected.txt test/ucode/$*/actual.txt && echo "Test ucode $* ... ok"
	@rm -f test/ucode/$*/{ram.bin,actual.txt}

clean:
	rm -f $(SIM) $(UROM)

