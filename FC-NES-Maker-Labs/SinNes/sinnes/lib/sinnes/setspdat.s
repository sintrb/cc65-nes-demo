;
; trbbadboy, 2010-09-02
;
;void setspdat(unsigned char add)
;

	.export		_setspdat
	.import	popa
	.include	"nes.inc"

.proc	_setspdat
		
		sta PPU_SPR_IO
		jsr popa
		rts
		
.endproc