;
; trbbadboy, 2010-10-04
;
;unsigned char ishit(void);
;

	.export		_ishit
	.include	"nes.inc"

.proc	_ishit
		
		lda		PPU_STATUS
		and		#%01000000
		rts

.endproc