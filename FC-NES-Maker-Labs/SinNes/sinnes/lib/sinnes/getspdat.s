;
; trbbadboy, 2010-09-02
;
;unsigned char getspdat();
;

	.export		_getspdat
	.include	"nes.inc"

.proc	_getspdat
		lda		PPU_SPR_IO
		rts

.endproc