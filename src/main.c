#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#include <kernaux/mbr.h>

static bool create_mbr_file(
    bool print_debug,
    const char *output_filename,
    uint32_t disk_id,
    const char *bootstrap_filename
);

int main(const int argc, char **const argv)
{
    if (argc < 2) {
        fprintf(stderr, "Invalid usage\n");
        return 1;
    }

    const char *const format = argv[1];

    if (strcmp(format, "mbr") == 0) {
        if (argc != 3 && argc != 4) {
            fprintf(stderr, "Invalid usage\n");
            return 1;
        }

        const char *const output_filename = argv[2];
        const char *const bootstrap_filename = argc == 3 ? NULL :argv[3];

        const bool result = create_mbr_file(
            true,
            output_filename,
            0xf01834d0,
            bootstrap_filename
        );
        if (!result) return 1;
    } else {
        fprintf(stderr, "Invalid format: %s\n", format);
    }

    return 0;
}

bool create_mbr_file(
    const bool print_debug,
    const char *const output_filename,
    const uint32_t disk_id,
    const char *const bootstrap_filename
) {
    struct KernAux_Mbr mbr;

    {
        memset(&mbr, 0, sizeof(mbr));

        mbr.info.magic = KERNAUX_MBR_MAGIC;
        mbr.info.disk_id = disk_id;
        mbr.info.reserved = 0;

        // 00
        mbr.info.entries[0].drive_attributes = 0;
        // 00 02 00
        mbr.info.entries[0].first_sector_chs_addr = 0x0200;
        // 01
        mbr.info.entries[0].partition_type = 1;
        // 02 03 00
        mbr.info.entries[0].last_sector_chs_addr = 0x0302;
        // 01 00 00 00
        mbr.info.entries[0].first_sector_lba_addr = 0x01;
        // 80 00 00 00
        mbr.info.entries[0].sectors_count = 0x80;
    }

    if (bootstrap_filename) {
        FILE *fd = fopen(bootstrap_filename, "r");
        if (fd == NULL) {
            fprintf(stderr, "Can't open bootstrap file\n");
            return false;
        }

        const size_t size = fread(&mbr.bootstrap, 1, KERNAUX_MBR_BOOTSTRAP_SIZE, fd);
        if (size == 0) {
            fprintf(stderr, "Empty bootstrap file\n");
            return false;
        }
        if (!feof(fd)) {
            fprintf(stderr, "Too long bootstrap file\n");
            return false;
        }

        fclose(fd);
    }

    uint8_t *mbr_ptr = (uint8_t*)&mbr;

    if (print_debug) {
        for (size_t i = 0; i < 512 / 16; ++i) {
            printf("%02x", mbr_ptr[i * 16]);
            for (size_t j = 1; j < 16; ++j) {
                printf(" %02x", mbr_ptr[i * 16 + j]);
            }
            printf("\n");
        }
    }

    {
        FILE *fd = fopen(output_filename, "wb");
        if (fd == NULL) {
            fprintf(stderr, "Can't open image file\n");
            return false;
        }

        const size_t size = fwrite(mbr_ptr, 1, sizeof(mbr), fd);
        if (size != sizeof(mbr)) {
            fprintf(stderr, "Can't write image file\n");
            return false;
        }

        fclose(fd);
    }

    return true;
}
