;
; trbbadboy, 2010-08-31
;
; void waitvblank(void);
;

	.export _waitvblank

	.include "nes.inc"

.proc   _waitvblank

wait:   lda     PPU_STATUS
        bpl     wait
        rts

.endproc


