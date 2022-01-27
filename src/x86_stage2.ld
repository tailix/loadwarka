OUTPUT_ARCH("i386")
ENTRY(_start)

SECTIONS
{
    . = 0x7e00;

    .text :
    {
        *(.text);
    }
}
