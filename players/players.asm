    processor 6502
    include "vcs.h"
    include "macro.h"
;;Define variables 
    seg.u Vars
    org  $80
Player0Height ds 1      ; define space of var as i byte (size)    
;;    
    seg
    org $f000
Reset:
    CLEAN_START

    ;;Declare vars
     lda #10
     sta Player0Height ;; $80
    ;;

    ldx #$8d  
    stx COLUBK     ; color background

    lda #$0f
    sta COLUPF	   ; color play field
    
    lda #$48
    sta COLUP0	   ; color player 1	
    
    lda #$C6
    sta COLUP1	   ; color player 2	

    lda #%00000010 ; CTRLPF flag D1 set to score   
    sta CTRLPF
StartFrame:
    lda #2
    sta VBLANK
    sta VSYNC

    REPEAT 3
        sta WSYNC   ; thre scan line for Vsync
    REPEND
    lda #0
    sta VSYNC       ; turn of vsync

    REPEAT 20
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK 
    ;;;;;;;;;;;;;;;;;;;;;;;
    ;; 192 visible lines  ;;
    ;;;;;;;;;;;;;;;;;;;;;;;
   ; Draw 10 empty lines
   REPEAT 10
   	stx WSYNC
   REPEND
   
   
     ; draw scoreboard for the game
     ldy #0
ScoreBoardLoop:
     lda NumberBitmap,Y	 
     sta PF1
     sta WSYNC
     iny 
     cpy #10
     bne ScoreBoardLoop
     
     lda #0
     sta PF1 ; disable playfield
     
     ;Draw empty space 
     REPEAT 50
       sta WSYNC
     REPEND
     
     ;Draw player 0
        ldx #0
PlayerOneLoop:
	lda PlayerBitmap,X
        sta GRP0
        sta WSYNC
        inx
        cpx Player0Height
        bne PlayerOneLoop
     
        lda #0
        sta GRP0 ;disable player 0 graphics
     
     ;Draw player 1
        ldx #0
PlayerTwoLoop:
	lda PlayerBitmap,X
        sta GRP1
        sta WSYNC
        inx
        cpx #10
        bne PlayerTwoLoop
     
        lda #0
        sta GRP1 ;disable player 0 graphics     
     
     
     
 ;draw remaining of the playfield
 	Repeat 122
         sta WSYNC
        repend

;vblank  
        Repeat 20
          sta WSYNC
        repend 
     
     

     
    
     jmp StartFrame   
;;bitmaps
    org $FFE8
PlayerBitmap:    
	.byte #%01111110
        .byte #%11111111
        .byte #%10011001
        .byte #%11111111
        .byte #%11111111
        .byte #%11111111
        .byte #%10111101
        .byte #%11000011
        .byte #%11111111
        .byte #%01111110   
        
    org $FFF2
NumberBitmap:
	.byte #%00001110
        .byte #%00001110
        .byte #%00000010
        .byte #%00000010
        .byte #%00001110
        .byte #%00001110
        .byte #%00001000
        .byte #%00001000
        .byte #%00001110
        .byte #%00001110
    
   
  ;; 4KB  
     org $fffc
    .word Reset
    .word Reset