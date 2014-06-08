;
; trbbadboy, 2010-09-27
;
;
;set with ppu ctrol
;void bkground_on(void);					//background enable
;void bkground_off(void);				//background disable
;void sprite_on(void);					//sprite enable
;void sprite_off(void);					//sprite disable
;void name0(void);		//select name0
;void name1(void);		//select name1
;void name2(void);		//select name2
;void name3(void);		//select name3
;void nmi_off(void);		//nmi disable
;void nmi_on(void);		//nmi enable
;void graph_on(void);	//graphic enable
;void graph_off(void);	//graphic disable
;void resetsol();		//reset the scroll
;void resetppu();		//reset the PPU address

	.export		_bkground_on,_bkground_off,_sprite_on,_sprite_off
	.export		_name0,_name1,_name2,_name3
	.export		_nmi_off,_nmi_on
	.export		_graph_on,_graph_off
	.export		_name01, _name02
	.export		_resetsol,_resetppu
	.include        "nes.inc"

.proc	_bkground_on
		
		lda		PPU_CTRL2_VAL
		ora		#%00001000
		sta 	PPU_CTRL2_VAL
		sta		PPU_CTRL2
		rts
.endproc

.proc	_bkground_off
		
		lda		PPU_CTRL2_VAL
		and		#%11110111
		sta 	PPU_CTRL2_VAL
		sta		PPU_CTRL2
		rts
.endproc

.proc	_sprite_on
		
		lda		PPU_CTRL2_VAL
		ora		#%00010000
		sta 	PPU_CTRL2_VAL
		sta		PPU_CTRL2
		rts
.endproc

.proc	_sprite_off
		
		lda		PPU_CTRL2_VAL
		and		#%11101111
		sta 	PPU_CTRL2_VAL
		sta		PPU_CTRL2
		rts
.endproc

.proc	_name0
		
		lda		PPU_CTRL1_VAL
		and		#%11111100
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc

.proc	_name1
		
		lda		PPU_CTRL1_VAL
		and		#%11111100
		ora		#%00000001
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc

.proc	_name2
		
		lda		PPU_CTRL1_VAL
		and		#%11111100
		ora		#%00000010
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc

.proc	_name3
		
		lda		PPU_CTRL1_VAL
		and		#%11111100
		ora		#%00000011
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc

.proc	_nmi_off
		
		lda		PPU_CTRL1_VAL
		and		#%01111111
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc

.proc	_nmi_on
		
		lda		PPU_CTRL1_VAL
		ora		#%10000000
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc

.proc	_graph_on
		
		lda		#%10000000
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		lda		#%00011110
		sta 	PPU_CTRL2_VAL
		sta		PPU_CTRL2
		rts
.endproc

.proc	_graph_off
		
		lda		#$00
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		sta 	PPU_CTRL2_VAL
		sta		PPU_CTRL2
		rts
.endproc

.proc	_name01
		
		lda		PPU_CTRL1_VAL
		pha
		and		#%00000011
		cmp		#%00000000
		beq		ld01
		cmp		#%00000001
		beq		ld00
		pla
		rts
ld00:	pla
		and		#%11111100
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
ld01:	pla
		and		#%11111100
		ora		#%00000001
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc

.proc	_name02
		
		lda		PPU_CTRL1_VAL
		pha
		and		#%00000011
		cmp		#%00000000
		beq		ld10_0
		cmp		#%00000010
		beq		ld00_0
		pla
		rts
ld00_0:	pla
		and		#%11111100
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
ld10_0:	pla
		and		#%11111100
		ora		#%00000010
		sta 	PPU_CTRL1_VAL
		sta		PPU_CTRL1
		rts
.endproc


.proc	_resetsol
		lda		#$00
		sta		SCROLL_Y
		sta		PPU_VRAM_ADDR2
		sta		SCROLL_X
		sta 	PPU_VRAM_ADDR2
		rts
.endproc

.proc	_resetppu
		
		lda		#$00
		sta 	PPU_VRAM_ADDR1
		sta		PPU_VRAM_ADDR1
		rts
.endproc