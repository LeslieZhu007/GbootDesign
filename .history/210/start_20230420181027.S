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
        bl init_clock
        bl light_led

set_svc:
        mrs r0,cpsr
        bic r0,#0x1f
        orr r0,#0xD3  @I F T M[4:0] ====>  110 10011 
        msr cpsr,r0
        mov pc,lr 

@210 P828
#define pWTCON  0xE2700000
disable_watchdog:
        ldr r0,=pWTCON
        mov r1,#0x0
        str r1,[r0]
        mov pc,lr 

@210 P579 四组寄存器
disable_interrupt:
        mvn r1,#0x0
        ldr r0,=0xF2000014
        str r1,[r0]
        ldr r0,=0xF2100014
        str r1,[r0]
        ldr r0,=0xF2200014
        str r1,[r0]
        ldr r0,=0xF2300014
        str r1,[r0]
        mov pc,lr 

@cortex_a8_r3p2_trm P122 P86
disable_mmu:
        @根据P147进行修改
        @Invalidate ICache
        mcr p15,0,r0,c7,c5,0
        @Invalidate DCache
         mcr p15,0,r0,c7,c6,1 
        /***************** */
        @ 先读出到r0
        mrc p15, 0, r0, c1, c0, 0 @read control register
        bic r0,#0x7 @ 0:mmu 2:dcache

        @ 再写入
        mcr p15, 0, r0, c1, c0, 0 @write control register
        mov pc,lr 

/*
        LED1 GPJ2_0
        LED2 GPJ2_1
        LED3 GPJ2_2
        LED4 GPJ2_3
*/
#define GPJ2CON 0xE0200280
#define GPJ2DAT 0xE0200284
light_led:
        ldr r0,=GPJ2CON 
        ldr r1,=0x1111
        str r1,[r0]


        ldr r0,=GPJ2DAT 
        ldr r1,=0xf
        str r1,[r0]
        mov pc,lr

#define CLK_DIV0  0xE0100300 @P387
/*
210 uboot代码:
lowlevel_init.S
203 system_clock_init
227 ldr r2,=CLK_DIV0_VAL 

smart210.h
/* CLK_DIV0 */
#define APLL_RATIO	0
#define A2M_RATIO	4
#define HCLK_MSYS_RATIO	8
#define PCLK_MSYS_RATIO	12
#define HCLK_DSYS_RATIO	16
#define PCLK_DSYS_RATIO 20
#define HCLK_PSYS_RATIO	24
#define PCLK_PSYS_RATIO 28
#define CLK_DIV0_VAL    ((0<<APLL_RATIO)|(4<<A2M_RATIO)|(4<<HCLK_MSYS_RATIO)|(1<<PCLK_MSYS_RATIO)\
			|(3<<HCLK_DSYS_RATIO)|(1<<PCLK_DSYS_RATIO)|(4<<HCLK_PSYS_RATIO)|(1<<PCLK_PSYS_RATIO))


结合手册 P387
*/
#define DIV_VAL ((0<<0)|(4<<4)|(4<<8)|(1<<12)\
			|(3<<16)|(1<<20)|(4<<24)|(1<<28))

#define APLL_CON0 0xE0100100
#define APLL_VAL ((1<<31)| (3<<8) | (125<<16) | (1<<0))

init_clock:
        @lock time有默认值，不需设置

        @设置分频系数
        ldr r0,=CLK_DIV0
        ldr r1,=DIV_VAL
        str r1,[r0] 

        @无需设置处理器异步工作模式

        @设置时钟  APLL MPLL输出频率    
        @APLL
        
        mov pc,lr