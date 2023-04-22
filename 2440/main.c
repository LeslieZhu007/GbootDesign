// #define GPBCON (volatile unsigned long *)0x56000010
// #define GPBDAT (volatile unsigned long *)0x56000014
#define GPBCON 0x56000010
#define GPBDAT 0x56000014

int gboot_main()
{
    // *GPBCON =  0x15400;
    // *GPBDAT = 0x61F;
//直接调用汇编中的函数
    //light_led();

    /*
        __asm__ volatile(
            汇编语句部分
            :输出部分
            :输入部分
            :破坏描述部分
        );
    */
   //使用内嵌汇编点亮LED    
    __asm__ volatile (
        "ldr r0, =GPBCON\n"
        "ldr r1, = 0x15400\n" 
        "str r1,[r0]\n"
        "ldr r0, =GPBDAT\n"
        "ldr r1, = 0x61F\n"
        "str r1,[r0]\n"
        "mov pc,lr\n"
    );

    return 0;
}