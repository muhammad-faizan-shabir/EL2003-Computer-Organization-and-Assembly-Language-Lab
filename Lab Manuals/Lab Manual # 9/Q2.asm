[org 0x0100]
                 jmp start

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

drawRectangle:  push bp                   ; subroutine that takes x and y coordinates as top left corner and print a 4by4 rectangle
                mov bp,sp
                sub sp,2
                push ax
                push bx
                push cx
                push dx
                push si
                push di
                push es

                mov ax,0xB800
                mov es,ax                 ; point to video memory
                mov al,[bp+4]             ; get y coordinate
                mov bl,80  
                mul bl                    ; multiply y coordinate with 80
                add ax,[bp+6]             ; add x coordinate to previous result
                shl ax,1                  ; multiply previous result by 2

                mov [bp-2],ax             ; save the calculated offset
                mov ax,0x4420             ; the word to be printed on screen
 
                mov di,[bp-2]
                mov cx,4
                rep stosw                 ; print upper horizontal border

                mov di,[bp-2]
                add di,480
                mov cx,4  
                rep stosw                 ; print lower horizontal border

                mov di,[bp-2]
                add di,160
                mov si,di
                add si,6
                mov cx,3

verticalBorder: cmp cx,0                  ; print both vertical borders
                jbe endOfRectangle
                mov word[es:di],0x4420
                mov word[es:si],0x4420
                add di,160
                add si,160
                sub cx,1
                jmp verticalBorder

endOfRectangle: pop es                    ; end of subroutine
                pop di
                pop si 
                pop dx
                pop cx
                pop bx
                pop ax
                mov sp,bp
                pop bp
                ret 4

start:          mov dx,37                 ; intial x coordinate of top left of the rectangle 
                mov bx,10                 ; intial y coordinate of top left of the rectangle 

loop1:          call clrscr               ; call clrscr
                push dx                   ; pass x coordinate as parameter
                push bx                   ; pass y coordinate as parameter
                call drawRectangle        ; call drawRectangle

                mov ah,0
                int 0x16                  ; get key input
                cmp al,27                 ; check if escape key is pressed
                je end                    ; exit if esscape key is pressed

up:             cmp ah,0x48               ; check if up arrow key is pressed
                jne down
                cmp bx,0
                jbe loop1
                sub bx,1                  ; decrement y coordinate if not out of range
                jmp loop1

down:           cmp ah,0x50               ; check if down key is pressed
                jne right
                cmp bx,21
                jae loop1  
                add bx,1                  ; increment y coordinate if not out of range
                jmp loop1

right:          cmp ah,0x4D               ; check if right key is pressed
                jne left
                cmp dx,76
                jae loop1
                add dx,1                  ; increment x coordinate if not out of range
                jmp loop1

left:           cmp ah,0x4B               ; check if left key is pressed
                jne loop1
                cmp dx,0
                jbe loop1
                sub dx,1                  ; deccrement x coordinate if not out of range
                jmp loop1
 
end:            mov ax,0x4c00             ; terminate program 
                int 0x21




