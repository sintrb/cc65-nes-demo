;
; trbbadboy, 2010-08-31
;
; void setppudat (unsigned char dat)
;

	.export		_setppudat
	.import		popa
        .include        "nes.inc"

.proc	_setppudat

		sta PPU_VRAM_IO
		jsr popa
		rts

.endproc

