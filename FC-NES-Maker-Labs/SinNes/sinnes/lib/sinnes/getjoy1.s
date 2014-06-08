;
; trbbadboy, 2010-08-31
;
; unsigned char getjoy1 (void);
;

	.export		_getjoy1
	.include	"nes.inc"

.proc	_getjoy1

		lda		JOY1_VAL
		ldx     #$00
		rts

.endproc