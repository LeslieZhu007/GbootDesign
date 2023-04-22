#define GPBCON (volatile unsigned long *)0x56000010
#define GPBDAT (volatile unsigned long *)0x56000014
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

    return 0;
}