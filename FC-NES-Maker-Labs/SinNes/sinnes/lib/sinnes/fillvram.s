;
; trbbadboy, 2010-10-04
;
;void fillvram(u16 vram_st, u16 len, u8 val);
;
	.export		_fillvram
	.import		ldaxysp, incsp5
	.include	"nes.inc"

.proc	_fillvram
		ldy     #$04
		jsr     ldaxysp
		stx		PPU_VRAM_ADDR2
		sta 	PPU_VRAM_ADDR2
		
		ldy     #$01
		jsr     ldaxysp
		sta		Temp2

		ldy     #$02
		jsr     ldaxysp
		sta     Temp0
		stx     Temp1
		lda		Temp2
		cpx		#$00
		beq		small
		
nextbg:	ldy		#$00
nexthi:	sta		PPU_VRAM_IO
		iny
		bne		nexthi
		dec		Temp1
		bne		nextbg

small:	ldy		Temp0
		beq		end

nextlo:	sta		PPU_VRAM_IO
		dec     Temp0
		bne		nextlo
		
end:	jsr     incsp5
		rts

.endproc

