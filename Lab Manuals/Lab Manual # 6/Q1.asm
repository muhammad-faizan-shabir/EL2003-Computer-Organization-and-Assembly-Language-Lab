[org 0x0100] 
                 jmp start 
message:         db '22L-6552'            ; string to be printed 
length:          dw 8                     ; length of the string 

reverseStr:      push bp                  ; subroutine to reverse a string passed as parameter
                 mov bp,sp
                 push ax
                 push bx
                 push cx
                 push dx
                 push si
                 push di
              
                 mov cx,[bp+6]            ; move length of string in cx
                 mov bx,[bp+4]            ; move address of string in bx
                 mov ah,0                 ; initialize ah with zero since we dont need upper half of ax

loop1:           cmp cx,0                 ; this loop pushes all values on stack
                 je endOfloop1
                 mov al,[bx]              ; move byte in al
                 push ax                  ; push ax on stack
                 add bx,1                 ; move to next byte of string
                 sub cx,1                 ; decrement counter
                 jmp loop1                ; jump to loop1

endOfloop1:      mov cx,[bp+6]            ; reset cx to length of string
                 mov bx,[bp+4]            ; reset bx to starting address of string
 
loop2:           cmp cx,0                 ; this loop pops all pushed bytes from stack so that the string is reversed
                 je endOfreverseStr
                 pop ax                   ; pop in ax
                 mov [bx],al              ; move the byte to string in the memory in reverse
                 add bx,1                 ; move to next index of string
                 sub cx,1                 ; decrement counter
                 jmp loop2

endOfreverseStr: pop di
                 pop si
                 pop dx
                 pop cx
                 pop bx
                 pop ax
                 mov sp,bp
                 pop bp
                 ret 4

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

printstr:        push bp                  ; subroutine to print a string at desired location, takes x position, y position, string attribute, address of string and its length as parameters 
                 mov bp, sp 
                 push es 
                 push ax 
                 push cx 
                 push si 
                 push di 
                 
                 mov ax, 0xb800 
                 mov es, ax               ; point es to video base 
                 mov al, 80               ; load al with columns per row 
                 mul byte [bp+10]         ; multiply with y position 
                 add ax, [bp+12]          ; add x position 
                 shl ax, 1                ; turn into byte offset 
                 mov di,ax                ; point di to required location 
                 mov si, [bp+6]           ; point si to string 
                 mov cx, [bp+4]           ; load length of string in cx 
                 mov ah, [bp+8]           ; load attribute in ah 

nextchar:        mov al, [si]             ; load next char of string 
                 mov [es:di], ax          ; show this char on screen 
                 add di, 2                ; move to next screen location 
                 add si, 1                ; move to next char in string 
                 loop nextchar            ; repeat the operation cx times 
                 
                 pop di 
                 pop si 
                 pop cx 
                 pop ax 
                 pop es 
                 pop bp 
                 ret 10 

start:           call clrscr              ; call the clrscr subroutine 
              
                 mov ax,[length]          ; parameters for reverseStr subroutine
                 push ax
                 mov ax,message
                 push ax
                 call reverseStr          ; call reverseStr subroutine
                 
                 mov ax, 39               ; position 39 means 40th column
                 push ax                  ; push x position 
                 mov ax, 11               ; position 11 means 12th row 
                 push ax                  ; push y position 
                 mov ax, 0x004A           ; green on red attribute 
                 push ax                  ; push attribute 
                 mov ax, message 
                 push ax                  ; push address of message 
                 push word [length]       ; push message length 
                 call printstr            ; call the printstr subroutine 

                 mov ax, 0x4c00           ; terminate program 
                 int 0x21