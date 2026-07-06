[org 0x0100]
jmp start
oldisr: dd 0
oldTimer: dd 0
buffer times 2000 dw 0
keyPressFlag: dw 0
screenSaverOn: dw 0
ticks: dw 0

message1: db 'Faizan Shabir',0
message2: db 'NATIONAL UNIVERSITY OF COMPUTER & EMERGING SCIENCES',0


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











moveToBuffer:
pusha
push ds
push es
push cs
pop ds
mov ax,0xb800
mov ds,ax
mov si,0
mov ax,cs
mov es,ax
mov di,buffer
cld
mov cx,2000
rep movsw

pop es
pop ds
popa 
ret


moveFromBuffer: pusha
push ds
push es
push cs 
pop ds
mov ax,0xb800
mov es,ax
mov di,0
mov ax,cs
mov ds,ax
mov si,buffer
cld
mov cx,2000
rep movsw

pop es
pop ds
popa
ret

kbisr: pusha
push cs
pop ds
in al,0x60
test al,10000000b
jnz nomatch
mov word[cs:keyPressFlag],1
nomatch:
popa 
jmp far [cs:oldisr] ; call the original ISR

screenSaverPrinter: pusha
push cs
pop ds
mov ax,30
push ax
mov ax,5
push ax
mov ax,0x24
push ax
mov ax,message1
push ax
call printstr

mov ax,1
push ax
mov ax,20
push ax
mov ax,0x27
push ax
mov ax,message2
push ax
call printstr


popa
ret



checkTicks: pusha
push cs
pop ds
inc word[cs:ticks]
cmp word[cs:ticks],180
jb endOfCheckTicks
mov word[cs:ticks],0
cmp word[screenSaverOn],1
je endOfCheckTicks
mov word[screenSaverOn],1
call moveToBuffer
call clrscr
call screenSaverPrinter
endOfCheckTicks:popa
ret



timer: pusha
push cs
pop ds
cmp word[keyPressFlag],1
je restoreScreen
call checkTicks
jmp endOftimer

restoreScreen: mov word[keyPressFlag],0
mov word[ticks],0
cmp word[screenSaverOn],0
je endOftimer
call moveFromBuffer
mov word[screenSaverOn],0

endOftimer:mov al, 0x20
out 0x20, al ; end of interrupt
popa
iret ; return from interrupt






start: 
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

mov dx, start ; end of resident portion
add dx, 15 ; round up to next para
mov cl, 4
shr dx, cl ; number of paras
mov ax, 0x3100 ; terminate and stay resident
int 0x21


