CFLAGS = -Wall -Wextra -O2 -g -I src
CFLAGS_UCODE = $(CFLAGS) -I config/sim/ucode
CFLAGS_ASM = $(CFLAGS) -I config/sim/asm
CFLAGS_FORTH = $(CFLAGS) -I config/sim/forth

CASM = customasm
CASMFLAGS = -q

SIM = src/ac3pu-sim
UROM = ucode/urom.bin
UCA = ucode_analyze/uca
FORTH = forth/forth.bin
FORTH_SRC := $(wildcard forth/*.asm)

UCA_SRCS := $(wildcard ucode_analyze/*.c)
UCA_ROM := ucode_analyze/urom-h.bin

UCODE_SRCS := $(wildcard ucode/*.asm)
UCODE_DEPS := $(UCODE_SRCS:.asm=.d)

UCODE_TEST_PROGRAMS := $(wildcard test/ucode/*/program.asm)
UCODE_TESTS := $(patsubst test/ucode/%/program.asm,test/ucode/%,$(UCODE_TEST_PROGRAMS))

ASM_TEST_PROGRAMS := $(wildcard test/asm/*/program.asm)
ASM_TEST_EXPECTED_TXTS := $(ASM_TEST_PROGRAMS:program.asm=expected.txt)
ASM_TESTS := $(patsubst test/asm/%/program.asm,test/asm/%,$(ASM_TEST_PROGRAMS))

FORTH_TESTS := $(wildcard test/forth/*)

MMIO_BEGIN := 0x8000

.PHONY: all test clean test-ucode test-asm analyze-ucode $(SIM)-ucode

.PRECIOUS: %.txt

all: $(SIM) $(UROM) $(UCA) $(FORTH)

$(FORTH): $(FORTH_SRC)
	customasm -o $@ -f binary $^

$(SIM): src/*.c src/devices/*.c
	$(CC) $(CFLAGS) -I config/sim/asm $^ -o $@

$(SIM)-ucode: src/*.c src/devices/*.c
	$(CC) $(CFLAGS_UCODE) $^ -o $(SIM)

$(SIM)-forth: src/*.c src/devices/*.c
	$(CC) $(CFLAGS_FORTH) $^ -o $(SIM)

$(UCA): $(UCA_SRCS)
	$(CC) $(CFLAGS) $^ -o $@

$(UCA_ROM): $(UROM)
	cp $(UROM) $(UCA_ROM)

analyze-ucode: $(UCA) $(UCA_ROM)
	$(UCA) $(UCA_ROM)


ucode/%.bin: ucode/%.asm asmdef/*.asm ucode/*.asm
	$(CASM) $(CASMFLAGS) -o $@ $<

ucode/%.d: ucode/%.asm
	@echo -n "ucode/$*.bin $@: $< " > $@
	@(grep "#include" $<  || true) | \
	sed -e 's/[[:space:]]*#include[[:space:]]*"/ucode\//;s/"[[:space:]]*//;' | \
	while read -r dep; do \
		echo -n "$$dep "; \
	done >> $@
	@echo "" >> $@

-include $(UCODE_DEPS)


update-expected.txts: update-asm-expected.txts

update-asm-expected.txts: $(ASM_TEST_EXPECTED_TXTS)

test/asm/%/expected.txt: test/asm/%/actual.txt
	mv $< $@

test: test-ucode test-asm test-forth


test-asm: $(ASM_TESTS)

test/asm/%: test/asm/%/actual.txt
	@diff -u test/asm/$*/expected.txt test/asm/$*/actual.txt && echo "Test asm $* ... ok." ||( echo "Test asm $* ... FAIL!" && false)
	@rm -f test/asm/$*/{ram.bin,actual.txt,sim}

test/asm/%/actual.txt: test/asm/%/sim test/asm/%/ram.bin $(UROM)
	[ -f "test/asm/$*/INPUT" ] && \
		$< $(UROM) test/asm/$*/ram.bin --silent --mt-begin $(MMIO_BEGIN) < "test/asm/$*/INPUT" > $@ || \
		$< $(UROM) test/asm/$*/ram.bin --silent --mt-begin $(MMIO_BEGIN) > $@

test/asm/%/sim: test/asm/%/sim.c src/*.c src/devices/*.c
	$(CC) $(CFLAGS_ASM) -o $@ $^


test-ucode: $(UCODE_TESTS)

test/ucode/%: test/ucode/%/ram.bin test/ucode/%/actual.txt
	@diff -u test/ucode/$*/expected.txt test/ucode/$*/actual.txt && echo "Test ucode $* ... ok." || (echo "Test ucode $* ... FAIL!" && false)
	@rm -f test/ucode/$*/{ram.bin,actual.txt}

test/ucode/%/actual.txt: test/ucode/%/ram.bin $(SIM)-ucode $(UROM)
	$(SIM) $(UROM) test/ucode/$*/ram.bin > test/ucode/$*/actual.txt


test/%/ram.bin: test/%/program.asm
	$(CASM) $(CASMFLAGS) -f binary -o $@ $<



test-forth: $(FORTH_TESTS)

test/forth/%/ram.bin: test/forth/%/fprog.asm test/forth/%/program.asm
	$(CASM) $(CASMFLAGS) -f binary -o $@ $^

test/forth/%/ram.bin: test/forth/%/fprog.asm  $(FORTH_SRC)
	$(CASM) $(CASMFLAGS) -f binary -o $@ $<

test/forth/00_boot: test/forth/00_boot/ram.bin $(SIM)-forth $(UROM) $(FORTH_SRC)
	$(SIM) $(UROM) $< --silent

test/forth/%/fprog.asm: test/forth/%/program.f
	$(FORTH) $(FORTH_FLAGS) -o $@ $<

test/forth/%/actual.txt: test/forth/%/ram.bin $(SIM)-forth $(UROM) test/forth/%/INPUT
	$(SIM) $(UROM) $< --silent < test/forth/$*/INPUT > $@ || (echo 'Test forth $*.. FAILED.'; false)

test/forth/%/actual.txt: test/forth/%/ram.bin $(SIM)-forth $(UROM)
	$(SIM) $(UROM) $< --silent > $@ || (echo 'Test forth $*.. FAILED.'; false)

test/forth/%: test/forth/%/expected.txt test/forth/%/actual.txt
	diff test/forth/$*/actual.txt $<  && echo 'Test forth $* ... ok.' || (echo 'Test forth $*.. FAILED.'; false)

test/forth/%: test/forth/%/ram.bin test/forth/%/INPUT $(SIM)-forth $(UROM)
	$(SIM) $(UROM) $< --silent < test/forth/$*/INPUT && echo 'Test forth $* ... ok.' || (echo 'Test forth $*.. FAILED.'; false)

test/forth/%: test/forth/%/ram.bin $(SIM)-forth $(UROM)
	$(SIM) $(UROM) $< --silent && echo 'Test forth $* ... ok.' || (echo 'Test forth $*.. FAILED.'; false)

clean:
	rm -f $(SIM) $(UROM) ucode/*.bin ucode/*.hex $(UCODE_DEPS) $(UCA_ROM) $(UCA) test/forth/*/ram.bin test/forth/*/actual.txt
	find . -type f -name symbols.txt -delete

