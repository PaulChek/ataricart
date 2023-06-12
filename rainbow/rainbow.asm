    processor 6502
    include "vcs.h"
    include "macro.h"
    
    seg code
    org $F000

Start:    
    CLEAN_START ;clean page0
    
;Start new frame trn on vblank and vsync
NextFrame:
    lda #2
    sta VBLANK
    sta VSYNC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
;; Generate 3 lines of vsync  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
    sta WSYNC ;1 scanline
    sta WSYNC ;2
    sta WSYNC ;3
    
    lda #0
    sta VSYNC ;turn off VSYNC


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Let the TIA output 37 scanlines of VBLANC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #37
LoopVBlank:
    sta WSYNC ; hit WSYNC and wait for the next scanline
    dex
    bne LoopVBlank
   
    lda #0 
    sta VBLANK ; turn of Vblank

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; drawing visible part (only 192 vert scanlines)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ldx #192
LoopVisibleLines:
    stx COLUBK  ; colorized bakground $09
    dex    
    sta WSYNC   ; wait for the next scanline
    bne LoopVisibleLines

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Draw 30 overscan lines to complete frame
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    lda #2
    sta VBLANK

    ldx #30
LoopOverscan: 
    sta WSYNC   
    dex
    bne LoopOverscan
    
    jmp NextFrame
;;;;;;;;;;;;;;;;;;;;
;; End of catridge
;;;;;;;;;;;;;;;;;;;;
    org $FFFC ;4KB
    .word Start
    .word Start
    

