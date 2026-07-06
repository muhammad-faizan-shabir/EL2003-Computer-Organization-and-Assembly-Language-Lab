[org 0x0100]
               jmp start

string:        db 'I am a student of COAL'
substring:     db 'student'
length1:       dw 22
length2:       dw 7

clrscr:        push es                  ; subroutine to clear the screen
               push ax 
               push di 
               mov ax, 0xb800 
               mov es, ax               ; point es to video base 
               mov di, 0                ; point di to top left column 

nextloc:       mov word [es:di], 0x0720 ; clear next char on screen 
               add di, 2                ; move to next screen location 
               cmp di, 4000             ; has the whole screen cleared 
               jne nextloc              ; if no clear next position 
               pop di 
               pop ax 
               pop es 
               ret  

printstr:      push bp                  ; subroutine to print a string at desired location, takes x position, y position, string attribute, address of string and its length as parameters 
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

nextchar:      mov al, [si]             ; load next char of string 
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

start:         call clrscr 		; call print screen
               mov ax,string 		; push parameters
               push ax
               mov ax,substring
               push ax
               mov ax,[length1]
               push ax
               mov ax,[length2]
               push ax
       	       call findSubstring 	; call findSubstring

       	       mov ah,0
               int 0x16
       	       mov ax,0x4c00
       	       int 0x21

findSubstring: push bp 
               mov bp,sp 
               push ax
               push bx
	       push cx
	       push dx
	       push si
	       push di

               mov si,[bp+10] 	        ; original string
               mov di,[bp+8] 	        ; substring
               mov cx,0 
               mov bx,0

loop1:         cmp bx,[bp+4] 
               je endOfLoop1
               cmp cx,[bp+6]
               je endOfLoop1
               mov al,[si] 
               cmp al,[di] 	        ; compare each character
               jne reset
               add di,1 	        ; character match case
               add si,1
               add bx,1
               add cx,1
               jmp loop1

reset:         mov di,[bp+8] 	        ; character mismatch
               mov bx,0 
               add si,1
               add cx,1
               jmp loop1

endOfLoop1:    cmp bx,[bp+4] 	        ; check if mathing occured
               jne printNormal 	        ; print normal if there is mismatch
               mov si,[bp+10] 	        ; print highlighted if match
               mov di,[bp+8]
               mov cx,0
               mov bx,0
               mov ax,0xB800
               mov es,ax
               mov dx,0

loop2:         cmp bx,[bp+6] 
               jae endOfroutine
               mov al,[si]
               cmp al,[di]
               jne reset2
               add di,1 	        ; match case
               add si,1	
               add bx,1 
               mov ah,0x67  	        ; highlight with yellow
               push di
               mov di,dx
               mov word[es:di],ax
               add dx,2
               pop di
               jmp loop2

reset2:        mov di,[bp+8] 	         ; mismatch case
               add bx,1
               add si,1
               mov ah,0x07 	         ; do NOT highlight with yellow
               push di
               mov di,dx
               mov word[es:di],ax
               add dx,2
               pop di
               jmp loop2

printNormal:   mov ax,0 	          ; print normal code
               push ax
               mov ax,0
               push ax
               mov ax,0x07
               push ax
               mov ax,[bp+10]
               push ax
               mov ax,[bp+6]
               push ax
               call printstr

endOfroutine:  pop di
               pop si
               pop dx
               pop cx
               pop bx
               pop ax
               mov sp,bp
               pop bp
               ret 8



