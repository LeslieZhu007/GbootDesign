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
/* DDR Parameters */
#define DDR_tREFRESH	7500		/* ns */
#define DMC_DDR_REFRESH_PRD	(((Startup_HCLK/1000*DDR_tREFRESH)-1)/1000000) 	// TRM 2656


#define INDEX_DMC_CAS_LATENCY   (0x14)
#define DDR_CASL		3			/* CAS Latency 3 */
#define DMC_DDR_CAS_LATENCY	(DDR_CASL<<1)					//6   Set Cas Latency to 3

#define INDEX_DMC_T_DQSS        (0x18)
#define DMC_DDR_t_DQSS		1						// Min 0.75 ~ 1.25

#define INDEX_DMC_T_MRD         (0x1C)
#define DMC_DDR_t_MRD		2						//Min 2 tck

#define INDEX_DMC_T_RAS         (0x20)

#define DDR_tRAS		60			/* ns (min: 45ns)*/
#define DMC_DDR_t_RAS		(((Startup_HCLK/1000*DDR_tRAS)-1)/1000000+1)	 //7, Min 45ns


#define INDEX_DMC_T_RC          (0x24)
#define DDR_tRC 			80			/* ns (min: 67.5ns)*/
#define DMC_DDR_t_RC		(((Startup_HCLK/1000*DDR_tRC)-1)/1000000+1) 	//10, Min 67.5ns


#define INDEX_DMC_T_RCD         (0x28)
#define DDR_tRCD		30			/* ns (min: 22.5ns)*/
#define DMC_DDR_t_RCD		(((Startup_HCLK/1000*DDR_tRCD)-1)/1000000+1) 	//4,5(TRM), Min 22.5ns
#define DMC_DDR_schedule_RCD	((DMC_DDR_t_RCD -3) <<3)

#define INDEX_DMC_T_RFC         (0x2C)

#define DMC_DDR_t_RFC		(((Startup_HCLK/1000*DDR_tRFC)-1)/1000000+1) 	//11,18(TRM) Min 80ns
#define DMC_DDR_schedule_RFC	((DMC_DDR_t_RFC -3) <<5)


#define DDR_tRP 			30			/* ns (min: 22.5ns)*/
#define DMC_DDR_t_RP		(((Startup_HCLK/1000*DDR_tRP)-1)/1000000+1) 	//4, 5(TRM) Min 22.5ns
#define DMC_DDR_schedule_RP	((DMC_DDR_t_RP -3) << 3)
#define INDEX_DMC_T_RP          (0x30)


#define INDEX_DMC_T_RRD         (0x34)
#define DDR_tRRD		25			/* ns (min: 15ns)*/
#define DMC_DDR_t_RRD		(((Startup_HCLK/1000*DDR_tRRD)-1)/1000000+1)	//3, Min 15ns

#define INDEX_DMC_T_WR          (0x38)
#define DDR_tWR 			25			/* ns (min: 15ns)*/
#define DMC_DDR_t_WR		(((Startup_HCLK/1000*DDR_tWR)-1)/1000000+1)	//Min 15ns


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

	@P196  CAS LATENCY REGISTER  P1CASLAT 0x7E001014 
	ldr	r1, =DMC_DDR_CAS_LATENCY
	str	r1, [r0, #INDEX_DMC_CAS_LATENCY]

	@P197 T_DQSS REGISTER    P1T_DQSS 0x7E001018 
	ldr	r1, =DMC_DDR_t_DQSS
	str	r1, [r0, #INDEX_DMC_T_DQSS]

	@P197  T_MRD REGISTER  P1T_MRD 0x7E00101C 
	ldr	r1, =DMC_DDR_t_MRD
	str	r1, [r0, #INDEX_DMC_T_MRD]

	@197  T_RAS REGISTER  P1T_RAS 0x7E001020  
	ldr	r1, =DMC_DDR_t_RAS
	str	r1, [r0, #INDEX_DMC_T_RAS]

	@P198 T_RC REGISTER  P1T_RC 0x7E001024
	ldr	r1, =DMC_DDR_t_RC
	str	r1, [r0, #INDEX_DMC_T_RC]


	@P198 T_RCD REGISTER  P1T_RCD 0x7E001028 
	ldr	r1, =DMC_DDR_t_RCD
	ldr	r2, =DMC_DDR_schedule_RCD
	orr	r1, r1, r2
	str	r1, [r0, #INDEX_DMC_T_RCD]

	@P198  T_RFC REGISTER  P1T_RFC 0x7E00102C 
	ldr	r1, =DMC_DDR_t_RFC
	ldr	r2, =DMC_DDR_schedule_RFC
	orr	r1, r1, r2
	str	r1, [r0, #INDEX_DMC_T_RFC]

	@P198  T_RP REGISTER   P1T_RP 0x7E001030
	ldr	r1, =DMC_DDR_t_RP
	ldr	r2, =DMC_DDR_schedule_RP
	orr	r1, r1, r2
	str	r1, [r0, #INDEX_DMC_T_RP]

	@P199  T_RRD REGISTER  P1T_RRD 0x7E001034 
	ldr	r1, =DMC_DDR_t_RRD
	str	r1, [r0, #INDEX_DMC_T_RRD]

	@P199 T_WR REGISTER  P1T_WR 0x7E001038
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