#include <conio.h>

// 全局变量
unsigned int nmict = 0;

// 中断函数
void mynmi()
{
	++nmict;
}

void main()
{
	while(1){
		// 输出一下
		gotoxy(10,10);
		cprintf("nmict=%05d", nmict);
	}
}
