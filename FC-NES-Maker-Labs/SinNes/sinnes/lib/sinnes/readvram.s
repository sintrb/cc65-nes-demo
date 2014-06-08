;
; trbbadboy, 2010-09-01
;
;unsigned char readvram(unsigned int add)
;

	.export		_readvram
	.import		popax
	.include	"nes.inc"

.proc	_readvram
		
		stx		PPU_VRAM_ADDR2
		sta 	PPU_VRAM_ADDR2
		jsr 	popax
		lda		PPU_VRAM_IO
		rts

.endproc