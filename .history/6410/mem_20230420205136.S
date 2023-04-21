.text
.global mem_init
@参照P192 5.4.1 5.4.2 完成初始化步骤
mem_init:
    ldr r0,0x7e001004
    mov r1,#0x4
    str r1,[r0]









    mov pc,lr