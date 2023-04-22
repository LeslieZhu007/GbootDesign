

.global mem_init

#define DMC_PHYCONTROL0 0xF0000018

#define DMC_CONCONTROL 0xF0000000
@参照 P598 1.2.1.3 DDR2 
@ Initialization sequence for DDR2 memory type: 
mem_init:
        @2.1
        ldr r0,=DMC_PHYCONTROL0
        ldr r1,=0x00101000
        str r1,[r0]

        @2.2
        ldr r0,=DMC_PHYCONTROL0
        ldr r1,=0x00101002
        str r1,[r0]

        @2.4 当前步骤必须包含先前步骤
        ldr r0,=DMC_PHYCONTROL0
        ldr r1,=0x00101003   
        str r1,[r0]

        @2.5 将默认值写回寄存器
        ldr r0,=DMC_CONCONTROL
        ldr r1,=0x0FFF1350 
        str r1,[r0]

        mov pc,lr