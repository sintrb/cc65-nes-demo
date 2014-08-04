#include "sinnes.h"
extern u8 map_nam_s, map_col_s, sp_col_s, map_atb_s, about_nam_s, about_col_s, about_atb_s;

// 需进行去地址操作
#define map_nam (&map_nam_s)
#define map_col (&map_col_s)
#define sp_col	(&sp_col_s)
#define map_atb (&map_atb_s)

#define about_nam (&about_nam_s)
#define about_atb (&about_atb_s)
#define about_col (&about_col_s)


#define NMI_ENABLE()	{PC1_VAL |= PC1_NMI; address(PPU_CTRL1) = PC1_VAL;}
#define NMI_DISABLE()	{PC1_VAL &= ~PC1_NMI; address(PPU_CTRL1) = PC1_VAL;}

// 判断当前是否是名字表0
#define IS_NAME0()	((PC1_VAL & PC1_NAME_MASK) == PC1_NAME0)

typedef struct // sprite struct
{
	u8 y; // y
	u8 tile; // tile #
	u8 attr; // attribute: vhp000cc(V turn, H turn,  priorite, 000 , high 2 bits of color)
	u8 x; // x
}t_sprite;

#define SP_ATTR_VTURN	0x80	// V turn
#define SP_ATTR_HTURN	0x40	// H turn
#define SP_ATTR_PRI		0x20	// priorite
#define SP_ATTR_COL		0x03	// high 2 bits of color

#define sp	((t_sprite*)0x0200)

#define SP_MIDLEX	0x70
#define SP_MAXACC	24	// 最大重力加速度
#define SP_MINACC	-26	// 最小重力加速度（跃起速度）
#define SP_Y_MIN	0x06
#define SP_Y_MAX	0xC4


#define SP_IX_BIRD	0x01
#define SP_IX_SCORE	0x05
#define SP_IX_SCORE_H	(SP_IX_SCORE+8)

typedef struct{
	u8 length;	// length(count) of data bytes
	u8 *rambuf;	// data buf in ram
	u16	vramst;	// vram start
}t_pputask;

#define TASKS_MAX	8	// max count of task
#define	tasks ((t_pputask*)0x0300)	// PPU任务队列


#define SCRREN_TITLNUM_V		26	// 有效屏幕高(单位8pix)
#define DOOR_HEIGHT				8	// 管道中间的缝隙间隔(单位8pix)
#define DOOR_SPACE_BLOCK		4	// 两管道出现的间隔(单位16pix)
#define DOOR_WIDTH				2	// 管道宽度(单位8pix)

u8 tiles_buf[2][SCRREN_TITLNUM_V];	// PPU任务缓冲
u8 door_buf[64/DOOR_WIDTH];	// 用来保存管道位置
int hiscore = 0;
void switchname()
{
	if(IS_NAME0()){
		// 切到1
		PC1_VAL &= ~PC1_NAME_MASK;
		PC1_VAL |= PC1_NAME1;
	}
	else{
		// 切到0
		PC1_VAL &= ~PC1_NAME_MASK;
		PC1_VAL |= PC1_NAME0;
	}
}


// 背景右移
void scrright()
{
	if(SOLX_VAL == 255){
		switchname();
	}
	++SOLX_VAL;
}

// 背景左移
void scrleft()
{
	if(SOLX_VAL == 0){
		switchname();
	}
	--SOLX_VAL;
}

// 横屏按键处理，没用到
void keyproc()
{
	if(JOY_VAL == JOY_RIGHT){
		scrright();
	}
	else if(JOY_VAL == JOY_LEFT){
		scrleft();
	}
}

// 设置精灵方块(16*16)的chr，使用从spix开始的4个精灵，精灵的chr索引为chrix
void sptile(u8 spix, u8 chrix)
{
	sp[spix].tile = chrix;
	sp[spix+1].tile = chrix+1;
	sp[spix+2].tile = chrix+0x10;
	sp[spix+3].tile = chrix+0x11;
}

// 设置精灵方块(16*16)的坐标，使用从spix开始的4个精灵，左上角的精灵位置为(x,y)
void splocal(u8 spix, u8 x, u8 y)
{
	sp[spix].x = x;
	sp[spix].y = y;
	sp[spix+1].x = x+8;
	sp[spix+1].y = y;
	sp[spix+2].x = x;
	sp[spix+2].y = y+8;
	sp[spix+3].x = x+8;
	sp[spix+3].y = y+8;
}

// 将spix开始的n个精灵设置到统一水平线上
void sphline(u8 spix, u8 x, u8 y, u8 n)
{
	u8 i;
	for(i=0; i<n; ++i, ++spix){
		sp[spix].x = x+8*i;
		sp[spix].y = y;
	}
}

