;
; trbbadboy, 2010-08-31
;
; void setppuctr1 (unsigned char val);
;

 	.export		_setppuctr1
	.import		popa
        .include        "nes.inc"

.proc   _setppuctr1

        sta     PPU_CTRL1_VAL
        sta     PPU_CTRL1
        jsr		popa
  		rts

.endproc
