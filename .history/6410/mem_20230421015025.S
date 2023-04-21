.text
.global mem_init

/*
 * SDRAM Controller
*/
@参照P192 5.4.1 5.4.3 完成初始化步骤
/*
    5.4.1 DRAM CONTROLLER INITIALIZATION SEQUENCE 
    • Program memc_cmd to ‘3’b100’, which makes DRAM Controller enter ‘Config’ state. 
    • Write memory timing parameter, chip configuration, and id configuration registers. 
    • Wait 200us to allow SDRAM power and clock to stabilize. However, when CPU starts working, power and 
    clock would already be stabilized. 
    • Execute memory initialization sequence. 
    • Program memc_cmd to ‘3’b000’, which makes DRAM Controller enter ‘Ready’ state. 
    • Check memory status field in memc_stat until memory status becomes ‘2’b01’, which means ‘Ready’. 
 */

/*
 
 5.4.3 DDR/MOBILE DDR SDRAM INITIALIZATION SEQUENCE 
• Program mem_cmd in direct_cmd to ‘2’b10’, which makes DRAM Controller issue ‘NOP’ memory command. 
• Program mem_cmd in direct_cmd to ‘2’b00’, which makes DRAM Controller issue ‘Prechargeall’ memory 
command. 
• Program mem_cmd in direct_cmd to ‘2’b11’, which makes DRAM Controller issue ‘Autorefresh’ memory 
command. 
• Program mem_cmd in direct_cmd to ‘2’b11’, which makes DRAM Controller issue ‘Autorefresh’ memory 
command. 
• Program mem_cmd to ‘2’b10’ in direct_cmd, which makes DRAM Controller issue ‘MRS’ memory command 
− Bank address for EMRS must be set. 
• Program mem_cmd to ‘2’b10’ in direct_cmd, which makes DRAM Controller issue ‘MRS’ memory command. 
− Bank address for MRS must be set. 
 
 
 
*/
#define ELFIN_DMC1_BASE		0x7e001000
#define INDEX_DMC_MEMC_CMD      0x04
#define INDEX_DMC_REFRESH_PRD   (0x10)

/* input clock of PLL */
#define CONFIG_SYS_CLK_FREQ	12000000
#define PLL_SDIV_532	2
#define PLL_PDIV_532	3
#define PLL_MDIV_532	532
#define Startup_MPLL	(((CONFIG_SYS_CLK_FREQ>>PLL_SDIV_532)/PLL_PDIV_532)*PLL_MDIV_532)
/* Clock divisions */
#define Startup_ARM_DIV     	0
#define Startup_AXI_DIV     	3
#define Startup_ARMCLK   	(Startup_MPLL/(Startup_ARM_DIV+1)
#define Startup_HCLK        (Startup_ARMCLK/(Startup_AXI_DIV+1))

#define DMC_DDR_REFRESH_PRD	(((Startup_HCLK/1000*DDR_tREFRESH)-1)/1000000) 	// TRM 2656

mem_init:
    ldr r0,0x7E001004
    mov r1,#0x4
    str r1,[r0]
	@P193 P1MEMCCMD 0x7E001004 
	@Program memc_cmd to ‘3’b100’, which makes DRAM Controller enter ‘Config’ state.
    ldr	r0, =ELFIN_DMC1_BASE			@DMC1 base address 0x7e001000
	ldr	r1, =0x04
	str	r1, [r0, #INDEX_DMC_MEMC_CMD]

    @• Write memory timing parameter, chip configuration, and id configuration registers. 
	@P196  P1REFRESH 0x7E001010
	ldr	r1, =DMC_DDR_REFRESH_PRD
	str	r1, [r0, #INDEX_DMC_REFRESH_PRD]

	ldr	r1, =DMC_DDR_CAS_LATENCY
	str	r1, [r0, #INDEX_DMC_CAS_LATENCY]

	ldr	r1, =DMC_DDR_t_DQSS
	str	r1, [r0, #INDEX_DMC_T_DQSS]

	ldr	r1, =DMC_DDR_t_MRD
	str	r1, [r0, #INDEX_DMC_T_MRD]

	ldr	r1, =DMC_DDR_t_RAS
	str	r1, [r0, #INDEX_DMC_T_RAS]

	ldr	r1, =DMC_DDR_t_RC
	str	r1, [r0, #INDEX_DMC_T_RC]

	ldr	r1, =DMC_DDR_t_RCD
	ldr	r2, =DMC_DDR_schedule_RCD
	orr	r1, r1, r2
	str	r1, [r0, #INDEX_DMC_T_RCD]

	ldr	r1, =DMC_DDR_t_RFC
	ldr	r2, =DMC_DDR_schedule_RFC
	orr	r1, r1, r2
	str	r1, [r0, #INDEX_DMC_T_RFC]

	ldr	r1, =DMC_DDR_t_RP
	ldr	r2, =DMC_DDR_schedule_RP
	orr	r1, r1, r2
	str	r1, [r0, #INDEX_DMC_T_RP]

	ldr	r1, =DMC_DDR_t_RRD
	str	r1, [r0, #INDEX_DMC_T_RRD]

	ldr	r1, =DMC_DDR_t_WR
	str	r1, [r0, #INDEX_DMC_T_WR]

	ldr	r1, =DMC_DDR_t_WTR
	str	r1, [r0, #INDEX_DMC_T_WTR]

	ldr	r1, =DMC_DDR_t_XP
	str	r1, [r0, #INDEX_DMC_T_XP]

	ldr	r1, =DMC_DDR_t_XSR
	str	r1, [r0, #INDEX_DMC_T_XSR]

	ldr	r1, =DMC_DDR_t_ESR
	str	r1, [r0, #INDEX_DMC_T_ESR]

	ldr	r1, =DMC1_MEM_CFG
	str	r1, [r0, #INDEX_DMC_MEMORY_CFG]

	ldr	r1, =DMC1_MEM_CFG2
	str	r1, [r0, #INDEX_DMC_MEMORY_CFG2]

	ldr	r1, =DMC1_CHIP0_CFG
	str	r1, [r0, #INDEX_DMC_CHIP_0_CFG]

	ldr	r1, =DMC_DDR_32_CFG
	str	r1, [r0, #INDEX_DMC_USER_CONFIG]



	@Execute memory initialization sequence. 



	@Program memc_cmd to ‘3’b000’, which makes DRAM Controller enter ‘Ready’ state. 



    @Check memory status field in memc_stat until memory status becomes ‘2’b01’, which means ‘Ready’. 


    mov pc,lr