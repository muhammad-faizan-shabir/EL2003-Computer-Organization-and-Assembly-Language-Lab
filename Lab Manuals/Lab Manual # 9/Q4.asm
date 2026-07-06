[org 0x0100]
          jmp start

msg1:     db 'A key is pressed ' ;17
msg2:     db 'A key is released';17
oldisr:   dd 0

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

kbisr:    push ax                  ; hooked ISR

          in al,0x60               ; get key from keyboard port
          cmp ax,0x2A              ; check if left shift is pressed or not
          jne nextcmp              ; else do next comparison
          push 20
          push 12
          mov ax,0x07
          push ax
          push msg1 
          push 17
          call printstr            ; print msg1 (key pressed)
          jmp nomatch              ; jmp to original ISR

nextcmp:  cmp al,0xAA              ; check if left shift is released or not
          jne nomatch              ; else jmp to original ISR
          push 20
          push 12
          mov ax,0x07
          push ax
          push msg2 
          push 17
          call printstr            ; print msg2 (key released)
          jmp nomatch              ; jmp to original ISR

nomatch:  pop ax
          jmp far [cs:oldisr]      ; jmp to original ISR
 

start:    call clrscr              ; call clrscr

          xor ax, ax
	  mov es, ax               ; point es to IVT base
	  mov ax, [es:9*4]
	  mov [oldisr], ax         ; save offset of old routine
 	  mov ax, [es:9*4+2]
	  mov [oldisr+2], ax       ; save segment of old routine

	  cli                      ; disable interrupts
	  mov word [es:9*4], kbisr ; store offset at n*4
          mov [es:9*4+2], cs       ; store segment at n*4+2
	  sti                      ; enable interrupts

	  l1: mov ah, 0            ; service 0 – get keystroke
 	  int 0x16                 ; call BIOS keyboard service
          cmp al, 27               ; is the Esc key pressed
          jne l1                   ; if no, check for next key

	  mov ax, [oldisr]         ; read old offset in ax
 	  mov bx, [oldisr+2]       ; read old segment in bx

	  cli                      ; disable interrupts
 	  mov [es:9*4], ax         ; restore old offset from ax
	  mov [es:9*4+2], bx       ; restore old segment from bx
	  sti                      ; enable interrupts

	  mov ax, 0x4c00           ; terminate program
	  int 0x21