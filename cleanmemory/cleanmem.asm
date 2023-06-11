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
         STA   $0,X
         DEX
         BNE   ClearMemLoop ;loping if x!=0 z flag set
         STA   $0,X       ;Null the 00 address

                          ;Fill ROM up to 4KB 
         ORG   $FFFC
         .word Start
         .word Start