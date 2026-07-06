[org 0x0100]

jmp start
message1: db 'You won'
message2: db 'You lost'
flag: dw 0
counter: dw 10
clrscr:          push es                  ; subroutine to clear the screen
                 push ax 
                 push di 
                 mov ax, 0xb800 
                 mov es, ax               ; point es to video base 
                 mov di, 0                ; point di to top left column 

nextloc:         mov word [es:di], 0x0720 ; clear next char on screen 
                 add di, 2                ; move to next screen location 
                 cmp di, 4000             ; has the whole screen cleared 
                 jne nextloc              ; if no clear next position 
                 pop di 
                 pop ax 
                 pop es 
                 ret  
randomChar:	 push ax
 		 push es
		 mov ax,0xb800
		 mov es,ax
		 mov word[es:1764],0x0762 ;b
                 mov word[es:1940],0x0766 ;f
                 mov word[es:2136],0x0774 ;t
                 mov word[es:2474],0x0776 ;v
  		 mov word[es:1878],0x0777 ;w
		 mov word[es:3160],0x076D ;m
		 mov word[es:2860],0x076B ;k
 		 mov word[es:2710],0x0767 ;g
		 mov word[es:3146],0x077A ;z
 		 mov word[es:2178],0x0773 ;s
                 pop es
		 pop ax
		 ret
getChar:         push ax
		 push bx
		 push cx
		 push dx
		 push si
	  	 push di
		 push es
                 mov ax,0xB800
                 mov es,ax
loop1: 	         mov ah,0
                 int 0x16
                 cmp al,98
                 jne step2
                 mov word[es:1764],0x0720
                 jmp loop1
step2:           cmp al,102
                 jne step3
                 mov word[es:1940],0x0720
                 jmp loop1
step3:           cmp al,116
                 jne step4
                 mov word[es:2136],0x0720
                 jmp loop1
step4:           cmp al,118
                 jne step5
                 mov word[es:2474],0x0720
                 jmp loop1
step5:           cmp al,115
                 jne step6
                 mov word[es:2178],0x0720
                 jmp loop1
step6:           cmp al,119
                 jne step7
                 mov word[es:1878],0x0720
                 jmp loop1
step7:           cmp al,122
                 jne step8
                 mov word[es:3146],0x0720
                 jmp loop1
step8:           cmp al,109
                 jne step9
                 mov word[es:3160],0x0720
                 jmp loop1
step9:           cmp al,107
                 jne step10
                 mov word[es:2860],0x0720
                 jmp loop1
step10:          cmp al,103
                 jne step11
                 mov word[es:2710],0x0720
                 jmp loop1
step11:          cmp al,27
                 jne loop1
                 jmp end  




start: 		call clrscr
		call randomChar
                mov ax,0
		mov es,ax
              
                call getChar

end: mov ax,0x4c00
int 0x21