// 随机数
const u8 rnds[] = {0xfe, 0xc9, 0xd4, 0x45, 0xd8, 0xf6, 0x4e, 0x89, 0x3a, 0x1b, 0x36, 0x16, 0xbd, 0xc5, 0xc1, 0x73, 0xdb, 0xb2, 0xda, 0xcd, 0x3a, 0x7e, 0x97, 0x64, 0x22, 0x01, 0x1f, 0x87, 0x48, 0xb5, 0xc7, 0xdd, 0x90, 0xe4, 0xc4, 0x6f, 0xe1, 0x95, 0x8f, 0x29, 0xbd, 0x6b, 0x49, 0x8d, 0x7c, 0xc0, 0x62, 0x38, 0x87, 0x7d, 0xbd, 0xdc, 0x0f, 0xbe, 0x54, 0x43, 0x18, 0xbf, 0x7e, 0x8e, 0xfb, 0x65, 0xa9, 0xde, 0xc8, 0x85, 0xb5, 0x43, 0xd1, 0x23, 0xeb, 0x28, 0x03, 0x9e, 0x08, 0xb5, 0x53, 0x57, 0x57, 0x86, 0xf7, 0x32, 0xf9, 0xa3, 0x38, 0xa6, 0xbf, 0xf9, 0x07, 0x2c, 0xa4, 0x78, 0x81, 0x17, 0xaa, 0x6c, 0x00, 0x5b, 0x29, 0x48, 0x27, 0x0c, 0xa5, 0x51, 0x15, 0x01, 0xc8, 0x95, 0x5e, 0xb5, 0x70, 0x23, 0x91, 0xfc, 0x08, 0x33, 0x51, 0x68, 0x19, 0x25, 0x90, 0x94, 0xc1, 0xa5, 0x57, 0xd7, 0x52, 0xdf, 0x88, 0xd7, 0x5d, 0x3b, 0xe6, 0xc1, 0x92, 0x0d, 0x94, 0x91, 0xfb, 0x3d, 0x26, 0x43, 0xfa, 0x4d, 0xb6, 0x51, 0x0d, 0xac, 0x6f, 0x3d, 0x32, 0xb7, 0x1d, 0x25, 0x18, 0x82, 0x0e, 0x3e, 0x03, 0x0e, 0x9c, 0x1c, 0x27, 0x13, 0x40, 0xeb, 0xa7, 0x50, 0x53, 0x29, 0x58, 0x7f, 0xaa, 0xf2, 0x2f, 0x3c, 0x1a, 0xe4, 0x61, 0xe0, 0xef, 0x86, 0x09, 0xba, 0x4c, 0xfd, 0xc5, 0xbf, 0x71, 0x75, 0x3e, 0x0e, 0x82, 0xc2, 0xa5, 0xe7, 0x5a, 0x34, 0x32, 0xd0, 0xec, 0x54, 0xe7, 0x66, 0x5b, 0x3e, 0xf5, 0xc6, 0x35, 0x74, 0x2c, 0xba, 0x89, 0x49, 0xbd, 0xca, 0x80, 0xb1, 0x7e, 0x0d, 0x60, 0xec, 0x1e, 0xf7, 0xd4, 0x3d, 0x88, 0xfb, 0x1d, 0xbe, 0x1a, 0x58, 0x07, 0x8f, 0x23, 0x14, 0x3d, 0x47, 0x91, 0x75, 0xd9, 0x28, 0x02, 0x4f, 0xff, 0x8b, 0x94, 0x46, 0x3e, 0x14, 0x25, 0xb3, 0x31, 0xf7, 0x19, 0xb6};
// 随机数种子
u8 rndsd = 0;
// 返回一个不大于below的随机数
u8 rnd(u8 below)
{
	static u8 ix = 0;
	++ix;
	return rnds[rndsd+ix]%below;
}

// 将分数通过精灵输出
void score2sp(u8 spix, int score)
{
	sp[spix+0].tile = score/1000;
	sp[spix+1].tile = (score-(sp[spix+0].tile*1000))/100;
	sp[spix+2].tile = (score-(sp[spix+0].tile*1000 + sp[spix+1].tile*100))/10;
	sp[spix+3].tile = score%10;
	
	sp[spix+0].tile = sp[spix+0].tile + '0';
	sp[spix+1].tile = sp[spix+1].tile + '0';
	sp[spix+2].tile = sp[spix+2].tile + '0';
	sp[spix+3].tile = sp[spix+3].tile + '0';
}

