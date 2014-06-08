;
; trbbadboy, 2010-09-01
;
;unsigned char getppusolx(void);
;

	.export		_getppusolx
	.include	"nes.inc"

.proc	_getppusolx

		lda		SCROLL_X
		rts

.endproc