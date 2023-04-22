#define GPJ2CON (volatile unsigned long *)0xE0200280
#define GPJ2DAT (volatile unsigned long *)0xE0200284


int gboot_main()
{
    *GPJ2CON = 0x1111;
    *GPJ2DAT = 0xf;
    return 0;
}
