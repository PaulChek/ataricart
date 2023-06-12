                          ;$00 - $7F - TIA rgisters television
                          ;color of background
                          ; vert sync
         processor 6502
         seg   code
         ORG   $F000
Start:
         LDA   #80        ; load literal decimal == 80 #- immidiate mode
         LDA   $80        ; load value of  address of  80(hex)RAM $-abs zero page mode
         LDA   #$80       ; load literal hex val aka # 128   




         ORG   $FFFC
         .word Start
         .word Start








