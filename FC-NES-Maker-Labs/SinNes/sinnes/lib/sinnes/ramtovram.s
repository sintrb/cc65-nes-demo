;
; trbbadboy, 2010-09-01
;
; void ramtpvram(void *ram_st, unsigned int vram_st, unsigned int len);
;
	.export		_ramtovram
	.import		ldaxysp, incsp6
	.include	"nes.inc"

.proc	_ramtovram

		ldy     #$05
		jsr     ldaxysp
		sta     Temp0
		stx     Temp1
		ldy     #$03
		jsr     ldaxysp
		stx		PPU_VRAM_ADDR2
		sta 	PPU_VRAM_ADDR2
		ldy     #$01
		jsr     ldaxysp
		sta     Temp2
		stx     Temp3
		cpx		#$00
		beq		small
big:	ldy		#$00
nexthi:	lda		(Temp0),y
		sta		PPU_VRAM_IO
		iny
		bne		nexthi
		inc		Temp1
		dec		Temp3
		bne		big
small:	lda		Temp2
		beq		end
		ldy		#$00
nextlo:	lda		(Temp0),y
		sta		PPU_VRAM_IO
		iny
		cpy		Temp2
		bne		nextlo
		
end:	jsr     incsp6
		rts

.endproc

