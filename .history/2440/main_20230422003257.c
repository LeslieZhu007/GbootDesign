#define GPBCON (volatile unsigned long *)0x56000010
#define GPBDAT (volatile unsigned long *)0x56000014
int gboot_main()
{
    *GPBCON =  0x15400;
    *GPBDAT = 0x61F;
    return 0;
}