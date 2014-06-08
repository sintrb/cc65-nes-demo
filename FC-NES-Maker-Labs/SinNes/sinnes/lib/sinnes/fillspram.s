;
; trbbadboy, 2010-10-02
;
;void fillspram(u8 ram_st, u8 len, u8 val);
;
	.export		_fillspram
	.import		ldaxysp, incsp3
	.include	"nes.inc"

.proc	_fillspram

		ldy     #$02
		jsr     ldaxysp
		stx     Temp0
		stx     PPU_SPR_ADDR
		sta     Temp1

		ldy     #$01
		jsr     ldaxysp
		sta     Temp2
		
		ldy		Temp1
		beq		end
nextsp:	sta		PPU_SPR_IO
		dey
		bne		nextsp
		
end:	jsr     incsp3
		rts

.endproc

