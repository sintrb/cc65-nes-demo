#include <conio.h>

// 直接访问地址（寄存器）
#define REG(_addr)	(*((u8*)(_addr)))
// 手柄1寄存器
#define JOY1	0x4016

typedef unsigned char u8;
typedef unsigned int u16;

// 一个全局的页号，0或者1之间切换
u8 num = 0;

// 手柄1
u8 joy1()
{
	u8 n=8,joy_state=0;
	REG(JOY1)=01;
	REG(JOY1)=00;
	while(n){
		joy_state=(joy_state<<1)|REG(JOY1)&1;
		--n;
	}
	return joy_state;
}

// 延时
void delay(u16 ct)
{
	while(ct--)
		waitvblank();
}

void mynmi()
{
	REG(0x8000) = num; // 将页码写到$8000寄存器开始切页
}

void main()
{
	
	gotoxy(10,5);
	cprintf("Mapper3 Demo");
	gotoxy(6,7);
	cprintf("It's failed on FCEUX");
	gotoxy(9,9);
	cprintf("Try VirtuaNES");
	gotoxy(6,12);
	cprintf("Any Key To Change CHR");
	while(1){
		if(joy1()){
			// 让num在0和1之间循环（因为我们只有两页chr）
			++num;
			num &= 0x01;
			
			
			// 
			gotoxy(13,14);
			cprintf("num:%02x", num);
			
			// 延时一下不然切太快了
			delay(10);
		}
	}
}
