;
; trbbadboy, 2010-09-01
;
; void ramtoram(void *ram_des, void *ram_src, unsigned int len);
;
	.export		_ramtoram
	.import		ldaxysp, incsp6
	.include	"nes.inc"

.proc	_ramtoram

		ldy     #$05
		jsr     ldaxysp
		sta     Temp2
		stx     Temp3
		ldy     #$03
		jsr     ldaxysp
		sta		Temp0
		stx 	Temp1
		ldy     #$01
		jsr     ldaxysp
		sta     Temp4
		stx     Temp5

		cpx		#$00
		beq		small
big:	ldy		#$00
nexthi:	lda		(Temp0),y
		sta		(Temp2),y
		iny
		bne		nexthi
		inc		Temp1
		inc		Temp3
		dec		Temp5
		bne		big
small:	lda		Temp4
		beq		end
		ldy		#$00
nextlo:	lda		(Temp0),y
		sta		(Temp2),y
		iny
		cpy		Temp4
		bne		nextlo
		
end:	jsr     incsp6
		rts

.endproc

