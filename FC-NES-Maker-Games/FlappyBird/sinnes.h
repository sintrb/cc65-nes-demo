// code: utf-8
#ifndef _SINNES_H_
#define _SINNES_H_
#define SINNES_VER 		200
#define SINNES_VER_S	"2.0.0"

typedef unsigned char u8;	// unsigned 8 bits
typedef unsigned int u16;	// unsigned 16 bits
typedef unsigned long u32;

#define NULL 0


// same functuion to direct access point
#define address(_add)	*((u8*)(_add))
#define addr(_add)	*((u8*)(_add))
#define REG(_add)	*((u8*)(_add))


// restart the game
void exit(unsigned char val);

// about ram
void ramtoram(void *ram_des, void *ram_src, unsigned int len);	// copy RAM to RAM, the length is len
void fillram(void *ram, u16 len, u8 val);	// fill RAM with val, the length is len


// about PPU control register
void setppuctr1 (unsigned char val);	// set the PPU control register1
void setppuctr2 (unsigned char val);	// set the PPU control register2
unsigned char getppuctr1 (void);		// get the PPU control register1
unsigned char getppuctr2 (void);		// get the PPU control register2
void bkground_on(void);					// background enable
void bkground_off(void);				// background disable
void sprite_on(void);					// sprite enable
void sprite_off(void);					// sprite disable
void name0(void);		// select name0
void name1(void);		// select name1
void name2(void);		// select name2
void name3(void);		// select name3
void name01(void);		// switch name between 0 and 1
void name02(void);		// switch name between 0 and 2
void nmi_off(void);		// nmi disable
void nmi_on(void);		// nmi enable
void graph_on(void);	// graphic enable
void graph_off(void);	// graphic disable


// about PPU scroll
void setppusol(unsigned char x, unsigned char y);	// set the ppu scroll
unsigned char getppusolx(void);		// get the ppu scroll of x
unsigned char getppusoly(void);		// get the ppu scroll of y

// about PPU access
void setppuadd (unsigned int add);		// set ppu address register, then read or write
void setppudat (unsigned char dat);		// send a byte for ppu
unsigned char getppudat (void);			// read a byte from ppu

void writevram(unsigned int add, unsigned char val);// write the VRAM of whitch address is add with val
unsigned char readvram(unsigned int add);	// read the data from the VRAM whitch address is add
void ramtovram(void *ram_st, unsigned int vram_st, unsigned int len);// copy RAM data to VRAM, the length is len
void fillvram(unsigned int vram_st, unsigned int len, unsigned char val);	// fill VRAM with val, the length is len


// about sprite access
void setspadd(unsigned char add);	// set the SPRAM address
void setspdat(unsigned char add);	// set the SPRAM data
unsigned char getspdat();// get the SPRAM data

void writespram(unsigned char add, unsigned char val);// set the data on the SPRAM whitch address is add
unsigned char readspram(unsigned char add);// read the data form SPRAM whitch address is add
void ramtospram(void *ram_st, u8 spram_st, u8 len);// copy RAM data to SPRAM, the length is len
void fillspram(u8 ram_st, u8 len, u8 val);		// fill SPRAM with val, the length is len


void waitvblank(void);	// waitting for the vertical blank
unsigned char ishit(void);	// return 1 if the #0 sprite is hitted

void beep (void);	// beep
void resetsol();		// reset the scroll
void resetppu();		// reset the PPU address

// about joystrick
unsigned char getjoy(void);		// get the status of prev joystrick1
unsigned char readjoy(void);	// read the status of now joystrick1
unsigned char getjoy1(void);	// get the status of prev joystrick2
unsigned char readjoy1(void);	// read the status of now joystrick2

extern u8 PPU_CTRL1_VAL;

// consts
// begin io
#define PPU_CTRL1		0x2000
#define PPU_CTRL2		0x2001
#define PPU_STATUS		0x2002
#define PPU_SPR_ADDR	0x2003
#define PPU_SPR_IO		0x2004
#define PPU_VRAM_SOL	0x2005
#define PPU_VRAM_ADDR	0x2006
#define PPU_VRAM_IO		0x2007
// end io

// begin PPU_CTRL1
#define PC1_NAME_MASK		0x03	// mask of name table area
#define PC1_NAME0			0x00	// use name0
#define PC1_NAME1			0x01	// use name1
#define PC1_NAME2			0x02	// use name2
#define PC1_NAME3			0x03	// use name3

