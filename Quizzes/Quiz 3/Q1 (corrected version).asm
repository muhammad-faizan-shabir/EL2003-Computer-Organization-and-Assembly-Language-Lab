[org 0x0100]
                   jmp start

charYaxis:         dw 12
charXaxis:         dw 39
oldkb:             dd 0
oldTimer:          dd 0
flag:              dw 0
message1:          db 'Game Over' ; 9
direction:         dw 3           ; 1 for up, 2 for down, 3 for right, 4 for left
keyPress:          dw 0
ticks:             dw 18
currentTicks:      dw 0
fiveSecondTicks:   dw 0

offsetCalc:        push bp
                   mov bp,sp
		   pusha
		   mov ax,[bp+4]
		   mov bl,80
		   mul bl
		   add ax,[bp+6]
		   shl ax,1
		   mov [bp+8],ax
		   popa 
		   mov sp,bp
		   pop bp
	           ret 4

printstr:          push bp
                   mov bp, sp
                   push es
                   push ax
                   push cx
                   push si
                   push di
                   mov ax, 0xb800
                   mov es, ax                 ; point es to video base
                   mov al, 80                 ; load al with columns per row
                   mul byte [bp+10]           ; multiply with y position
                   add ax, [bp+12]            ; add x position
                   shl ax, 1                  ; turn into byte offset
                   mov di,ax                  ; point di to required location
                   mov si, [bp+6]             ; point si to string
                   mov cx, [bp+4]             ; load length of string in cx
                   mov ah, [bp+8]             ; load attribute in ah
                   cld                        ; auto increment mode
nextchar:          lodsb                      ; load next char in al
                   stosw                      ; print char/attribute pair
                   loop nextchar              ; repeat for the whole string
                   pop di
                   pop si
                   pop cx
                   pop ax
                   pop es
                   pop bp
                   ret 10

clrscr:            push es
                   push ax
                   push di
                   mov ax, 0xb800
                   mov es, ax                 ; point es to video base
                   mov di, 0                  ; point di to top left column
nextloc:           mov word [es:di], 0x0720   ; clear next char on screen
                   add di, 2                  ; move to next screen location
                   cmp di, 4000               ; has the whole screen cleared
                   jne nextloc                ; if no clear next position
                   pop di
                   pop ax
                   pop es
                   ret

kbisr:             pusha 
                   in al,0x60
	           cmp al,0x1
	           jne step2
	           mov word[cs:flag],1
	           jmp nomatch

step2:             cmp al,0x11
                   jne step3
                   mov word[cs:keyPress],1
                   mov word[cs:direction],1
                   jmp nomatch

step3:             cmp al,0x1F
                   jne step4
                   mov word[cs:keyPress],1
                   mov word[cs:direction],2
                   jmp nomatch

step4:             cmp al,0x20
                   jne step5
                   mov word[cs:keyPress],1
                   mov word[cs:direction],3
                   jmp nomatch

step5:             cmp al,0x1E
                   jne nomatch
                   mov word[cs:keyPress],1
                   mov word[cs:direction],4
                   jmp nomatch

nomatch:           mov al,0x20
                   out 0x20,al
                   popa 
                   iret		 

movement:          pusha 
                   push cs
		   pop ds
		   mov ax,0xb800
		   mov es,ax
		   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x0720
		   cmp word[direction],1
		   jne checkDown
		   cmp word[charYaxis],0
		   jbe wrapAroundUp
		   sub word[charYaxis],1
		   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement

wrapAroundUp:      mov word[charYaxis],24
                   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement

checkDown:         cmp word[direction],2
                   jne checkRight
		   cmp word[charYaxis],24
		   jae wrapAroundDown
		   add word[charYaxis],1
		   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement

wrapAroundDown:    mov word[charYaxis],0
                   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement
			  

checkRight:        cmp word[direction],3
                   jne checkLeft
		   cmp word[charXaxis],79
		   jae wrapAroundRight
		   add word[charXaxis],1
		   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement

wrapAroundRight:   mov word[charXaxis],0
                   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement
			  
checkLeft:         cmp word[direction],4
                   jne endOfMovement
		   cmp word[charXaxis],0
		   jbe wrapAroundLeft
		   sub word[charXaxis],1
		   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement

wrapAroundLeft:    mov word[charXaxis],79
                   sub sp,2
		   push word[charXaxis]
		   push word[charYaxis]
		   call offsetCalc
		   pop di
		   mov word[es:di],0x072A
		   jmp endOfMovement

endOfMovement:     popa
                   ret			
              
timer:             pusha
                   push cs
	           pop ds
                   add word[cs:currentTicks],1
	           inc word[cs:fiveSecondTicks]
	           cmp word[cs:fiveSecondTicks],90
	           jne checkCurrentTicks
	           mov word[cs:fiveSecondTicks],0
	           cmp word[cs:keyPress],0
	           jne checkCurrentTicks
	           mov word[cs:keyPress],0
	           sub word[cs:ticks],3
	           cmp word[cs:ticks],0
	   
	           ja checkCurrentTicks
	           mov word[cs:flag],1
	           jmp endOftimer

checkCurrentTicks: mov ax,[cs:currentTicks]
                   cmp ax,[cs:ticks]
		   jbe endOftimer
		   call movement
		   mov word[cs:currentTicks],0
				   
endOftimer:        cmp word[cs:fiveSecondTicks],0
                   jne endOftimer2
		   mov word[cs:keyPress],0

endOftimer2:       mov al, 0x20
                   out 0x20, al                       ; end of interrupt
                   popa
                   iret                               ; return from interrupt

start:             call clrscr

                   mov ax,0xb800
                   mov es,ax
                   mov word[es:1998],0x072A

                   xor ax, ax
                   mov es, ax                         ; point es to IVT base
                   mov ax, [es:9*4]
                   mov [oldkb], ax                    ; save offset of old routine
                   mov ax, [es:9*4+2]
                   mov [oldkb+2], ax                  ; save segment of old routine
                   mov ax,[es:8*4]
                   mov [oldTimer],ax
                   mov ax,[es:8*4+2]
                   mov [oldTimer+2],ax
                   cli ; disable interrupts
                   mov word [es:9*4], kbisr           ; store offset at n*4
                   mov [es:9*4+2], cs                 ; store segment at n*4+2
                   mov word [es:8*4], timer           ; store offset at n*4
                   mov [es:8*4+2], cs                 ; store segment at n*4+
                   sti                                ; enable interrupts

l1:                cmp word[flag],0
                   je l1

                   mov ax,0
                   mov es,ax
                   mov ax,[oldkb]
                   mov bx,[oldkb+2]
                   cli 
                   mov [es:9*4],ax
                   mov [es:9*4+2],bx
                   sti
                   mov ax,[oldTimer]
                   mov bx,[oldTimer+2]
                   cli 
                   mov [es:8*4],ax
                   mov [es:8*4+2],bx
                   sti

                   call clrscr
                   mov ax,39
                   push ax
                   mov ax,12
                   push ax
                   mov ax,0x07
                   push ax
                   mov ax,message1
                   push ax
                   mov ax,9
                   push ax
                   call printstr
                   mov ax,0x4c00
                   int 0x21





