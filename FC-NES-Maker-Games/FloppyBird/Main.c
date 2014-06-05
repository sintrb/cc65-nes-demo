#include "mylib.c"
extern u8 map_nam_s, map_col_s, map_atb_s;

// 需进行去地址操作
#define map_nam (&map_nam_s)
#define map_col (&map_col_s)
#define map_atb (&map_atb_s)

void main()
{
	address(PPU_ctrl_reg_1) = 0x00;
	address(PPU_ctrl_reg_2) = 0x00;
	// 加载背景
	load_name_table_0(map_nam);
	load_BG_palette(map_col);
	address(PPU_ctrl_reg_2) = REG_2_IM_able;
	gotoxy(10,10);
	cprintf("Hello World!!!");
	while(1);
}
