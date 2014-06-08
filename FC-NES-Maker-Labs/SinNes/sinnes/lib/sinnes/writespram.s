;
; trbbadboy, 2010-09-02
;
;void writespram(unsigned char add, unsigned char val)
;

	.export		_writespram
	.import		popa
	.include	"nes.inc"

.proc	_writespram

		pha
		jsr		popa
		jsr		popa
		sta		PPU_SPR_ADDR
		pla
		sta		PPU_SPR_IO
		rts
		
		
.endproc