// 等待START按键并释放
void waitstartkey()
{
	for(;readjoy()!=JOY_START;);
	for(;readjoy()==JOY_START;);
}

// 游戏结束
void over(int score)
{
	u8 ix, i;
	ix = SP_IX_SCORE;
	fillram(sp, 0x100, 0x00);	// 清空精灵缓存
	
	sp[ix++].tile = 'S';
	sp[ix++].tile = 'C';
	sp[ix++].tile = 'O';
	sp[ix++].tile = ':';
	score2sp(ix, score);
	waitvblank();
	sphline(SP_IX_SCORE, 96,50,8);
	ix += 4;

		// 保存最高分
	if(score > hiscore){
		// 破纪录，高分颜色变为红色
		hiscore = score;
		for(i=0; i<8; ++i){
			sp[SP_IX_SCORE_H+i].attr=0x03;
		}
	}
	else{
		// 没破记录，默认色
		for(i=0; i<8; ++i){
			sp[SP_IX_SCORE_H+i].attr=0x00;
		}
	}
	ix = SP_IX_SCORE_H;
	sp[ix++].tile = 'H';
	sp[ix++].tile = 'I';
	sp[ix++].tile = 'G';
	sp[ix++].tile = ':';
	score2sp(ix, hiscore);
	sphline(SP_IX_SCORE+8, 96,62,8);
	
	
	beep();
	
	waitstartkey();
}

// 载入背景
void loadmap()
{
	// 加载背景
	loadname0(map_nam);	// 命名表
	loadattr0(map_atb);	// 属性表
	
	loadbgpal(map_col);	// 背景调色
	loadsppal(sp_col);	// 精灵调色
	
	loadname1(map_nam+VRAM_NAME_LEN);
	loadattr1(map_atb+VRAM_ATTR_LEN);
}

// 关于
void about()
{
	REG(PPU_CTRL1) = 0x00;
	REG(PPU_CTRL2) = 0x00;
	loadname0(about_nam);
	loadattr0(about_atb);
	loadbgpal(about_col);
	setppusol(0,0);
	REG(PPU_CTRL1) = PC1_NAME0;
	REG(PPU_CTRL2) = PC2_SHOW_BG | PC2_SHOW_L8BG | PC2_SHOW_L8SP;
	for(;readjoy()!=JOY_START;);
	for(;readjoy()==JOY_START;);
	
	REG(PPU_CTRL1) = 0x00;
	REG(PPU_CTRL2) = 0x00;
	//loadmap();
	NMI_ENABLE();
}

