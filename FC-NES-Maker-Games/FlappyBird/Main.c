#include "mylib.c"
extern u8 map_nam_s, map_col_s, map_atb_s;

// 需进行去地址操作
#define map_nam (&map_nam_s)
#define map_col (&map_col_s)
#define map_atb (&map_atb_s)


u8 PPUR1 = 0, PPUR2 = 0, scroll_x = 0;
u8 key, okey;
SPRITE sp0;

#define NMI_ENABLE()	{PPUR1 |= REG_1_VBlank_able; address(PPU_ctrl_reg_1) = PPUR1;}
#define NMI_DISABLE()	{PPUR1 &= ~REG_1_VBlank_able; address(PPU_ctrl_reg_1) = PPUR1;}

// 判断当前是否是名字表0
#define IS_NAME0()	((PPUR1 & REG_1_name) == REG_1_name_0)

void switchname()
{
	if(IS_NAME0()){
		// 切到1
		PPUR1 &= ~REG_1_name;
		PPUR1 |= REG_1_name_1;
	}
	else{
		// 切到0
		PPUR1 &= ~REG_1_name;
		PPUR1 |= REG_1_name_0;
	}
}

// 背景右移
void scrright()
{
	if(scroll_x == 255){
		switchname();
		scroll_x = 0;
	}
	else{
		++scroll_x;
	}
}

// 背景左移
void scrleft()
{
	if(scroll_x == 0){
		switchname();
		scroll_x = 255;
	}
	else{
		--scroll_x;
	}
}

void keyproc()
{
	if(presskey(button_RIGHT)){
		scrright();
	}
	else if(presskey(button_LEFT)){
		scrleft();
	}
}

u8 i;
u8 ch;
void mynmi()
{
	if(scroll_x%8==0){
		if(IS_NAME0()){
			set_VRAM_add(VRAM_name_1+scroll_x/8);
		}
		else{
			set_VRAM_add(VRAM_name_0+scroll_x/8);
		}
		if(rnd(2))
			ch = '#';
		else
			ch = 0x00;
		for(i=0; i<10; ++i){
			address(PPU_memory_dat) = ch;
		}
	}
	set_scroll(scroll_x,0);
	address(PPU_ctrl_reg_2) = PPUR2;
	address(PPU_ctrl_reg_1) = PPUR1;
}

void main()
{
	u8 ix=0;
	u8 tof = 0xA0;
	PPUR2 = 0x00;
	NMI_DISABLE();
	// 加载背景
	load_name_table_0(map_nam);	// 命名表
	load_name_attr_0(map_atb);	// 属性表
	load_BG_palette(map_col);	// 调色
	
	
	load_SP_palette(map_col);
	
	load_name_table_1(map_nam+name_length);
	load_name_attr_1(map_atb+palette_len);
	
	NMI_ENABLE();
	PPUR1 |= REG_1_inc_32;
	PPUR2 = REG_2_IM_able | REG_2_show_all_IM | REG_2_SP_able | REG_2_show_all_SP;
	//address(PPU_ctrl_reg_2) = REG_2_IM_able;
	gotoxy(10,10);
	cprintf("Hello World!!!");
	for(;;){
		key = read_joy();
		scrright();
		waitvblank();
		++ix;
		okey = key;
	}
}
