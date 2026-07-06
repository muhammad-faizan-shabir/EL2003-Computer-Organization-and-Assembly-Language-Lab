[org 0x0100]
           mov ax, 0xb800           ; load video base in ax
           mov es, ax               ; point es to video base
           mov di, 0                ; point di to top left column
nextchar1: mov word [es:di], 0x07C4 ; put underscore on sreen location
           add di, 2                ; move to next screen location
           cmp di, 2080             ; has the whole screen cleared
           jne nextchar1            ; if no clear next position

           mov di,2080
nextchar2: mov word [es:di], 0x072E ; clear next char on screen
           add di, 2                ; put dot on screen location
           cmp di, 4000             ; has the whole screen cleared
           jne nextchar2            ; if no clear next position

           mov ah,0
           int 0x16
           mov ax, 0x4c00           ; terminate program
           int 0x21 