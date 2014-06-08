;
; trbbadboy, 2010-08-31
;
; void setppuctr2 (unsigned char val);
;

 	.export		_setppuctr2
	.import		popa
        .include        "nes.inc"

.proc   _setppuctr2

        sta     PPU_CTRL2_VAL
        sta     PPU_CTRL2
        jsr 	popa
  		rts

.endproc
