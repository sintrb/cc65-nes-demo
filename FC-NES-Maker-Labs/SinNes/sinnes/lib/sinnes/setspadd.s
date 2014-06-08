;
; trbbadboy, 2010-09-02
;
;void setspadd(unsigned char add)
;

	.export		_setspadd
	.import	popa
	.include	"nes.inc"

.proc	_setspadd
		
		sta PPU_SPR_ADDR
		jsr popa
		rts
		
.endproc