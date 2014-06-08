;
; trbbadboy, 2010-08-31
;
; unsigned char getjoy (void);
;

	.export		_getjoy
	.include	"nes.inc"

.proc	_getjoy

		lda		JOY_VAL
		ldx     #$00
		rts

.endproc