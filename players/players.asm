    processor 6502
    include "macro.h"
    include "vcs.h"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start uninit seg for var declaration, u can use $80 - $FF 
;; minus few at the end if we use the stack.   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    seg.u Vars
    org $80
P0Height byte   ; player sprite height
P0Ypos   byte   ; player sprite Y coordinates

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start our ROM code segment starting at $F000   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    seg Code
    org $F000

Reset:
     CLEAN_START ; clean mem and TIA

     ldx #$00    ; black
     stx COLUBK  ; set it to back

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initializing the variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;     
    ldx #152
    stx P0Ypos ; P0Ypos = 180
    ldx #9
    stx P0Height ; Poheight = 9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Start the new frame by configuring VBLANK and VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
StartFrame:
    lda #2
    sta VSYNC
    sta VBLANK
    repeat 3
        sta WSYNC
    repend    

    lda #0
    sta VSYNC
   
    ldy #37
VBLANKloop:
    dey
    sta WSYNC    
    bne VBLANKloop;

    lda #0
    sta VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drawing visible part of screen 192 lines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
           ldx #192
ScanLineLoop:          
           txa  
	   sec
           sbc P0Ypos
           cmp P0Height
           bcc P0Loop
           lda #0
P0Loop:		
	   tay	
           lda P0Bitmap,Y
           sta GRP0
           lda P0Colors,Y
           sta COLUP0
           sta WSYNC
           dex
           bne ScanLineLoop
           
           ;lda #0
	   ;sta GRP0	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Drawing 30 overscan lines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;            
       lda #2
       sta VBLANK
       ldy 30
OverscanLoop:       
       sta WSYNC
       dey
       bne OverscanLoop
       
       lda #0
       sta VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Decrement player position
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      

	dec P0Ypos

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Loop the frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
       
       jmp StartFrame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lookup table the player graphicc bitmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
P0Bitmap:
    byte #%00000000
    byte #%00010000
    byte #%00010000
    byte #%01111110
    byte #%11111100
    byte #%11111100
    byte #%11111100
    byte #%01111110
    byte #%00101100
P0Colors:
    byte #$40
    byte #$D2
    byte #$D2
    byte #$40
    byte #$40
    byte #$40
    byte #$42
    byte #$42
    byte #$44
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of catridge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    org $FFFC
    .word Reset
    .word Reset