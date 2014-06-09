;
; Startup code for cc65 (NES version)
;
; by Groepaz/Hitmen <groepaz@gmx.net>
; based on code by Ullrich von Bassewitz <uz@cc65.org>
;

	.export         _exit
	.export         __STARTUP__ : absolute = 1      ; Mark as startup
	.import		initlib, donelib, callmain
	.import	        push0, _main, zerobss, copydata
    .import         ppubuf_flush

    ; Linker generated symbols
	.import		__RAM_START__, __RAM_SIZE__
	.import		__SRAM_START__, __SRAM_SIZE__
	.import		__ROM0_START__, __ROM0_SIZE__
	.import		__STARTUP_LOAD__,__STARTUP_RUN__, __STARTUP_SIZE__
	.import		__CODE_LOAD__,__CODE_RUN__, __CODE_SIZE__
	.import		__RODATA_LOAD__,__RODATA_RUN__, __RODATA_SIZE__

    .include        "zeropage.inc"
	.include        "nes.inc"


; ------------------------------------------------------------------------
; 16 bytes INES header

.segment        "HEADER"
	.incbin	"HEADER.bin"

; ------------------------------------------------------------------------
; Place the startup code in a special segment.
.segment	"STARTUP"
start:
		lda #$00
		sta sp
		sta sp+1
		sei
		cld
		ldx #$ff
		txs

@wait1:	lda     PPU_STATUS
        bmi     @wait1
        
@wait2:	lda     PPU_STATUS
        bpl     @wait2

		lda     #<(__SRAM_START__ + __SRAM_SIZE__)
		sta	sp
		lda	#>(__SRAM_START__ + __SRAM_SIZE__)
		sta	sp+1            ; Set argument stack ptr
		jsr initlib
		
		lda     #$3f	;³õÊ¼»¯É«ÅÌ
		sta     $2006
		lda     #$00
		sta     $2006
		ldx     #$3e
@goon:	stx     $2007
		dex
		dex
		bne     @goon
;irq:
		jsr _main
_exit:
		jsr	donelib
		jmp start

; ------------------------------------------------------------------------
; System V-Blank Interupt
; updates PPU Memory (buffered)
; updates VBLANK_FLAG and tickcount
; ------------------------------------------------------------------------

nmi:    rti
		pha
        tya
        pha
        txa
        pha

        pla
        tax
        pla
        tay
        pla

; Interrupt exit

irq2:
irq1:
timerirq:
irq:
        rti

; ------------------------------------------------------------------------
; hardware vectors
; ------------------------------------------------------------------------

.segment "VECTORS"
        .word   irq2        ; $fff4 ?
        .word   irq1        ; $fff6 ?
        .word   timerirq    ; $fff8 ?
        .word   nmi         ; $fffa vblank nmi
        .word   start	    ; $fffc reset
   		.word	irq         ; $fffe irq / brk

; ------------------------------------------------------------------------
; character data
; ------------------------------------------------------------------------

.segment "CHARS"
        .incbin	"ASCII.chr"


