;
; trbbadboy, 2010-08-31
;
;
;void readjoy1(void)

	.export		_readjoy1
	.include	"nes.inc"
	
.proc	_readjoy1
		lda		#$00
		sta		JOY1_VAL
		lda		#$01		;初始化
		sta		APU_PAD2
		lda		#$00
		sta		APU_PAD2
		ldx		#$08		;开始读
read:	asl		JOY1_VAL
		lda		APU_PAD2
		and		#$01
		beq		undown
		inc		JOY1_VAL
undown:	dex
		bne		read
		lda		JOY1_VAL
		rts

.endproc