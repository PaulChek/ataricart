    processor 6502
    include "macro.h"
    include "vcs.h"

;=================================================================
;                       Define some variables
;=================================================================
    seg.u variables
    org $80
Player0Height   byte
Player0X        byte
Player0Y        byte    


;=================================================================
;                   Start the ROM Catridge
;=================================================================
    seg Code
    org $F000
    CLEAN_START
;=================================================================
;                       Declare variables
;=================================================================  
Reset:
    lda #8
    sta Player0Height  
    lda #0
    sta Player0X
    sta Player0Y
 
;=================================================================
;                       Start rendering the frame
;=================================================================
    lda #$00
    sta COLUBK ;; bakground color
    lda #$44
    sta COLUP0
 

   
;=================================================================
;                  		VBLANK
;=================================================================
Frame: 
    lda #2
    sta VSYNC
    sta VBLANK
    repeat 3
    sta WSYNC
    repend
    lda #0
    sta VSYNC
        
;=================================================================
;                   Set Player horizontal position in VBLANK
;=================================================================

    lda Player0X
   and #%01111111 ; force 7-bit to zero prevent from be negative
    
    sta WSYNC
    sta HMCLR ; clear old positions
    
    
    sec			; sec carry flag bef subtruction
DivisionLoop:
    sbc #15
    bcs DivisionLoop    ; branch if carry is set
   
    eor #%00000111	; XOR a^=7
    asl                 ; a<<=1
    asl			; cuz HMP0 takes 4 most significant	
    asl
    asl
    sta HMP0 		; set fine position
    sta RESP0		; set 15-step pos
    sta WSYNC		; wait for TIA	
    sta HMOVE		; apply the fine position offset(15)   
    
;=================================================================
;      Let the TIA output recomended 37 lines of VBLANC
;=================================================================  
    repeat 37
     sta WSYNC
    repend
    lda #0
    sta VBLANK
;=================================================================
;                       	DRAW
;=================================================================

    
    ldy #0
User0Loop:
    lda Player0Bitmap,Y    
    sta GRP0
    sta WSYNC
    iny
    cpy Player0Height
    bne User0Loop
    lda #0
    sta GRP0
    
   
    
    
    ldy #192
VisibleLoop:
    sty WSYNC    
    dey
    bne VisibleLoop


;--------------------------- End of frame -------------------------;    
    lda #2
    sta VBLANK
    repeat 30
     sta WSYNC
    repend
    
    inc Player0X
      
    jmp Frame
;=================================================================
;                       Lookup Tables
;=================================================================      
Player0Bitmap:
    byte #%00010000
    byte #%00010000
    byte #%00010000
    byte #%01111100
    byte #%00010000
    byte #%00010000
    byte #%00010000
    byte #%00000000
;=================================================================
;                       End Of catridge
;=================================================================     
    org $FFFC
    .word Reset
    .word Reset