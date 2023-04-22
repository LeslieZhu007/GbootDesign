
int gboot_main()
{

light_led:
        ldr r0, =GPBCON 
        ldr r1, = 0x15400  @0b0000010101010000000000
        str r1,[r0]

        ldr r0, =GPBDAT
        ldr r1, = 0x61F      @0b11000011111 
        str r1,[r0]

        mov pc,lr
    return 0;
}