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
        bl set_peri_port  @设置外设基地址   Arm1176jzfs.pdf   P263
        bl disable_watchdog
        bl disable_interrupt
        bl disable_mmu
        bl clock_init
        bl mem_init
        bl copy_to_ram
        bl init_stack
        bl light_led
        mov pc,lr 

set_svc:
        mrs r0,cpsr
        bic r0,#0x1f
        orr r0,#0xD3  @I F T M[4:0] ====>  110 10011 
        msr cpsr,r0
        mov pc,lr 

set_peri_port:
        ldr r0, =0x70000000  @基地址
        orr r0, #0x13   @b10011 大小:256M
        mcr p15,0,r0,c15,c2,4
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

#define GPKCON 0x7F008800
#define GPKDAT 0x7F008808
light_led:
        ldr r0,=GPKCON
        ldr r1,= 0x11110000
        str r1,[r0]

        ldr r0,=GPKDAT
        ldr r1,= 0xA0
        str r1,[r0]
        mov pc,lr

#define CLK_DIV0 0x7e00f020
@参照ubooot lowlevel_init.s得到分频系数
#define DIV_VAL ((0x0<<0) | (0x1<<9) | (0x1<<8) | (0x3<<12))
#define OTHERS 0x7E00F900
#define MPLL_CON  0x7E00F010
#define APLL_CON  0x7E00F00C
#define PLL_VAL ((1<<31) | (266<<16) | (3<<8) | (1<<0)) @参照P142 MPLL APLL都设置为533MHZ
#define CLK_SRC 0x7E00F01C
clock_init:
        @设置lock time   采用默认值

        @设置分频系数
        ldr r0,=CLK_DIV0
        ldr r1,=DIV_VAL
        str r1,[r0]

        @设置CPU异步工作模式
        ldr r0,=OTHERS  @第六第七位都需要设置,参考图3-5查看
        ldr r1,[r0]
        bic r1,#0xc0
        str r1,[r0]

        @设置APLL MPLL
        ldr r0,=APLL_CON
        ldr r1,=PLL_VAL
        str r1,[r0]

        ldr r0,=MPLL_CON
        ldr r1,=PLL_VAL
        str r1,[r0]

        @设置CLK_SRC寄存器
        ldr r0,=CLK_SRC
        mov r1,#0x3
        str r1,[r0]

        mov pc,lr

copy_to_ram:
        @stepping stone: 0x0c000000
        ldr r0,=0x0c000000
        ldr r1,=0x50008000
        @拷贝4k的gboot代码从stepping stone 到链接地址处
        add r3,r0,#1024*4
copy_loop:
        ldr r2,[r0],#4
        str r2,[r1],#4
        cmp r0,r3
        bne copy_loop

        mov pc,lr


@2440 6410 210 统一在内存地址+64M空间
init_stack:
        ldr sp,0x54000000
        mov pc,lr