#define PC1_INC32			0x04	// add 32 by every access ppu
#define PC1_SP_PAT1			0x08	// sprite use pattern  1
#define PC1_IM_PAT1			0x10	// background use pattern  1
#define PC1_SP_BIG			0x20	// let sprite size is 8*16
#define PC1_RESERVE			0x40	// reserve, unuse	
#define PC1_NMI				0x80	// nmi enable
// end PPU_CTRL1 Mask

// begin PPU_CTRL2
#define PC2_GRAY				0x01	// gray(single color mode)
#define PC2_SHOW_L8BG			0x02	// show left 8 pix background
#define PC2_SHOW_L8SP			0x04	// show left 8 pix sprite
#define PC2_SHOW_BG				0x08	// show background
#define PC2_SHOW_SP				0x10	// show sprite
#define PC2_COL_MASK			0xE0	// color intensify mask
#define PC2_COL_BLUE			0x20	// blue intensify
#define PC2_COL_GREEN			0x40	// green intensify
#define PC2_COL_RED				0x80	// red intensify
// end PPU_CTRL2

// begin PPU_STATUS
#define PS_VRAM_WFLAG			0x08	// vram write flag
#define PS_SP_OVER8				0x10	// sprite over 8 on one scan line
#define PS_SP0_HITFLAG			0x10	// #0 sprite hit flag
#define PS_VBLANK				0x10	// vblank flag
// end PPU_STATUS

// begin joy
#define JOY_A		0x80
#define JOY_B		0x40
#define JOY_SELECT	0x20
#define JOY_START	0x10
#define JOY_UP		0x08
#define JOY_DOWN	0x04
#define JOY_LEFT	0x02
#define JOY_RIGHT	0x01
// end hoy


// begin vram
#define VRAM_PAT0		0x0000	// pattern  0
#define VRAM_PAT1		0x1000	// pattern  1
#define VRAM_PAT_LEN	0x1000	// pattern length

#define VRAM_NAME0		0x2000	// name table 0
#define VRAM_NAME1		0x2400	// name table 1
#define VRAM_NAME2		0x2800	// name table 2
#define VRAM_NAME3		0x2c00	// name table 3
#define VRAM_NAME_LEN	0x03c0	// name table length

#define VRAM_ATTR0		0x23c0	// attribute table 0
#define VRAM_ATTR1		0x27c0	// attribute table 1
#define VRAM_ATTR2		0x2bc0	// attribute table 2
#define VRAM_ATTR3		0x2fc0	// attribute table 3
#define VRAM_ATTR_LEN	0x0040	// attribute table length

#define VRAM_PAL		0x3f00	// palette
#define VRAM_PAL_LEN	0x0020	// all palette length
#define VRAM_BG_PAL		0x3f00	// background palette
#define VRAM_SP_PAL		0x3f10	// sprite palette
#define VRAM_BG_PAL_LEN		0x0010	// background palette length
#define VRAM_SP_PAL_LEN		0x0010	// sprite palette length
// end vram



// the follow is some macros or some const value
#define loadpat0(_dat)	ramtovram(_dat, VRAM_PAT0, VRAM_PAT_LEN)	// load pattern  0
#define loadpat1(_dat)	ramtovram(_dat, VRAM_PAT1, VRAM_PAT_LEN)	// load pattern  1


#define loadname0(_dat) ramtovram(_dat, VRAM_NAME0, VRAM_NAME_LEN)	// load name table 0
#define loadname1(_dat) ramtovram(_dat, VRAM_NAME1, VRAM_NAME_LEN)	// load name table 1

#define loadattr0(_dat) ramtovram(_dat, VRAM_ATTR0, VRAM_ATTR_LEN)	// load attribute table 0
#define loadattr1(_dat) ramtovram(_dat, VRAM_ATTR1, VRAM_ATTR_LEN)	// load attribute table 1

#define loadpal(_dat)	ramtovram(_dat, VRAM_PAL, VRAM_PAL_LEN)	// load background palette and sprite palette
#define loadbgpal(_dat)	ramtovram(_dat, VRAM_BG_PAL, VRAM_BG_PAL_LEN)	// load background palette
#define loadsppal(_dat)	ramtovram(_dat, VRAM_SP_PAL, VRAM_SP_PAL_LEN)	// load sprite palette



// global var
// view nes.inc
#define PC1_VAL (addr(0x0060))
#define PC2_VAL (addr(0x0061))
#define JOY_VAL (addr(0x0062))
#define JOY1_VAL (addr(0x0063))
#define SOLX_VAL (addr(0x0064))
#define SOLY_VAL (addr(0x0065))


#endif