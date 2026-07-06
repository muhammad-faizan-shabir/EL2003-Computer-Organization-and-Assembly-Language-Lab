[org 0x0100]
              jmp start 

clrscr:       push es                      ; subroutine to clear the screen 
              push ax 
              push di 
              mov ax, 0xb800 
              mov es, ax                   ; point es to video base 
              mov di, 0                    ; point di to top left column 
nextloc:      mov word [es:di], 0x0720     ; clear next char on screen 
              add di, 2                    ; move to next screen location 
              cmp di, 4000                 ; has the whole screen cleared 
              jne nextloc                  ; if no clear next position 
              pop di 
              pop ax 
              pop es 
              ret 

customISR:    push bx
              
              mov ah,0 
              int 0x16 		           ; get input from user
                    
              mov bx,0xB800
              mov es,bx

checkUp:      cmp ah,0x48 	           ; scan code for up key
              jne checkDown 
              cmp di,158
              jbe endOfRoutine
              mov word[es:di],0x0720
              sub di,160
              mov word[es:di],0x072A
              jmp endOfRoutine

checkDown:    cmp ah,0x50 	           ; scan code for down key
              jne checkRight
              cmp di,3838
              jae endOfRoutine
              mov word[es:di],0x0720
              add di,160
              mov word[es:di],0x072A
              jmp endOfRoutine
 
checkRight:   cmp ah,0x4D 	           ; scan code for right key
              jne checkLeft
              cmp di,3998
              jae endOfRoutine
              mov word[es:di],0x0720
              add di,2
              mov word[es:di],0x072A
              jmp endOfRoutine

checkLeft:    cmp ah,0x4B 	           ; scan code for left key
              jne endOfRoutine
              cmp di,0
              jbe endOfRoutine
              mov word[es:di],0x0720
              sub di,2
              mov word[es:di],0x072A
              jmp endOfRoutine

endOfRoutine: pop bx 
              iret

start:        call clrscr 	           ; call clear screen

              mov ax,0xB800
              mov es,ax
              mov di,1998
              mov word[es:di],0x072A       ; print asterisk in center of screen
                    
              xor ax,ax
              mov es,ax
              mov word[es:80h*4],customISR ; hooking the int 80 
              mov word[es:80h*4+2],cs
              
              mov ax,0xB800
              mov es,ax 

label:        int 0x80                     ; loop that ends when user presses escape
              cmp al,27
              je end
              jmp label
 
end:          mov ax,0x4c00
              int 0x21