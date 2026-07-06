[org 0x0100]
                  jmp start

timerFlag :       dw 0
ticks:            dw 0
flag:             dw 0
won:              dw 1
score:            dw 0
oldTimer:         dd 0
message1:         db 'Game Over' ; 9 
message2:         db 'You Lost' ; 8
message3:         db 'You Won' ; 7
message4:         db 'Press esc to exit or else press any key to restart game' ; 55

clrscr:           push es
                  push ax
                  push di
                  mov ax, 0xb800
                  mov es, ax                    ; point es to video base
                  mov di, 0                     ; point di to top left column
nextloc:          mov word [es:di], 0x0720      ; clear next char on screen
                  add di, 2                     ; move to next screen location
                  cmp di, 4000                  ; has the whole screen cleared
                  jne nextloc                   ; if no clear next position
                  pop di
                  pop ax 
                  pop es
                  ret

printstr:         push bp
                  mov bp, sp
                  push es 
                  push ax
                  push cx
                  push si
                  push di 
                  mov ax, 0xb800
                  mov es, ax                      ; point es to video base
                  mov al, 80                      ; load al with columns per row
                  mul byte [bp+10]                ; multiply with y position
                  add ax, [bp+12]                 ; add x position
                  shl ax, 1                       ; turn into byte offset
                  mov di,ax                       ; point di to required location
                  mov si, [bp+6]                  ; point si to string
                  mov cx, [bp+4]                  ; load length of string in cx
                  mov ah, [bp+8]                  ; load attribute in ah
                  cld                             ; auto increment mode
nextchar:         lodsb                           ; load next char in al 
                  stosw                           ; print char/attribute pair
                  loop nextchar                   ; repeat for the whole string
                  pop di
                  pop si
                  pop cx
                  pop ax
                  pop es 
                  pop bp
                  ret 10

randomChar:	  push ax
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

timer:            pusha
                  cmp word[cs:timerFlag],1
	          je endOfTimer
	          cmp word[cs:score],10
	          je gameEnd
                  inc word [cs:ticks]       ; increment tick count
                  cmp word [cs:ticks],182
	          jne endOfTimer
	          mov word[cs:won],0
	          jmp gameEnd

endOfTimer:       mov al, 0x20
                  out 0x20, al              ; end of interrupt
                  popa
                  iret                      ; return from interrupt

gameEnd:          mov al,0x20
                  out 0x20,al
		  popa
		  add sp,6
		  mov word[cs:timerFlag],1
		  jmp endOfGame

getChar:          mov ax,0xB800
                  mov es,ax

loop1: 	          mov ah,0
                  int 0x16
                  cmp al,98
                  jne step2
                  mov word[es:1764],0x0720
		  inc word[score]
                  jmp loop1

step2:            cmp al,102
                  jne step3
                  mov word[es:1940],0x0720
		  inc word[score]
                  jmp loop1

step3:            cmp al,116
                  jne step4
                  mov word[es:2136],0x0720
		  inc word[score]
                  jmp loop1

step4:            cmp al,118
                  jne step5
                  mov word[es:2474],0x0720
		  inc word[score]
                  jmp loop1

step5:            cmp al,115
                  jne step6
                  mov word[es:2178],0x0720
		  inc word[score]
                  jmp loop1

step6:            cmp al,119
                  jne step7
                  mov word[es:1878],0x0720
		  inc word[score]
                  jmp loop1

step7:            cmp al,122
                  jne step8
                  mov word[es:3146],0x0720
		  inc word[score]
                  jmp loop1

step8:            cmp al,109
                  jne step9
                  mov word[es:3160],0x0720
		  inc word[score]
                  jmp loop1

step9:            cmp al,107
                  jne step10
                  mov word[es:2860],0x0720
		  inc word[score]
                  jmp loop1

step10:           cmp al,103
                  jne step11
                  mov word[es:2710],0x0720
		  inc word[score]
                  jmp loop1

step11:           cmp al,27
                  jne loop1
                  jmp terminateProgram
				 
endOfGame:        push cs
                  pop ds
                  call clrscr
                  cmp word[won],1
                  jne gameLost
		  push 39
		  push 12
		  mov ax,0x0007
		  push ax
		  mov ax,message3
		  push ax
	   	  mov ax,7
		  push ax
		  call printstr
		  jmp decision

gameLost:         push 39
		  push 12
		  mov ax,0x0007
		  push ax
		  mov ax,message2
		  push ax
	   	  mov ax,8
		  push ax
		  call printstr

decision:         push 2
		  push 13
		  mov ax,0x0007
		  push ax
		  mov ax,message4
		  push ax
	   	  mov ax,55
		  push ax
		  call printstr
                  mov ah,0
                  int 0x16
		  cmp al,27
		  jne restart
		  jmp terminateProgram
		   
start:            xor ax, ax
                  mov es, ax                        ; point es to IVT base
                  mov ax, [es:8*4]
                  mov [oldTimer], ax                ; save offset of old routine
                  mov ax, [es:8*4+2]
                  mov [oldTimer+2], ax              ; save segment of old routine
                  cli                               ; disable interrupts
                  mov word [es:8*4], timer          ; store offset at n*4
                  mov [es:8*4+2], cs                ; store segment at n*4+2
                  sti                               ; enable interrupts

restart:          mov word[score],0
                  mov word[won],1
                  mov word[timerFlag],0
                  mov word[ticks],0
                  call clrscr
                  call randomChar
                  jmp getChar

terminateProgram: call clrscr
                  push 39
		  push 12
		  mov ax,0x0007
		  push ax
		  mov ax,message1
		  push ax
		  mov ax,9
		  push ax
		  call printstr
		  mov ax,0
		  mov es,ax
		  mov ax,[oldTimer]
		  mov bx,[oldTimer+2]
		  cli 
		  mov [es:8*4],ax
		  mov [es:8*4+2],bx
		  sti
		  mov ax,0x4c00
		  int 0x21
				  
                  	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 

	 




