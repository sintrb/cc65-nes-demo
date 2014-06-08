;
; trbbadboy, 2010-08-31
;
; void setppuadd (unsigned int add)
;

	.export		_setppuadd
	.import		popax
	.include        "nes.inc"

.proc	_setppuadd

		stx		PPU_VRAM_ADDR2
		sta 	PPU_VRAM_ADDR2
		jsr 	popax
		rts

.endproc

