#define GPKCON (volatile unsigned long*)0x7F008800
#define GPKDAT (volatile unsigned long*)0x7F008808
      


int gboot_main()
{
    *GPKCON = 0x11110000;
    *GPKDAT = 0xA0;
    return 0;
}