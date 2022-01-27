OUTPUT_ARCH(i386)
OUTPUT_FORMAT(binary)
ENTRY(_start)

SECTIONS
{
    . = 0x7e00;

    .text :
    {
        *(.text);
    }
}
