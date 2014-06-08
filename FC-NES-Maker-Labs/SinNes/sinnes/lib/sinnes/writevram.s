;
; trbbadboy, 2010-09-01
;
;void writevram(unsigned int add, unsigned char val);
;

	.export		_writevram
	.import		popa, popax
	.include	"nes.inc"

.proc	_writevram
		
		pha
		jsr		popa
		jsr 	popax
		stx		PPU_VRAM_ADDR2
		sta 	PPU_VRAM_ADDR2
		pla
		sta 	PPU_VRAM_IO
		rts

.endproc