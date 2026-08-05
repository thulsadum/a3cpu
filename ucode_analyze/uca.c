#include <stdio.h>
#include <stdint.h>
#include <arpa/inet.h>

#include "ac3pu-sim.h"

static uinstruction_t urom[UPROGRAM_SIZE];
static int urom_len = 0;
static sig_t hit_matrix[32];

static void update_hit_matrix(uinstruction_t uc) {
    sig_t mask = 1;
    for(int i = 0; i < 32; i++) {
        if(uc.raw & mask) {
            hit_matrix[i] |= uc.raw;
        }
        mask <<= 1;
    }
}

static void create_hit_matrix() {
    for(int i = 0; i < urom_len; i++) {
        update_hit_matrix(urom[i]);
    }
}

// Beispiel: Prüfen, ob eine Gruppe von Bits sich paarweise komplett ausschließt
bool is_exclusive_group(sig_t bit_mask) {
    for (int i = 0; i < 32; i++) {
        if (!(bit_mask & (1ULL << i))) continue;
        for (int j = i + 1; j < 32; j++) {
            if (!(bit_mask & (1ULL << j))) continue;
            // Wenn Bit j in Zeile i gesetzt ist, traten sie gemeinsam auf -> Nicht exklusiv!
            if (hit_matrix[i] & (1ULL << j)) {
                return false;
            }
        }
    }
    return true; // Alle Bits in bit_mask schließen sich paarweise aus!
}

static int bitcount(sig_t val) {
    int bits = 0;
    while(val) {
        if(val & 1) bits++;
        val >>=1;
    }
    return bits;
}

sig_t find_max_exclusive_group(sig_t start, sig_t end) {
    sig_t max_bits = 0;
    sig_t max_group = 0;
    for(sig_t i = start; i < end; i++) {
        if(is_exclusive_group(i) && bitcount(i) > max_bits) {
            max_bits = bitcount(i);
            max_group = i;
        }
    }
    return max_group;
}

int main(int argc, const char **argv) {

    if(argc < 2) {
        fprintf(stderr, "usage: %s <path to combined mrom + urom file>\n", argv[0]);
        return 1;
    }

    FILE * rom_file = fopen(argv[1],"rb");
    /* skip mron */
    if(fseek(rom_file, MAP_ROM_SIZE * sizeof(uint16_t), SEEK_SET)) {
        perror("skip mrom");
        return 1;
    }
    urom_len = fread(urom, sizeof(uinstruction_t), UPROGRAM_SIZE, rom_file);
    if(urom_len < 0) {
        perror("reading urom file");
        fclose(rom_file);
        return 1;
    }
    fclose(rom_file);

    printf("read urom file: %s of %ld bytes / %d instructions.\n", argv[1], sizeof(uinstruction_t)*urom_len, urom_len);

    for(int i = 0; i < urom_len; i++) {
        urom[i].raw = to_be(urom[i].raw);
    }

    create_hit_matrix();

    printf("hit matrix:\n");
    sig_t all_used = 0;
    for(int i=0; i<32; i++) {
        printf("    %032b\n", hit_matrix[i]);
        all_used |= hit_matrix[i];
    }

    printf("\n=== UCODE ANALYSE REPORT ===\n");
    printf("Unbenutzte Bits (Dead Bits / Nie aktiv):\n    %032lb\n\n", ~all_used);

    // 2. Exklusive Signale finden (Kandidaten für Vertikalen uCode / MUXing)
    printf("Gegenseitig exklusive Bit-Paare (Niemals zeitgleich aktiv):\n");
    int count = 0;
    for(int i = 0; i < 32; i++) {
        // Ignoriere unbenutzte Bits
        if (!(all_used & (1ULL << i))) continue;

        for(int j = i + 1; j < 32; j++) {
            if (!(all_used & (1ULL << j))) continue;

            // Wenn Bit j in Zeile i NULL ist, traten i und j NIE zusammen auf!
            if (!(hit_matrix[i] & (1ULL << j))) {
                printf("  - Bit %2d <--> Bit %2d schließen sich aus.\n", 
                        i, j);
                count++;
            }
        }
    }
    printf("Gesamt gefunden: %d exklusive Paare.\n", count);

    printf("lower_half - max exclusive group: %030b\n", find_max_exclusive_group(0,1<<15));
    printf("upper_half - max exclusive group: %030b\n", find_max_exclusive_group(1<<15,1<<30));
    printf("all - max exclusive group: %030b\n", find_max_exclusive_group(0,1<<30));

    return 0;
}
