[org 0x0100]
jmp start
string: db 'Hello! My name is Faizan',0
message1: db 'Vowel     Count',0
message2: db 'a or A',0
message3: db 'e or E',0
message4: db 'i or I',0
message5: db 'o or O',0
message6: db 'u or U',0

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

strlen: push bp
mov bp,sp
push es
push cx
push di
les di, [bp+4] ; point es:di to string
mov cx, 0xffff ; load maximum number in cx
xor al, al ; load a zero in al
repne scasb ; find zero in the string
mov ax, 0xffff ; load maximum number in ax
sub ax, cx ; find change in cx
dec ax ; exclude null from length
pop di
pop cx
pop es
pop bp
ret 4

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

countAlphabet: push bp
               mov bp,sp
			   sub sp,2
			   pusha
			   mov word[bp-2],0
			   push ds
			   mov ax,[bp+4]
			   push ax
			   call strlen
			   mov cx,ax
			   mov ax,[bp+6]
			   mov bx,[bp+4]
			   mov si,0
loop1:         cmp cx,0
               jbe endOfcountAlphabet
			   cmp al,[bx+si]
			   jne doNotCount
			   add word[bp-2],1
doNotCount:    dec cx
               add si,1	
               jmp loop1
endOfcountAlphabet: mov ax,[bp-2]
                    mov [bp+8],ax
                    popa
                    mov sp,bp
                    pop bp
                    ret 4 					
			   
			   

countVowels: push bp
             mov bp,sp
			 sub sp,10
			 pusha 
			 mov word[bp-2],0 ; a or A count
			 mov word[bp-4],0 ; e or E count
			 mov word[bp-6],0 ; i or I count
			 mov word[bp-8],0 ; o or O count
			 mov word[bp-10],0 ; u or U count
			 sub sp,2
			 mov ax,0x61
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-2],ax
			 
			 sub sp,2
			 mov ax,0x41
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-2],ax
			 
			 sub sp,2
			 mov ax,0x65
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-4],ax
			 
			 sub sp,2
			 mov ax,0x45
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-4],ax
			 
			 sub sp,2
			 mov ax,0x69
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-6],ax
			 
			 sub sp,2
			 mov ax,0x49
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-6],ax
			 
			 sub sp,2
			 mov ax,0x6F
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-8],ax
			 
			 sub sp,2
			 mov ax,0x4F
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-8],ax
			 
			 sub sp,2
			 mov ax,0x75
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-10],ax
			 
			 sub sp,2
			 mov ax,0x55
			 push ax
			 mov ax,[bp+4]
			 push ax
			 call countAlphabet
			 pop ax
			 add [bp-10],ax
			 
			 
			 mov ax,30
			 push ax
			 mov ax,8
			 push ax
			 mov ax,0x07
			 push ax
			 mov ax,message1
			 push ax
			 call printstr
			 
			  mov ax,29
			 push ax
			 mov ax,9
			 push ax
			 mov ax,0x07
			 push ax
			 mov ax,message2
			 push ax
			 call printstr
			 
			 mov ax,29
			 push ax
			 mov ax,10
			 push ax
			 mov ax,0x07
			 push ax
			 mov ax,message3
			 push ax
			 call printstr
			 
			 mov ax,29
			 push ax
			 mov ax,11
			 push ax
			 mov ax,0x07
			 push ax
			 mov ax,message4
			 push ax
			 call printstr
			 
			 mov ax,29
			 push ax
			 mov ax,12
			 push ax
			 mov ax,0x07
			 push ax
			 mov ax,message5
			 push ax
			 call printstr
			 
			 mov ax,29
			 push ax
			 mov ax,13
			 push ax
			 mov ax,0x07
			 push ax
			 mov ax,message6
			 push ax
			 call printstr
			 
			 mov ax,42
			 push ax
			 mov ax,9
			 push ax
			 mov ax,[bp-2]
			 push ax
			 call printnum
			 
			 mov ax,42
			 push ax
			 mov ax,10
			 push ax
			 mov ax,[bp-4]
			 push ax
			 call printnum
			 
			 mov ax,42
			 push ax
			 mov ax,11
			 push ax
			 mov ax,[bp-6]
			 push ax
			 call printnum
			 
			 mov ax,42
			 push ax
			 mov ax,12
			 push ax
			 mov ax,[bp-8]
			 push ax
			 call printnum
			 
			 mov ax,42
			 push ax
			 mov ax,13
			 push ax
			 mov ax,[bp-10]
			 push ax
			 call printnum
			 
			 
			 popa 
			 mov sp,bp
			 pop bp
			 ret 2
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 
			 








start: call clrscr
mov ax,string
push ax
call countVowels
mov ax,0x4c00
int 0x21
