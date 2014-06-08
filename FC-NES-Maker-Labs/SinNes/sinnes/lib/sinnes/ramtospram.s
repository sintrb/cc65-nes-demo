;
; trbbadboy, 2010-10-02
;
;void ramtospram(void *ram_st, u8 spram_st, u8 len);
;
	.export		_ramtospram
	.import		ldaxysp, incsp4
	.include	"nes.inc"

.proc	_ramtospram

		ldy     #$03
		jsr     ldaxysp
		sta     Temp0
		stx     Temp1
		ldy     #$01
		jsr     ldaxysp
		stx     Temp2
		stx		PPU_SPR_ADDR
		sta     Temp3
		beq		end
		ldy		#$00
nextlo:	lda		(Temp0),y
		sta		PPU_SPR_IO
		iny
		cpy		Temp3
		bne		nextlo
		
end:	jsr     incsp4
		rts

.endproc

