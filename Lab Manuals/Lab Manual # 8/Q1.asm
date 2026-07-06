[org 0x0100]
          jmp start

myStr:    times 50 db 0
length:   dw 0
find: 	  db 0
replace:  db 0
message1: db 'Enter string of at most 50 ch: '
message2: db 'Find: '
message3: db 'Replace: '

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

start:    call clrscr 		   ; call clear screen

          mov ax,0
	  push ax
          mov ax,0
	  push ax
	  mov ax,0x0007
	  push ax
	  mov ax, message1 	   ; print message1
	  push ax
	  mov ax,31
	  push ax
	  call printstr

	  mov si,myStr
	  mov di,64
	  mov ax,0xB800
	  mov es,ax
	  mov cx,0

loop1:	  cmp cx,50 		   ; loop to get input from user
	  je step2	
	  mov ah,0
	  int 0x16
	  cmp ah,28 		   ; scan code for enter
	  je step2
	  mov [si],al
	  mov ah,0x07
	  mov word[es:di],ax
	  add si,1
	  add di,2
	  add cx,1
	  jmp loop1

step2: 	  mov [length],cx
	  mov ax,0
	  push ax
	  mov ax,1
	  push ax
	  mov ax,0x0007
	  push ax
	  mov ax, message2 
	  push ax
	  mov ax,6
	  push ax
	  call printstr            ; print message2
	  mov ah,0
	  int 0x16 		   ; get the to find character
	  mov ah,0x07
	  mov word[es:174],ax
	  mov [find],al

	  mov ax,0
	  push ax
	  mov ax,2
	  push ax
	  mov ax,0x0007
	  push ax
	  mov ax, message3 
	  push ax
	  mov ax,9
	  push ax
	  call printstr            ; print message3
	  mov ah,0
	  int 0x16 		   ; get the to replace character
	  mov ah,0x07
	  mov word[es:340],ax
	  mov [replace],al

	  mov al,[find]
	  mov ah,[replace]
	  mov si,myStr

loop2:	  cmp cx,0 		   ; loop the finds and the replaces the character in the string 
	  je step3
	  cmp [si],al
	  jne skip
	  mov [si],ah
skip:     sub cx,1
	  add si,1
	  jmp loop2

step3:	  mov ax,0
	  push ax
	  mov ax,4
	  push ax
	  mov ax,0x0007
	  push ax
	  mov ax, myStr
	  push ax
	  mov ax,[length]
	  push ax
	  call printstr 	   ; print string after replacement

	  mov ah,0
	  int 0x16
	  mov ax,0x4c00
	  int 0x21