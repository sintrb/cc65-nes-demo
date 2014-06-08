;
; trbbadboy, 2010-09-01
;
;void setppusol(unsigned char x, unsigned char y)
;

	.export		_setppusol
	.import		popa
	.include	"nes.inc"

.proc	_setppusol
		
		pha
		jsr		popa
		jsr		popa
		sta		PPU_VRAM_ADDR1
		sta		SCROLL_X
		pla
		sta		PPU_VRAM_ADDR1
		sta		SCROLL_Y
		rts

.endproc
