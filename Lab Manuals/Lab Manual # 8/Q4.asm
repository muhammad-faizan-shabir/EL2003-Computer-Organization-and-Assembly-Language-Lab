[org 0x0100]
         jmp start

clrscr:  push es                  ; subroutine to clear the screen 
         push ax 
         push di 

         mov ax, 0xb800 
         mov es, ax               ; point es to video base 
         mov di, 0                ; point di to top left column 

nextloc: mov word [es:di], 0x0720 ; clear next char on screen 
         add di, 2                ; move to next screen location 
         cmp di, 4000             ; has the whole screen cleared 
         jne nextloc              ; if no clear next position 

         pop di 
         pop ax 
         pop es 
         ret 

start:	 call clrscr 	          ; call clear screen
	 mov ax,0xB800 
	 mov es,ax

loop1:	 mov ah,0 
	 int 0x16 	          ; get input from user	 	
	 cmp al,27 	          ; check if escape is pressed
	 je end 		  ; exit if escape is pressed
	 add al,1 	          ; move to ascii of next character
	 mov ah,0x07
	 mov word[es:1998],ax     ; print character
	 jmp loop1

end: 	 mov ax,0x4c00
	 int 0x21
