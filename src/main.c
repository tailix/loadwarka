/*
    Copyright (c) 2022 Alex Kotov <kotovalexarian@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#define MBR_SIZE 512
#define MBR_BOOTSTRAP_SIZE (MBR_SIZE - sizeof(struct MbrInfo))
#define MBR_ENTRIES 4
#define MBR_MAGIC 0xAA55

struct MbrEntry {
    uint8_t  drive_attributes;
    unsigned start_chs_address : 24;
    uint8_t  partition_type;
    unsigned last_chs_address : 24;
    uint32_t start_lba;
    uint32_t sectors_count;
}
__attribute__((packed));

struct MbrInfo {
    uint32_t disk_id;
    uint16_t reserved;
    struct MbrEntry entries[MBR_ENTRIES];
    uint16_t magic;
}
__attribute__((packed));

struct Mbr {
    uint8_t bootstrap[MBR_BOOTSTRAP_SIZE];
    struct MbrInfo info;
}
__attribute__((packed));

static bool create_mbr_file(
    bool print_debug,
    const char *output_filename,
    uint32_t disk_id,
    const char *bootstrap_filename
);

int main()
{
    const bool result = create_mbr_file(
        true,
        "disk.img",
        0xf01834d0,
        "src/x86_boot_sector.bin"
    );

    return result ? 0 : 1;
}

bool create_mbr_file(
    const bool print_debug,
    const char *const output_filename,
    const uint32_t disk_id,
    const char *const bootstrap_filename
) {
    struct Mbr mbr;

    {
        memset(&mbr, 0, sizeof(mbr));

        mbr.info.magic = MBR_MAGIC;
        mbr.info.disk_id = disk_id;
        mbr.info.reserved = 0;
    }

    if (bootstrap_filename) {
        FILE *fd = fopen(bootstrap_filename, "r");
        if (fd == NULL) {
            fprintf(stderr, "Can't open bootstrap file\n");
            return false;
        }

        const size_t size = fread(&mbr.bootstrap, 1, MBR_BOOTSTRAP_SIZE, fd);
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
    }

    return true;
}
