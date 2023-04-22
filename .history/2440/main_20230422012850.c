#define GPBCON (volatile unsigned long *)0x56000010
#define GPBDAT (volatile unsigned long *)0x56000014
int gboot_main()
{
    // *GPBCON =  0x15400;
    // *GPBDAT = 0x61F;
//直接调用汇编中的函数
    
    return 0;
}