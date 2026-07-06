[org 0x0100]
jmp start
oldkbisr: dd 0
oldTimer: dd 0
score: dw 0
direction: dw 3
charXcord: dw 39
charYcord: dw 12
flag: dw 0
message1: db 'Game Over Score is(in seconds): ',0
printstr: push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds
pop es ; load ds in es
mov di, [bp+4] ; point di to string
mov cx, 0xffff ; load maximum number in cx
xor al, al ; load a zero in al
repne scasb ; find zero in the string
mov ax, 0xffff ; load maximum number in ax
sub ax, cx ; find change in cx
dec ax ; exclude null from length
jz exit ; no printing if string is empty
mov cx, ax ; load string length in cx
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+8] ; multiply with y position
add ax, [bp+10] ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location
mov si, [bp+4] ; point si to string
mov ah, [bp+6] ; load attribute in ah
cld ; auto increment mode
nextchar: lodsb ; load next char in al
stosw ; print char/attribute pair
loop nextchar ; repeat for the whole string
exit: pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8

printnum: push bp
mov bp, sp
push es
push ax
push bx
push cx
push dx
push di
mov ax,[bp+6]
mov bl,80
mul bl
add ax,[bp+8]
shl ax,1
mov di,ax

mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, [bp+4] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
 
nextpos: pop dx ; remove a digit from the stack
mov dh, 0x07 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax
pop es
pop bp
ret 6

offsetCalc: push bp 
            mov bp,sp
			pusha
			push cs 
			pop ds
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



clrscr: push es
push ax
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov di, 0 ; point di to top left column
nextloc: mov word [es:di], 0x0720 ; clear next char on screen
add di, 2 ; move to next screen location
cmp di, 4000 ; has the whole screen cleared
jne nextloc ; if no clear next position
pop di
pop ax
pop es
ret

kbisr:   pusha
         push cs
         pop ds
         in al,0x60
         cmp al,0x01
         jne checkUp
         mov word[cs:flag],1
         jmp nomatch
checkUp: cmp al,0x48
         jne checkDown
		 mov word[cs:direction],1
		 jmp nomatch

checkDown: cmp al,0x50
           jne checkRight
		   mov word[cs:direction],2
		   jmp nomatch

checkRight: cmp al,0x4D
            jne checkLeft
			mov word[cs:direction],3
			jmp nomatch
			
checkLeft:  cmp al,0x4B
            jne nomatch
			mov word[cs:direction],4
			jmp nomatch
nomatch: mov al, 0x20
out 0x20, al ; send EOI to PIC
popa
iret

upMovement: pusha
            push cs 
			pop ds
			cmp word[direction],1
			jne endOfUpMovement
			mov ax,0xb800
			mov es,ax
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x0720
			cmp word[charYcord],0
			jl upHit
			sub word[charYcord],1
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x072A
			jmp endOfUpMovement
upHit:      mov word[cs:flag],1			
endOfUpMovement: popa 
			ret
			
downMovement: pusha
            push cs 
			pop ds
			cmp word[direction],2
			jne endOfdownMovement
			mov ax,0xb800
			mov es,ax
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x0720
			cmp word[charYcord],24
			jg downHit
			add word[charYcord],1
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x072A
			jmp endOfdownMovement
downHit:      mov word[cs:flag],1			
endOfdownMovement: popa 
			ret

rightMovement: pusha
            push cs 
			pop ds
			cmp word[direction],3
			jne endOfrightMovement
			mov ax,0xb800
			mov es,ax
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x0720
			cmp word[charXcord],79
			jg rightHit
			add word[charXcord],1
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x072A
			jmp endOfrightMovement
rightHit:      mov word[cs:flag],1			
endOfrightMovement: popa 
			ret
			
leftMovement: pusha
            push cs 
			pop ds
			cmp word[direction],4
			jne endOfleftMovement
			mov ax,0xb800
			mov es,ax
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x0720
			cmp word[charXcord],0
			jl leftHit
			sub word[charXcord],1
			sub sp,2
			mov ax,[charXcord]
			push ax
			mov ax,[charYcord]
			push ax
			call offsetCalc
			pop di
			mov word[es:di],0x072A
			jmp endOfleftMovement
leftHit:      mov word[cs:flag],1			
endOfleftMovement: popa 
			ret

timer: pusha
       push cs
	   pop ds
	   inc word[score]
	   call upMovement
	   call downMovement
	   call rightMovement
	   call leftMovement




mov al, 0x20
out 0x20, al ; end of interrupt
popa
iret ; return from interrupt








start: call clrscr
mov ax,0xb800
mov es,ax
mov word[es:1998],0x072A
mov ah,0
int 0x16
mov ax,0
mov es,ax
mov ax,[es:9*4]
mov [oldkbisr],ax
mov ax,[es:9*4+2]
mov [oldkbisr+2],ax
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
l1: cmp word[flag],0
je l1
call clrscr
mov ax,35
push ax
mov ax,12
push ax
mov ax,0x07
push ax
mov ax,message1
push ax
call printstr

mov ax,67
push ax
mov ax,12
push ax

mov ax,[score]
mov bl,18
div bl
mov ah,0

push ax
call printnum
mov ax,0
mov es,ax
mov ax,[oldkbisr]
mov bx,[oldkbisr+2]

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

mov ax,0x4c00
int 0x21






