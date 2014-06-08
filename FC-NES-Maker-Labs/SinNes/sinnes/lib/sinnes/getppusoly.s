;
; trbbadboy, 2010-09-01
;
;unsigned char getppusoly(void);
;

	.export		_getppusoly
	.include	"nes.inc"

.proc	_getppusoly

		lda		SCROLL_Y
		rts

.endproc