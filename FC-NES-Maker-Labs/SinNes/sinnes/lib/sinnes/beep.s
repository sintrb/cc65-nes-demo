;
; trbbadboy, 2010-08-31
;
; void beep (void);
;

	.export _beep

	.include "nes.inc"

.proc   _beep
		pha
		lda     #$1f
		sta     APU_CHANCTRL
		lda     #$1f
		sta     APU_PULSE1CTRL
		lda     #$aa
		sta     APU_PULSE1RAMP
		lda     #$ef
		sta     APU_PULSE1FTUNE
		lda     #$08
		sta     APU_PULSE1CTUNE
		pla
		rts

.endproc


