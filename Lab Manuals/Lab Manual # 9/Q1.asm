[org 0x0100]
         jmp start

msg1:    db 'msg1: Hi! I am Faizan.'       ; 22 length
msg2:    db 'msg2: I am Happy.'            ; 17 length
msg3:    db 'msg3: I Study at FAST.'       ; 22 length
msg4:    db 'msg4: My Roll No is 22L-6552' ; 28 length

clrscr:  push es                           ; subroutine to clear the screen
         push ax 
         push di 
         mov ax, 0xb800 
         mov es, ax                        ; point es to video base 
         mov di, 0                         ; point di to top left column 

nextloc: mov word [es:di], 0x0720          ; clear next char on screen 
         add di, 2                         ; move to next screen location 
         cmp di, 4000                      ; has the whole screen cleared 
         jne nextloc                       ; if no clear next position 
         pop di 
         pop ax 
         pop es 
         ret  

start:   call clrscr                       ; call clrscr

         mov ax,0xB800
         mov es,ax
         mov ah,0
         int 0x16                          ; get keystroke
         mov di,160
         mov si,msg1
         mov cx,22
         mov ah,0x07
loop1:   lodsb                             ; print msg1
         stosw
         loop loop1

         mov ah,0
         int 0x16                          ; get keystroke
         mov di,480
         mov si,msg2
         mov cx,17
         mov ah,0x07
loop2:   lodsb                             ; print msg2
         stosw
         loop loop2

         mov ah,0
         int 0x16                          ; get keystroke
         mov di,800
         mov si,msg3
         mov cx,22
         mov ah,0x07
loop3:   lodsb                             ; print msg3
         stosw
         loop loop3  

         mov ah,0
         int 0x16                          ; get keystroke
         mov di,1120
         mov si,msg4                       
         mov cx,28
         mov ah,0x07
loop4:   lodsb                             ; print msg4
         stosw
         loop loop4

         mov ah,0
         int 0x16                          ; get keystroke
         mov ax,0x4c00                     ; terminate the program
         int 0x21              