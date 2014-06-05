#ifndef SLIB_H
#define SLIB_H

#ifnedf NULL
	#define NULL 0
#endif

#ifndef u8
	typedef unsigned char u8;
#endif
#ifndef u16
	typedef unsigned int u16;
#endif

// ¼Ä´æÆ÷¶¨Òå


void slib_ram2vram(void *ram, u16 sram);













#endif
