[org 0x0100]

	  jmp start

string:   db 'ggggdddddddyyyyakxxxuww'
length:   dw 23

compress: push bp
	  mov bp,sp
	  push ax
	  push bx
	  push cx
	  push dx
	  push si
	  push di

          mov bx,[bp+4] 	   ; string length address
	  mov cx,[bx]
	  dec cx
	  mov si,[bp+6] 	   ; strin address

loop1:    mov al,[si] 
	  cmp al,[si+1] 	   ; compare adjacent characters
	  jne skip
	  mov byte[si],0 	   ; zero out the character if duplicate
skip : 	  add si,1
	  loop loop1

	  mov di,[bp+6]
	  mov si,[bp+6]
	  mov cx,[bx]

loop2: 	  cmp byte[si],0           ; compare each character with zero
	  je skip2 
	  mov al,[si] 
	  mov [di],al 		   ; move character back to fill holes created
	  mov byte[si],0
	  add di,1
skip2:	  add si,1
	  loop loop2

	  mov al,0 		   ; finding new length of the compressed string
	  push ds
	  pop es
	  mov di,[bp+6]
	  mov cx,0xFFFF
	  cld
	  repne scasb
	  mov ax,0xFFFF
	  sub ax,cx
	  dec ax
	  mov [bx],ax
		
          pop di	
          pop si
	  pop dx
	  pop cx
	  pop bx
	  pop ax
	  mov sp,bp
	  pop bp
	  ret 4

printstr: push bp                  ; subroutine to print a string at desired location, takes x position, y position, string attribute, address of string and its length as parameters 
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

nextchar: mov al, [si]             ; load next char of string 
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

clrscr:   push es                  ; subroutine to clear the screen
          push ax 
          push di 
          mov ax, 0xb800 
          mov es, ax               ; point es to video base 
          mov di, 0                ; point di to top left column 

nextloc:  mov word [es:di], 0x0720 ; clear next char on screen 
          add di, 2                ; move to next screen location 
          cmp di, 4000             ; has the whole screen cleared 
          jne nextloc              ; if no clear next position 
          pop di 
          pop ax 
          pop es 
          ret  

start:    call clrscr 		   ; call clear screen
	  
          mov ax,0
	  push ax
	  mov ax,0
	  push ax
	  mov ax,0x07
	  push ax
	  mov ax,string
	  push ax
	  mov ax,[length]
	  push ax
	  call printstr 	   ; print string before compression

	  mov ax,string
	  push ax
	  mov ax,length
	  push ax
	  call compress 	   ; call compress subroutine

	  mov ax,0
	  push ax
	  mov ax,2
	  push ax
	  mov ax,0x07
	  push ax
	  mov ax,string
	  push ax
	  mov ax,[length]
	  push ax
	  call printstr 	   ; print string after compression

	  mov ah,0
	  int 0x16
	  mov ax,0x4c00
	  int 0x21

