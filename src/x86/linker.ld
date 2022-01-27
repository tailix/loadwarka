OUTPUT_ARCH(i386)
OUTPUT_FORMAT(binary)
ENTRY(_start)

program_size = program_end - program_start;

SECTIONS
{
    . = program_start;

    .text : ALIGN(4)
    {
        *(.header);
        *(.text);
    }

    .rodata : ALIGN(4)
    {
        *(.rodata);
    }

    .data : ALIGN(4)
    {
        *(.data);
    }

    program_end = .;
}