// 游戏
void game()
{
	u8 spx=0xc0, ix, running=0, okey, i, n, m, loadedattr0=0, begined=0, started=0;
	int acc = 0;
	int spy = 0x58;
	int doory = 0;
	int score = 0;
	const u8 sps[] = {0x80, 0x82, 0x84};
	score = 0;
	
	// 关显示
	REG(PPU_CTRL1) = 0x00;
	REG(PPU_CTRL2) = 0x00;
	
	PC1_VAL = 0x00;
	PC2_VAL = 0x00;
	SOLX_VAL = 0x00;
	loadmap();
	
	fillram(sp, 0x100, 0x00);	// 清空精灵缓存
	fillram(tasks, 0x100, 0x00);	// 清空PPU任务
	
	tasks[0].rambuf = tiles_buf[0];
	tasks[1].rambuf = tiles_buf[1];

	
	sptile(SP_IX_BIRD, 0x80);
	splocal(SP_IX_BIRD, spx, spy);
	sp[SP_IX_SCORE+0].tile = 0;
	sp[SP_IX_SCORE+1].tile = 0;
	sp[SP_IX_SCORE+2].tile = 0;
	sp[SP_IX_SCORE+3].tile = 0;
	sphline(SP_IX_SCORE, 120,10,4);
	
	// 显示最高分
	sp[SP_IX_SCORE_H+0].tile = 'H';
	sp[SP_IX_SCORE_H+1].tile = 'I';
	sp[SP_IX_SCORE_H+2].tile = 'G';
	sp[SP_IX_SCORE_H+3].tile = ':';
	score2sp(SP_IX_SCORE_H+4, hiscore);
	sphline(SP_IX_SCORE_H, 96,62,8);
	
	// 开显示
	PC2_VAL = PC2_SHOW_BG | PC2_SHOW_L8BG | PC2_SHOW_SP | PC2_SHOW_L8SP;
	// nmi enable
	NMI_ENABLE();
	
	fillram(door_buf, sizeof(door_buf), 0);

	for(;;){
		//  先检查碰撞
		if(loadedattr0 && SOLX_VAL%16 == 0){
			// 16=2*8
			m = SOLX_VAL/16;
			if(m%DOOR_SPACE_BLOCK == 0){
				n = rnd(SCRREN_TITLNUM_V-DOOR_HEIGHT-1)+1;
				for(i=0; i<SCRREN_TITLNUM_V; ++i){
					if(i>n && i<(n+DOOR_HEIGHT)){
						tiles_buf[0][i] = 0x00;
						tiles_buf[1][i] = 0x00;
					}
					else{
						tiles_buf[0][i] = 0xaa;
						tiles_buf[1][i] = 0xab;
					}
				}
				tiles_buf[0][n] = 0xB8;
				tiles_buf[1][n] = 0xB9;
				
				tiles_buf[0][n+DOOR_HEIGHT] = 0xA8;
				tiles_buf[1][n+DOOR_HEIGHT] = 0xA9;
				
				// 标记空隙位置
				door_buf[m] = n;
			}
			else{
				for(i=0; i<SCRREN_TITLNUM_V; ++i){
					tiles_buf[0][i] = 0x00;
					tiles_buf[1][i] = 0x00;
				}
				
				// 没有管道
				door_buf[m] = 0;
			}
			if(IS_NAME0()){
				tasks[0].vramst = VRAM_NAME1+(SOLX_VAL/8);
			}
			else{
				tasks[0].vramst = VRAM_NAME0+(SOLX_VAL/8);
			}
			
			tasks[1].vramst = tasks[0].vramst+1;
			
			// already vram data
			// set length to notice nmi transfer data to vram
			tasks[1].length = tasks[0].length = SCRREN_TITLNUM_V;
		}
		
		n = SOLX_VAL + spx + 16; //(SOLX_VAL + spx +16 )>>4;
		m = n>>4;
		doory = door_buf[m];// ? door_buf[m]: door_buf[m+1];
		
		// up or down check
		if(spy<=SP_Y_MIN || spy>=SP_Y_MAX){
			break;
		}
		// door check
		if(doory){
			started = 1;
			doory *= 8;
			// +-2，正负2的容差
			if((spy-6+2)<doory || (spy-6-16-4-2)>(doory+DOOR_WIDTH*8)){
				break;
			}
		}

		if(loadedattr0 && SOLX_VAL%64==20 && started){
			// 过了一关
			++score;
			// write to sprite-buffer
			score2sp(SP_IX_SCORE, score);
			beep();
		}
		// 死亡状态判断完成
	
		
		// 根据按键计算下一帧数据
		
		readjoy();
		rndsd += 3; // 随机一下 
		switch(JOY_VAL){
			case JOY_LEFT:
				--spx;
				break;
			case JOY_RIGHT:
				++spx;
				break;
			case JOY_UP:
				--spy;
				break;
			case JOY_DOWN:
				++spy;
				break;
			case JOY_B:
			case JOY_A:
				if(okey != JOY_VAL){
					beep();
					acc = SP_MINACC;
				}
				-- rndsd; // 再随机一下
				ix = 0;
				break;
			case JOY_START:
				if(okey != JOY_VAL){
					running = !running;
					if(running && !begined){
						begined = 1;
						score2sp(SP_IX_SCORE, score);
						fillram(sp+SP_IX_SCORE_H, 0x04*8, 0x00);
					}
					beep();
				}
				break;
			case JOY_SELECT:
				if(!begined)
					about();
				return;
		}
		okey = getjoy();
		++ix;
		if(!running){
			waitvblank();
			sptile(1,sps[(ix>>2)%3]);
			continue;
		}
		
		scrright();
		if(spx>SP_MIDLEX)
			--spx;
		else if(!loadedattr0){
			tasks[2].vramst = VRAM_ATTR0;
			tasks[2].rambuf = map_atb+VRAM_ATTR_LEN;
			tasks[2].length = VRAM_ATTR_LEN;
			loadedattr0 = 1;
			waitvblank();
			PC1_VAL |= PC1_INC32;
			continue;
		}
		spy += (acc/8+1);	// 自由下落
		if(spy<SP_Y_MIN){
			spy = SP_Y_MIN;
			// acc = 0;
		}
		else if(spy>SP_Y_MAX){
			spy = SP_Y_MAX;
		}
		if(acc<SP_MAXACC)
			++acc;
		
		splocal(1, (u8)spx, spy);
		sptile(1,sps[(ix>>2)%3]);
		
		// 等等一个中断
		// 以便让所有在缓冲区的数据都传递到ppu
		waitvblank();
	}
	
	// 游戏结束
	over(score);
}

void main()
{
	for(;;){
		game();
		waitvblank();
		waitvblank();
	}
}


