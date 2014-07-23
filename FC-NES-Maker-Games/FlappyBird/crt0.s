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
		
		; # init pal
		lda     #$3f
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
; ------------------------------------------------------------------------
nmi:    pha
		tya
		pha
		txa
		pha

		; begin: transfer task
		
		TASKS = $0300	; tasks use $0300, size is TASKS_MAX
		TASKS_MAX = 5*8	; max tasks size
		TASK_BUF = $30	; a zeropage var to save ram point, 2 bytes
		TASK_LEN = TASK_BUF+2	; a zeropage var to save data length 
		
		ldx		#$00
		; find task & jump to dotask
		@checktask:
		lda		TASKS, x	; load length(count)
		bne		@dotask
		; next task
		inx
		inx
		inx
		inx
		inx
		cpx		#TASKS_MAX
		beq		@endtask
		bcc		@checktask
		jmp		@endtask
		
		; do one task
		@dotask:
		sta		TASK_LEN
		lda		TASKS+1, x	; rambuf[0]
		sta		TASK_BUF
		lda		TASKS+2, x	; rambuf[1]
		sta		TASK_BUF+1
		lda		TASKS+4, x	; vramst[1], high byte
		sta		PPU_VRAM_ADDR2
		lda		TASKS+3, x	; vramst[0], low byte
		sta		PPU_VRAM_ADDR2		
		ldy		#$00
		; wtite data to PPU_VRAM_IO from ram
		@gowrite:
		lda		(TASK_BUF),y
		sta		PPU_VRAM_IO
		iny
		cpy		TASK_LEN
		bne		@gowrite
		; mark this task is done, set length to 0
		lda		#$00
		sta		TASKS, x
		; next task
		inx
		inx
		inx
		inx
		inx
		cpx		#TASKS_MAX
		beq		@endtask
		bcc		@checktask
		
		@endtask:
		
		; end task
		
		
		; set regs
		lda		#$02
		sta		$4014
		lda		PPU_CTRL1_VAL
		sta		PPU_CTRL1
		lda		PPU_CTRL2_VAL
		sta		PPU_CTRL2
		
		
		lda		SCROLL_X
		sta		PPU_VRAM_ADDR1
		lda		SCROLL_Y
		sta		PPU_VRAM_ADDR1
		
		
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
	
; 精灵调色表
.export _sp_col_s
_sp_col_s:
	.incbin	"sp.col"

; 背景属性表
.export _map_atb_s
_map_atb_s:
	.incbin	"map.atb"

; 关于,命名表
.export _about_nam_s
_about_nam_s:
	.incbin	"about.nam"
; 关于,属性表
.export _about_atb_s
_about_atb_s:
	.incbin	"about.atb"
; 关于,调色
.export _about_col_s
_about_col_s:
	.incbin	"about.col"
	
	


