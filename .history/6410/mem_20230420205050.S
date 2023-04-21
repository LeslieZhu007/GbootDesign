.text
.global mem_init
mem_init:
    ldr r0,0x7e001004
    mov r1,#0x4
    str r1,[r0]









    mov pc,lr