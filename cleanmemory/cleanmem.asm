         processor 6502
         seg   code
         ORG   $F000      ;defines the code origin at ROM
Start:
         SEI
         CLD              ; Disable BCD math mode
         LDX   #$FF       ; Load x reg
         TXS              ; Transfet ro stack reg

                          ; Clear the Zero Page memory ($00 ot $FF)
                          ; Meanint the entire TIA reg space and RAM
         LDA   #0         ; A=0
         LDX   #$FF       ; 
        
ClearMemLoop:
         DEX
         STA   $0,X
         BNE   ClearMemLoop ;loping if x!=0 z flag set
         STA   $FF       ;Null the FF address



;set background color
;$00 - $7F - TIA rgisters television
Colors_loop:
         LDX #50
         DEX
         LDA 0,X
         STA $09
         BNE Colors_loop

                          ;Fill ROM up to 4KB 
         ORG   $FFFC
         .word Start
         .word Start