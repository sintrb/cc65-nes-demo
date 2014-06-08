;
; trbbadboy, 2010-09-02
;
;unsigned char readspram(unsigned char add);
;

	.export		_readspram
	.import		popa
	.include	"nes.inc"

.proc	_readspram
		
		sta		PPU_SPR_ADDR
		jsr		popa
		lda		PPU_SPR_IO
		rts

.endproc