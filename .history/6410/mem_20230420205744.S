.text
.global mem_init
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