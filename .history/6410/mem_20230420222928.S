.text
.global mem_init

/*
 * SDRAM Controller
 */
#define ELFIN_DMC0_BASE		0x7e000000
#define ELFIN_DMC1_BASE		0x7e001000

#define INDEX_DMC_MEMC_STATUS   (0x00)
#define INDEX_DMC_MEMC_CMD      (0x04)
#define INDEX_DMC_DIRECT_CMD    (0x08)
#define INDEX_DMC_MEMORY_CFG    (0x0C)
#define INDEX_DMC_REFRESH_PRD   (0x10)
#define INDEX_DMC_CAS_LATENCY   (0x14)
#define INDEX_DMC_T_DQSS        (0x18)
#define INDEX_DMC_T_MRD         (0x1C)
#define INDEX_DMC_T_RAS         (0x20)
#define INDEX_DMC_T_RC          (0x24)
#define INDEX_DMC_T_RCD         (0x28)
#define INDEX_DMC_T_RFC         (0x2C)
#define INDEX_DMC_T_RP          (0x30)
#define INDEX_DMC_T_RRD         (0x34)
#define INDEX_DMC_T_WR          (0x38)
#define INDEX_DMC_T_WTR         (0x3C)
#define INDEX_DMC_T_XP          (0x40)
#define INDEX_DMC_T_XSR         (0x44)
#define INDEX_DMC_T_ESR         (0x48)
#define INDEX_DMC_MEMORY_CFG2	(0x4C)
#define INDEX_DMC_CHIP_0_CFG    (0x200)
#define INDEX_DMC_CHIP_1_CFG    (0x204)
#define INDEX_DMC_CHIP_2_CFG    (0x208)
#define INDEX_DMC_CHIP_3_CFG    (0x20C)
#define INDEX_DMC_USER_STATUS	(0x300)
#define INDEX_DMC_USER_CONFIG	(0x304)

/*
* Memory Chip direct command
*/
#define DMC_NOP0 			0x0c0000
#define DMC_NOP1			0x1c0000
#define DMC_PA0 			0x000000	//Precharge all
#define DMC_PA1 			0x100000
#define DMC_AR0 			0x040000	//Autorefresh
#define DMC_AR1 			0x140000
#define DMC_SDR_MR0			0x080032	//MRS, CAS 3,  Burst Length 4
#define DMC_SDR_MR1			0x180032
#define DMC_DDR_MR0			0x080162
#define DMC_DDR_MR1			0x180162
#define DMC_mDDR_MR0			0x080032	//CAS 3, Burst Length 4
#define DMC_mDDR_MR1			0x180032
#define DMC_mSDR_EMR0			0x0a0000	//EMRS, DS:Full, PASR:Full Array
#define DMC_mSDR_EMR1			0x1a0000
#define DMC_DDR_EMR0			0x090000
#define DMC_DDR_EMR1			0x190000
#define DMC_mDDR_EMR0			0x0a0000	// DS:Full, PASR:Full Array
#define DMC_mDDR_EMR1			0x1a0000
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

mem_init:
    ldr r0,0x7E001004
    mov r1,#0x4
    str r1,[r0]

    @• Write memory timing parameter, chip configuration, and id configuration registers. 
    








    mov pc,lr