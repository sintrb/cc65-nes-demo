;
; trbbadboy, 2010-08-31
;
; unsigned char getppudat (void)
;

	.export		_getppudat

        .include        "nes.inc"

.proc	_getppudat
	lda PPU_VRAM_IO
	ldx	#$00
	rts

.endproc

