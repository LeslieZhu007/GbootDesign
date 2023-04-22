

.global mem_init

#define DMC_PHYCONTROL0 0xF0000018
mem_init:
        @2.1
        ldr r0,=DMC_PHYCONTROL0
        ldr r1,=0x00101000
        str r1,[r0]

        @2.2
        ldr r0,=DMC_PHYCONTROL0
        ldr r1,=0x00101002
        str r1,[r0]

        



        mov pc,lr