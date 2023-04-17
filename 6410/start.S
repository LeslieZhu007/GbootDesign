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
        mov pc,lr 

set_svc:
        mrs r0,cpsr
        bic r0,#0x1f
        orr r0,#0xD3  @I F T M[4:0] ====>  110 10011 
        msr cpsr,r0
        mov pc,lr 
        
@6410 P1139
#define pWTCON 0x7E004004 
disable_watchdog:
        ldr r0,=pWTCON
        mov r1,#0x0
        str r1,[r0]
        mov pc,lr 

@6410 P419
disable_interrupt:
        mvn r1,#0x0
        ldr r0,=0x71200014
        str r1,[r0]
        ldr r0,=0x71300014
        str r1,[r0]
        mov pc,lr 

@Arm1176jzfs P176 P146 与2440逻辑相同
disable_mmu:
         mcr p15,0,r0,c7,c7,0 @Invalidate ICache and DCache
        @ 先读出到r0
        mrc p15, 0, r0, c1, c0, 0 @read control register
        bic r0,#0x7 @ 0:mmu 2:dcache

        @ 再写入
        mcr p15, 0, r0, c1, c0, 0 @write control register
        mov pc,lr 