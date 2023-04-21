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
 
 
 
 
 
*/

mem_init:
    ldr r0,0x7e001004
    mov r1,#0x4
    str r1,[r0]









    mov pc,lr