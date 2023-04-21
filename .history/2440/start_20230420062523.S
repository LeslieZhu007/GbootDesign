.text
.global _start
_start:
        b reset
        ldr pc,_undefined_instruction
        ldr pc,_software_interrupt
        ldr pc,_prefetch_abort
        ldr pc,_data_abort
        ldr pc,_not_used
        ldr pc,_irq
        ldr pc,_fiq
        ldr pc,_reset

_undefined_instruction: .word undefined_instruction
_software_interrupt: .word software_interrupt
_prefetch_abort: .word prefetch_abort
_data_abort: .word data_abort
_not_used: .word not_used
_irq: .word irq
_fiq: .word fiq
_reset: .word reset


undefined_instruction:
        nop
software_interrupt:
        nop
prefetch_abort:
        nop
data_abort:
        nop
not_used:
        nop
irq:
        nop
fiq:
        nop
reset:
        bl set_svc
        bl disable_watchdog
        bl disable_interrupt
        bl disable_mmu
        bl clock_init
        bl light_led
set_svc:
        mrs r0,cpsr
        bic r0,#0x1f
        orr r0,#0xD3  @I F T M[4:0] ====>  110 10011 
        msr cpsr,r0
        mov pc,lr 

@2440 P462
#define pWTCON 0x53000000
disable_watchdog:
        ldr r0,=pWTCON
        mov r1,#0x0
        str r1,[r0]
        mov pc,lr 

@2440 P388 
disable_interrupt:
        mvn r1,#0x0 @全部置1
        ldr r0,=0x4A000008
        str r1,[r0]
        mov pc,lr 

@2440 ARM920T_TRM1 P42
disable_mmu:
        mcr p15,0,r0,c7,c7,0 @Invalidate ICache and DCache
        @ 先读出到r0
        mrc p15, 0, r0, c1, c0, 0 @read control register
        bic r0,#0x7 @ 0:mmu 2:dcache

        @ 再写入
        mcr p15, 0, r0, c1, c0, 0 @write control register
        mov pc,lr 
/*
   mini2440
nLED_1 GPB5
nLED_2 GPB6
nLED_3 GPB7
nLED_4 GPB8
*/

@s3c2440手册P284
#define GPBCON 0x56000010
#define GPBDAT 0x56000014
light_led:
        ldr r0, =GPBCON 
        ldr r1, = 0x15400  @0b0000010101010000000000
        str r1,[r0]

        ldr r0, =GPBDAT
        ldr r1, = 0x61F      @0b11000011111 
        str r1,[r0]

        mov pc,lr

#define CLKDIVN 0x4c000014     @10

clock_init
        ldr r0, =CLKDIVN
        mov r1, #0x5
        str r1,[r0]

        mov pc,lr