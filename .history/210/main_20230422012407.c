#define GPJ2CON (volatile unsigned long *)0xE0200280
#define GPJ2DAT (volatile unsigned long *)0xE0200284


int gboot_main()
{
    return 0;
}
light_led:
        ldr r0,=GPJ2CON 
        ldr r1,=0x1111
        str r1,[r0]


        ldr r0,=GPJ2DAT 
        ldr r1,=0xf
        str r1,[r0]
        mov pc,lr