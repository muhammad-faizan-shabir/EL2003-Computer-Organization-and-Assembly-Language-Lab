[org 0x0100]
           jmp start

oldisr:    dd 0

clrscr:    push es                      ; subroutine to clear the screen
           push ax 
           push di 
           mov ax, 0xb800 
           mov es, ax                   ; point es to video base 
           mov di, 0                    ; point di to top left column 

nextloc:   mov word [es:di], 0x0720     ; clear next char on screen 
           add di, 2                    ; move to next screen location 
           cmp di, 4000                 ; has the whole screen cleared 
           jne nextloc                  ; if no clear next position 
           pop di 
           pop ax 
           pop es 
           ret  

printnum:  push bp
	   mov bp, sp
	   push es
	   push ax
	   push bx
	   push cx
	   push dx
 	   push di
	   mov ax, 0xb800
	   mov es, ax                   ; point es to video base
	   mov ax, [bp+4]               ; load number in ax
	   mov bx, 10                   ; use base 10 for division
	   mov cx, 0                    ; initialize count of digits
nextdigit: mov dx, 0                    ; zero upper half of dividend
	   div bx                       ; divide by 10
	   add dl, 0x30                 ; convert digit into ascii value
	   push dx                      ; save ascii value on stack
	   inc cx                       ; increment count of values
	   cmp ax, 0                    ; is the quotient zero
	   jnz nextdigit                ; if no divide it again
	   mov di, [bp+6]               ; point di to top left column
nextpos:   pop dx                       ; remove a digit from the stack
	   mov dh, 0x07                 ; use normal attribute
	   mov [es:di], dx              ; print char on screen
	   add di, 2                    ; move to next screen location
	   loop nextpos                 ; repeat for all digits on stack
	   pop di
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   pop es
       	   pop bp
           ret 4

customIsr: push ax                      ; hooked ISR
           push bx
           push cx
           push dx
           push si
           push di
           push es

           cmp ah,0x2A                  ; check if 0x2A service is requested
           jne skip                     ; if 0x2A service is requested then go to original ISR
           pushf                        ; push flags on stack
           call far [cs:oldisr]         ; call original ISR
           
           mov ax,0xB800 
           mov es,ax                    ; point es to video memory

           mov ax,0
           mov al,dl                    ; move day in al
           push 160  
           push ax
           call printnum                ; print day

           mov byte[es:164],'/' 

           mov ax,0
           mov al,dh                    ; move month in al
           push 166
           push ax
           call printnum                ; print month

           mov byte[es:170],'/'

           mov ax,0
           mov ax,cx                    ; put year in ax
           push 172
           push ax
           call printnum                ; print year

           pop es
           pop di
           pop si
           pop dx
           pop cx
           pop bx
           pop ax
           iret                         ; return 

skip:      pop es
           pop di
           pop si
           pop dx
           pop cx
           pop bx
           pop ax
           jmp far[cs:oldisr]           ; jmp to original ISR in case 0x2A is not requested
 
start:     xor ax,ax
           mov es,ax
           mov ax,[es:21h*4]            ; save the original 0x21 ISR
           mov [oldisr],ax
           mov ax,[es:21h*4+2]
           mov [oldisr+2],ax

           cli
           mov word[es:21h*4],customIsr ; hook the 0x21 ISR
           mov [es:21h*4+2],cs
           sti

           call clrscr                  ; call clrscr

           mov ah,0x2A                  ; get service 0x2A
           int 0x21                     ; generate interrupt

           mov ax,0
           mov es,ax
           mov ax,[oldisr]              ; put old ISR offset in ax 
           mov bx,[oldisr+2]            ; put old IST segement in bx

           cli
           mov [es:21h*4],ax            ; unhook the original ISR
           mov [es:21h*4+2],bx
           sti

           mov ah,0                     ; wait for key stroke
           int 0x16
           mov ax,0x4c00                ; terminate program
           int 0x21