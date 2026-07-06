[org 0x0100]
                	  jmp start
oldisr:          	  dd 0
oldTimer:        	  dd 0
charsTyped:     	  dw 0
oneSecCounter:   	  dw 0
fiveSecCounter:  	  dw 0

clrscr:          	  push es
                 	  push ax
			  push di
		 	  mov ax, 0xb800
			  mov es, ax                   ; point es to video base
		  	  mov di, 0                    ; point di to top left column
nextloc: 	 	  mov word [es:di], 0x0720     ; clear next char on screen
		 	  add di, 2                    ; move to next screen location
		 	  cmp di, 4000                 ; has the whole screen cleared
		 	  jne nextloc                  ; if no clear next position
		 	  pop di
		 	  pop ax
		 	  pop es
		 	  ret

clrLastCol: 	 	  pusha
		 	  push cs
			  pop ds
		 	  mov cx,24
		  	  mov ax,0xb800
		  	  mov es,ax
		          mov di,158

loop2:		          cmp cx,0
		 	  je endOfclrLastCol
		          mov word[es:di],0x0720
		 	  dec cx
			  add di,160
		 	  jmp loop2

endOfclrLastCol: 	  popa
	  	 	  ret

printAsterisk:  	  pusha
                	  push cs
	         	  pop ds
	         	  cmp word[cs:charsTyped],24
	         	  ja endOfPrintAsterisk
	        	  call clrLastCol
	        	  mov ax,0xb800
			  mov es,ax
		 	  mov di,158
	         	  mov cx,[cs:charsTyped]

loop1:			  cmp cx,0
	         	  jle endOfPrintAsterisk
	         	  mov word[es:di],0x072A
	        	  add di,160
	         	  dec cx
	             	  jmp loop1

endOfPrintAsterisk:       popa
	              	  ret

kbisr:			  pusha
     			  push cs
	 		  pop ds
	  		  in al,0x60
	  	 	  test al,10000000b
	 	 	  jz nomatch
	   		  inc word[cs:charsTyped]

nomatch:                  popa
		    	  jmp far [cs:oldisr]

checkOneSecCounter: 	  pusha
			  push cs
			  pop ds
			  inc word[oneSecCounter]
			  cmp word[oneSecCounter],18
			  jne endOfcheckOneSecCounter
			  call printAsterisk
			  mov word[oneSecCounter],0

endOfcheckOneSecCounter:  popa 
			  ret

checkFiveSecCounter:  	  pusha
			  push cs
			  pop ds
			  inc word[cs:fiveSecCounter]
			  cmp word[cs:fiveSecCounter],90
			  jne endOfcheckFiveSecCounter
			  mov word[cs:fiveSecCounter],0
			  mov word[cs:charsTyped],0

endOfcheckFiveSecCounter: popa
                          ret

timer:                    pusha
			  push cs
			  pop ds
			  call checkOneSecCounter
		 	  call checkFiveSecCounter

		  	  mov al, 0x20
			  out 0x20, al             ; end of interrupt
			  popa
			  iret

start:  		  call clrscr
		   	  mov ax,0
			  mov es,ax
			  mov ax,[es:9*4]
			  mov [oldisr],ax
			  mov ax,[es:9*4+2]
			  mov [oldisr+2],ax
			  mov ax,[es:8*4]
			  mov [oldTimer],ax
			  mov ax,[es:8*4+2]
			  mov [oldTimer+2],ax
			  cli
			  mov word[es:8*4],timer
			  mov [es:8*4+2],cs
			  mov word[es:9*4],kbisr
			  mov [es:9*4+2],cs
			  sti

			  mov dx, start            ; end of resident portion
			  add dx, 15               ; round up to next para
			  mov cl, 4
			  shr dx, cl               ; number of paras
			  mov ax, 0x3100           ; terminate and stay resident
			  int 0x21



