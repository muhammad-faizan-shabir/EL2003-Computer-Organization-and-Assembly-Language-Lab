[org 0x0100]
	       jmp start

timerflag:     dw 0
oldkb: 	       dd 0
counter:       dw 0
buffer:        times 80 dw 0

kbisr: 	       push ax                    ; keyboard interrupt service routine

	       in al, 0x60 		  ; read char from keyboard port
	       cmp al, 0x44 		  ; check if F10 is pressed
	       jne nextcmp 		  ; no, try next comparison
	       cmp word [cs:timerflag], 1 ; is the flag already set
 	       je exit 			  ; yes, leave the ISR
	       mov word [cs:timerflag], 1 ; set flag to start printing
	       jmp exit 		  ; leave the ISR

nextcmp:       cmp al, 0xC4 	          ; check if F10 is released
	       jne nomatch 		  ; no, chain to old ISR
	       mov word [cs:timerflag], 0 ; reset flag to stop printing
	       jmp exit 		  ; leave the interrupt routine

nomatch:       pop ax
	       jmp far [cs:oldkb] 	  ; call original ISR
	
exit: 	       mov al, 0x20
	       out 0x20, al 	          ; send EOI to PIC
	       pop ax
	       iret 		          ; return from interrupt

timer: 	       push ax                    ; timer interrupt service routine
               push bx
               push cx
               push es
               push ds
               push si
               push di

	       cmp word [cs:timerflag], 1 ; is the printing flag set
	       jne restore 		  ; restore original screen

               cld                        ; clear direction flag
               add word[cs:counter],1     ; count number of scroll done
	       mov cx,80                        
               mov ax,0xB800
               mov ds,ax
               mov si,0
               push cs
               pop es
               mov di,buffer
               rep movsw                  ; move the first row into the buffer

               mov bx,24
               mov es,ax
               mov di,0
               mov si,160 

scroll:        cmp bx,0                   ; loop moves row n to row n-1
               jbe endOfScroll
               mov cx,80
               rep movsw
               sub bx,1
               jmp scroll

endOfScroll:   push cs
               pop ds

               mov si,buffer               
               mov di,3840
               mov cx,80 
               rep movsw                  ; move the data(first row) from buffer to last row

               jmp skipall

restore:       cld                        ; clear direction flag
               cmp word[cs:counter],0     ; keep unscrolling until counter becomes 0
               jbe skipall

               mov cx,80
               mov ax,0xB800
               mov ds,ax
               mov si,3840
               push cs
               pop es
               mov di,buffer
               rep movsw                  ; move the last row to buffer

               std
               mov bx,24
               mov es,ax
               mov di,3998
               mov si,3838 

unscroll:      cmp bx,0                   ; loop moves row n to row n+1
               jbe endOfUnscroll
               mov cx,80
               rep movsw
               sub bx,1
               jmp unscroll

endOfUnscroll: cld
               push cs
               pop ds
               mov si,buffer
               mov di,0
               mov cx,80
               rep movsw                  ; move the data(last row) from buffer to first row
               sub word[cs:counter],1     ; decrement counter
               jmp restore                          

skipall:       mov al, 0x20
	       out 0x20, al 		  ; send EOI to PIC
               pop di
	       pop si
               pop ds
               pop es
               pop cx
               pop bx
               pop ax
               iret 			  ; return from interrupt

start: 	       xor ax, ax
	       mov es, ax 		  ; point es to IVT base

	       mov ax, [es:9*4]
	       mov [oldkb], ax 		  ; save offset of old routine
	       mov ax, [es:9*4+2]
	       mov [oldkb+2], ax 	  ; save segment of old routine

	       cli ; disable interrupts
	       mov word [es:9*4], kbisr   ; store offset at n*4
	       mov [es:9*4+2], cs 	  ; store segment at n*4+2
	       mov word [es:8*4], timer   ; store offset at n*4
	       mov [es:8*4+2], cs 	  ; store segment at n*4+2
	       sti 			  ; enable interrupts

	       mov dx, start 		  ; end of resident portion
	       add dx, 15 		  ; round up to next para
	       mov cl, 4
	       shr dx, cl 		  ; number of paras
	       mov ax, 0x3100 		  ; terminate and stay resident
	       int 0x21