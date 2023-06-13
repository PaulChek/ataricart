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
    ldx #180
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
LoopVisible:          
           stx WSYNC
           dex 
           bne LoopVisible


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
;; Lookup table the player graphicc bitmap
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
P0Bitmap:
    byte #%00000100
    byte #%00011100
    byte #%00001000
    byte #%01111111
    byte #%11111110
    byte #%11111100
    byte #%11111110
    byte #%01111111
    byte #%00101100
P0Colors:
    byte #$00
    byte #$40
    byte #$40
    byte #$40
    byte #$40
    byte #$42
    byte #$42
    byte #$44
    byte #$D2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; End of catridge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    org $FFFC
    .word Reset
    .word Reset