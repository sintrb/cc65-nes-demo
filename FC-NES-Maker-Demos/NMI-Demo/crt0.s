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

.segment       	"STARTUP"

start:

; setup the CPU and System-IRQ

        sei
        cld
	ldx     #0
	stx     VBLANK_FLAG

  	stx     ringread
	stx     ringwrite
	stx     ringcount

        txs

        lda     #$20
@l:     sta     ringbuff,x
	sta     ringbuff+$0100,x
	sta     ringbuff+$0200,x
        inx
	bne     @l

; Clear the BSS data

        jsr	zerobss

; initialize data
	jsr	copydata

; setup the stack

        lda     #<(__SRAM_START__ + __SRAM_SIZE__)
        sta	sp
        lda	#>(__SRAM_START__ + __SRAM_SIZE__)
       	sta	sp+1            ; Set argument stack ptr

; Call module constructors

	jsr	initlib

; Push arguments and call main()

       	jsr    	callmain

; Call module destructors. This is also the _exit entry.

_exit:  jsr	donelib		; Run module destructors

; Reset the NES

   	jmp start

; ------------------------------------------------------------------------
; System V-Blank Interupt
; updates PPU Memory (buffered)
; updates VBLANK_FLAG and tickcount
; ------------------------------------------------------------------------

nmi:    pha
        tya
        pha
        txa
        pha

        lda     #1
        sta     VBLANK_FLAG

        inc     tickcount
        bne     @s
        inc     tickcount+1



@s:     jsr     ppubuf_flush

        ; reset the video counter
        lda     #$20
        sta     PPU_VRAM_ADDR2
        lda     #$00
        sta     PPU_VRAM_ADDR2

        ; reset scrolling
        sta     PPU_VRAM_ADDR1
        sta     PPU_VRAM_ADDR1

        .import	_mynmi	; 先导入我们自定义的mynmi函数，C函数让汇编调用需要一个下划线(_)
        jsr		_mynmi	; 执行我们自定义的mynmi函数
		
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


