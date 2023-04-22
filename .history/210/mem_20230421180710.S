

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

        @ step 6
	ldr	r0, =DMC_MEMCONTROL
	ldr	r1, =DMC0_MEMCONTROL				
	str	r1, [r0]
	
	@ step 7
	ldr	r0, =DMC_MEMCONFIG0
	ldr	r1, =DMC0_MEMCONFIG_0				
	str	r1, [r0]
	
	@ step 8
	ldr	r0, =DMC_PRECHCONFIG
	ldr	r1, =0xFF000000					
	str	r1, [r0]
	
	@ step 9.1
	ldr	r0, =DMC_TIMINGAREF
	ldr	r1, =DMC0_TIMINGA_REF				
	str	r1, [r0]
	
	@ step 9.2
	ldr	r0, =DMC_TIMINGROW
	ldr	r1, =DMC0_TIMING_ROW				
	str	r1, [r0]
	
	@ step 9.3
	ldr	r0, =DMC_TIMINGDATA
	ldr	r1, =DMC0_TIMING_DATA				
	str	r1, [r0]
	
	@ step 9.4
	ldr	r0, =DMC_TIMINGPOWER
	ldr	r1, =DMC0_TIMING_PWR				
	str	r1, [r0]
	
	@ step 11
wait_lock:
	ldr	r0, =DMC_PHYSTATUS 
	ldr	r1, [r0]			
	and	r2, r1, #0x4
	cmp	r2, #0x4					
	bne	wait_lock

	@ step 14
	ldr	r0, =DMC_DIRECTCMD
	ldr	r1, =0x07000000					
	str	r1, [r0]
	
	@ step 16
	ldr	r1, =0x01000000					
	str	r1, [r0]
	
	@ step 17
	ldr	r1, =0x00020000					
	str	r1, [r0]
	
	@ step 18
	ldr	r1, =0x00030000					
	str	r1, [r0]
	
	@ step 19
	ldr	r1, =0x00010400					
	str	r1, [r0]
	
	@ step 20
	ldr	r1, =0x00000542					
	str	r1, [r0]
	
	@ step 21
	ldr	r1, =0x01000000					
	str	r1, [r0]
	
	@ step 22.1 
	ldr	r1, =0x05000000					
	str	r1, [r0]
	
	@ step 22.2
	ldr	r1, =0x05000000					
	str	r1, [r0]
	
	@ step 23
	ldr	r1, =0x00000442					
	str	r1, [r0]
	
	@ step 25.1
	ldr	r1, =0x00010780					
	str	r1, [r0]
	
	@ step 25.2
	ldr	r1, =0x00010400					
	str	r1, [r0]
	
	@ step 26, repeat step14~step25
	ldr	r1, =0x07100000					
	str	r1, [r0]
	
	ldr	r1, =0x01100000					
	str	r1, [r0]
	
	ldr	r1, =0x00120000					
	str	r1, [r0]
	
	ldr	r1, =0x00130000					
	str	r1, [r0]
	
	ldr	r1, =0x00110400					
	str	r1, [r0]
	
	ldr	r1, =0x00100542					
	str	r1, [r0]
	
	ldr	r1, =0x01100000					
	str	r1, [r0]
	
	ldr	r1, =0x05100000					
	str	r1, [r0]
	
	ldr	r1, =0x05100000					
	str	r1, [r0]
	
	ldr	r1, =0x00100442					
	str	r1, [r0]
	
	ldr	r1, =0x00110780					
	str	r1, [r0]
	
	ldr	r1, =0x00110400					
	str	r1, [r0]
	
	@ step 27
	ldr     r0, =DMC_CONCONTROL
	ldr	r1, =0x0FF02030					
	str	r1, [r0]
	
	ldr     r0, =DMC_PWRDNCONFIG
	ldr	r1, =0xFFFF00FF					
	str	r1, [r0]
	
	ldr     r0, =DMC_CONCONTROL
	ldr	r1, =0x00202400					
	str	r1, [r0]

        mov pc,lr