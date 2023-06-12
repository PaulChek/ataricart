         processor 6502

         include "vcs.h"
         include "macro.h"

         seg   code
         org   $f000      ; defines beggining of the ROM origin

START:
       ; CLEAN_START         ; macro for clear mem [page0]

; Set backround color
        lda #$88             ;some blue color   NTSC format      
        sta COLUBK           ;$09

       jmp START            

;end of file aka catridge
        org $fffc
        .word START
        .word START