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
		
		.import		_mynmi
		jsr			_mynmi
		
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

        .incbin	"ascii.chr"

		
; 只读数据段
.segment "RODATA"

; 添加相关资源文件，并导出

; 背景命名表
.export _map_nam_s
_map_nam_s:
	.incbin	"map.nam"

; 背景调色表
.export _map_col_s
_map_col_s:
	.incbin	"map.col"

; 背景属性表
.export _map_atb_s
_map_atb_s:
	.incbin	"map.atb"
	
	
	
	
	


