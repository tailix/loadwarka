OUTPUT_ARCH(i386)
OUTPUT_FORMAT(binary)
ENTRY(_start)

program_size = program_end - program_start;

SECTIONS
{
    . = program_start;

    .text :
    {
        *(.start);
        *(.init);
        *(.text);
    }

    program_end = .;
}
