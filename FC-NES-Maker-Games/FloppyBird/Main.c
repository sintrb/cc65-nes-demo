#include "mylib.c"
extern u8 map_nam_s, map_col_s, map_atb_s;

// 需进行去地址操作
#define map_nam (&map_nam_s)
#define map_col (&map_col_s)
#define map_atb (&map_atb_s)


u8 PPUR1 = 0, PPUR2 = 0, scroll_x = 0;
u8 key, okey;

#define NMI_ENABLE()	{PPUR1 |= REG_1_VBlank_able; address(PPU_ctrl_reg_1) = PPUR1;}
#define NMI_DISABLE()	{PPUR1 &= ~REG_1_VBlank_able; address(PPU_ctrl_reg_1) = PPUR1;}




void mynmi()
{
	set_scroll(scroll_x,0);
	address(PPU_ctrl_reg_2) = PPUR2;
	address(PPU_ctrl_reg_1) = PPUR1;
}

void main()
{
	PPUR2 = 0x00;
	NMI_DISABLE();
	// 加载背景
	load_name_table_0(map_nam);
	load_name_attr_0(map_atb);
	load_BG_palette(map_col);
	
	load_name_table_1(map_nam+name_length);
	load_name_attr_1(map_atb+palette_len);
	
	NMI_ENABLE();
	PPUR2 = REG_2_IM_able;
	//address(PPU_ctrl_reg_2) = REG_2_IM_able;
	gotoxy(10,10);
	cprintf("Hello World!!!");
	for(;;){
		key = read_joy();
		if(presskey(button_RIGHT))
			++scroll_x;
		else if(presskey(button_LEFT))
			--scroll_x;	
		waitvblank();
		
		okey = key;
	}
}
