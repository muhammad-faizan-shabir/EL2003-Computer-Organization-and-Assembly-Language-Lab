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

start:	 mov ax,0xb800
	 mov es,ax

loop1:	 call clrscr 		  ; call clear screen
	 mov word[es:2000],0x0743 ; print C
	 cmp al,27  	          ; check if escape is pressed 
	 je end 	 	         ; exit if escape is pressed
	 cmp al,108               ; check if l is pressed
	 je left
	 cmp al,76                ; check if L is pressed
	 je left
	 cmp al,114               ; check if r is pressed
	 je right
	 cmp al,82                ; check if R is pressed
	 je right
	 mov ah,0
	 int 0x16
	 jmp loop1

left: 	 mov word[es:1990],0x074C ; print L
	 mov word[es:1992],0x0745 ; print E
	 mov word[es:1994],0x0746 ; print F
	 mov word[es:1996],0x0754 ; print T
	 mov ah,0
	 int 0x16                 ; get next input
	 jmp loop1

right:	 mov word[es:2004],0x0752 ; print R
	 mov word[es:2006],0x0749 ; print I
	 mov word[es:2008],0x0747 ; print G
	 mov word[es:2010],0x0748 ; print H
	 mov word[es:2012],0x0754 ; print T
	 mov ah,0
	 int 0x16                 ; get next input
	 jmp loop1

end: 	 mov ax,0x4c00
	 int 0x21
