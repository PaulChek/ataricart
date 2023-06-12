    processor 6502
    include "vcs.h"
    include "macro.h"

    seg
    org $f000
Reset:
    CLEAN_START

    ldx #$8d  
    stx COLUBK     ; color back

    lda #$0f
    sta COLUPF	   ; color play field

StartFrame:
    lda #2
    sta VBLANK
    sta VSYNC

    REPEAT 3
        sta WSYNC   ; thre scan line for Vsync
    REPEND
    lda #0
    sta VSYNC       ; turn of vsync

    REPEAT 37
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK 
    ;;;;;;;;;;;;;;;;;;;;;;;
    ;; Set Control field ;;
    ;;;;;;;;;;;;;;;;;;;;;;;
    ldx #%00000001
    stx CTRLPF    ; set to reflect field
    ;;;;;;;;;;;;;;;;;;;;;;;
    ;; Draw Visible 192 l;;
    ;;;;;;;;;;;;;;;;;;;;;;;    
    ldx #0 
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
    	sta WSYNC
    REPEND
    
    
    
    ;;draw top line
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
    	sta WSYNC
    REPEND
    ; draw vertical line
    ldx #%00100000
    stx PF0
    ldx #0
    stx PF1
    stx PF2
    REPEAT 164
    	stx WSYNC
    REPEND    
    ;draw bottom line
    ldx #%11100000
    stx PF0
    ldx #%11111111
    stx PF1
    stx PF2
    REPEAT 7
    	sta WSYNC
    REPEND
    ;; skip 7 last line
    ldx #0
    stx PF0
    stx PF1
    stx PF2
    REPEAT 7
     stx WSYNC
    REPEND 
    
    ;;;;;;;;;;;;;;;;;;;;;;;
    ;; Complete the frame;;
    ;;;;;;;;;;;;;;;;;;;;;;;     
    lda #2
    sta VBLANK
    REPEAT 30
     sta WSYNC
    REPEND
    lda #0
    sta VBLANK
    
    
    
    
    
    jmp StartFrame    
    
     org $fffc
    .word Reset
    .word Reset