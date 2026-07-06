[org 0x0100]
		   jmp start

buffer times 2000  dw 0
oldTimer: 	   dd 0
oldisr: 	   dd 0
redTurn:  	   dw 1
keyPressFlag:      dw 0 
tickCounter:       dw 0
screenSaverOn:     dw 1

moveToBuffer:      pusha
		   push ds
		   push es
		   mov ax,0xB800
		   mov ds,ax
		   mov si,0
		   push cs
		   pop es
		   mov di,buffer
		   mov cx,2000
		   cld
		   rep movsw
		   pop es
		   pop ds
		   popa
		   ret

moveFromBuffer:    pusha
		   push ds
		   push es
		   mov ax,0xb800
		   mov es,ax
		   mov di,0
		   push cs
		   pop ds
		   mov si,buffer
		   mov cx,2000
		   rep movsw
		   pop es
		   pop ds
		   popa
		   ret

redScreenSaver:	   pusha
		   mov ax,0xb800
		   mov es,ax
		   mov di,0
		   mov ax,0x4720
		   mov cx,2000
		   rep stosw
 	   	   popa
		   ret

greenScreenSaver:  pusha
             	   mov ax,0xb800
		   mov es,ax
		   mov di,0
		   mov ax,0x2720
		   mov cx,2000
		   rep stosw
		   popa
		   ret

kbisr: 		   pusha
		   push cs
		   pop ds
		   in al,0x60
		   test al,10000000b
		   jnz nomatch
		   mov word[cs:keyPressFlag],1

nomatch:	   popa
		   jmp far [cs:oldisr]               ; call the original ISR

check: 		   pusha
		   push cs
		   pop ds

		   cmp word[cs:keyPressFlag],1
		   je restoreScreen

		   inc word[cs:tickCounter]
		   cmp word[cs:tickCounter],180
		   jb endOfcheck
		   cmp word[cs:keyPressFlag],1
		   je restoreScreen
		   ;mov word[cs:keyPressFlag],0
		   cmp word[cs:screenSaverOn],1
		   je changeScreensaver
		   call moveToBuffer

changeScreensaver: mov word[cs:keyPressFlag],0
		   mov word[cs:screenSaverOn],1
		   mov word[cs:tickCounter],0
		   cmp word[cs:redTurn],1
		   je redColor
		   mov word[cs:redTurn],1
		   call greenScreenSaver
		   jmp endOfcheck

redColor: 	   mov word[cs:redTurn],0 
		   call redScreenSaver
		   jmp endOfcheck

restoreScreen:     mov word[cs:keyPressFlag],0
		   mov word[cs:tickCounter],0
		   cmp word[cs:screenSaverOn],0
		   je endOfcheck
		   call moveFromBuffer
		   mov word[cs:keyPressFlag],0
		   mov word[cs:tickCounter],0
		   mov word[cs:screenSaverOn],0

endOfcheck:        popa
		   ret

timer: 		   pusha
		   push cs
		   pop ds
		   call check
		   mov al, 0x20
		   out 0x20, al                        ; end of interrupt
		   popa
		   iret

start: 		   call moveToBuffer
	           call redScreenSaver

		   mov ax,0
		   mov es,ax
		   mov ax,[es:8*4]
		   mov [oldTimer],ax
		   mov ax,[es:8*4+2]
		   mov [oldTimer+2],ax
		   mov ax,[es:9*4]
		   mov [oldisr],ax
		   mov ax,[es:9*4+2]
		   mov [oldisr+2],ax
		   cli
		   mov word[es:8*4],timer
		   mov [es:8*4+2],cs
		   mov word[es:9*4],kbisr
		   mov [es:9*4+2],cs
		   sti

		   mov dx, start                      ; end of resident portion
	           add dx, 15                         ; round up to next para
		   mov cl, 4
		   shr dx, cl                         ; number of paras
		   mov ax, 0x3100                     ; terminate and stay resident
		   int 0x21








