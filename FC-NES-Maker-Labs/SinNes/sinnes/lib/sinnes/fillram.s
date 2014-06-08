;
; trbbadboy, 2010-10-02
;
;void fillram(void *ram, u16 len, u8 val);
;
	.export		_fillram
	.import		ldaxysp, incsp5
	.include	"nes.inc"

.proc	_fillram

		ldy     #$04
		jsr     ldaxysp
		sta     Temp0
		stx     Temp1
		ldy     #$01
		jsr     ldaxysp
		sta		Temp4
		ldy     #$02
		jsr     ldaxysp
		sta		Temp2
		stx 	Temp3
		lda		Temp4
		cpx		#$00
		beq		small
big:	ldy		#$00
nexthi:	sta		(Temp0),y
		iny
		bne		nexthi
		inc		Temp1
		dec		Temp3
		bne		big
small:	lda		Temp2
		beq		end
		lda		Temp4
		ldy		#$00
nextlo:	sta		(Temp0),y
		iny
		cpy		Temp2
		bne		nextlo

end:	jsr     incsp5
		rts

.endproc

