;
; trbbadboy, 2010-08-31
;
; unsigned char getppuctr2 (void);
;

	.export		_getppuctr2
	.include	"nes.inc"

.proc   _getppuctr2

        lda     PPU_CTRL2_VAL
        ldx     #$00
  	rts

.endproc
