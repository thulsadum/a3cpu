
CFLAGS = -Wall -Wextra -O2 -g

CASM = customasm
CASMFLAGS = 

SIM = src/ac3pu-sim
DEFAULT_UROM = ucode/urom.bin
UROM ?= $(DEFAULT_UROM)

UCODE_SRCS := $(wildcard ucode/*.asm)
UCODE_DEPS := $(UCODE_SRCS:.asm=.d)

UCODE_TEST_PROGRAMS := $(wildcard test/ucode/*/program.asm)
UCODE_TESTS := $(patsubst test/ucode/%/program.asm,test/ucode/%,$(UCODE_TEST_PROGRAMS))

ASM_TEST_PROGRAMS := $(wildcard test/asm/*/program.asm)
ASM_TESTS := $(patsubst test/asm/%/program.asm,test/asm/%,$(ASM_TEST_PROGRAMS))

.PHONY: all test clean test-ucode test-asm

all: $(SIM) $(UROM)
	echo $(UCODE_TESTS)

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

test: test-ucode #test-asm

#test-asm: $(ASM_TESTS)

#test/asm/%: $(UROM) test/asm/%/ram.bin test/asm/%/sim
#	@echo "Testing asm $* ..."
#	$(CASM) $(CASMFLAGS) -f binary -o test/ucode/$*/ram.bin test/ucode/$*/program.asm
#

test-ucode: $(UCODE_TESTS)

test/ucode/%: all test/ucode/%/ram.bin test/ucode/%/actual.txt
	@diff -u test/ucode/$*/expected.txt test/ucode/$*/actual.txt && echo "Test ucode $* ... ok." || echo "Test ucode $* ... FAIL!"
	@rm -f test/ucode/$*/{ram.bin,actual.txt}

test/ucode/%/actual.txt: test/ucode/%/ram.bin $(SIM)
	@UROM=$$(cat test/ucode/$*/UROM 2>/dev/null || echo "$(DEFAULT_UROM)") && \
	$(MAKE) $$UROM && \
	$(SIM) $$UROM test/ucode/$*/ram.bin > test/ucode/$*/actual.txt


test/ucode/%/ram.bin: test/ucode/%/program.asm
	$(CASM) $(CASMFLAGS) -f binary -o test/ucode/$*/ram.bin test/ucode/$*/program.asm

clean:
	rm -f $(SIM) ucode/*.bin ucode/*.hex $(UCODE_DEPS)

