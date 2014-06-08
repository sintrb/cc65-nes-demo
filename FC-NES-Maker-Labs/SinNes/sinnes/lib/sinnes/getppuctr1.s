;
; trbbadboy, 2010-08-31
;
; unsigned char getppuctr1 (void);
;

 	.export		_getppuctr1
	.import		popa
        .include        "nes.inc"

.proc   _getppuctr1

        lda     PPU_CTRL1_VAL
        ldx     #$00
  	rts

.endproc
