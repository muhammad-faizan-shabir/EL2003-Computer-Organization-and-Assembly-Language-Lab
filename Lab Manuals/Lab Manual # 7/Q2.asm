[org 0x0100]
                    jmp start
                    character: db '%'
                    StartingRow: db 5
                    EndingRow: db 11

clrscr:             push es                  ; subroutine to clear the screen
                    push ax 
                    push di 
                    mov ax, 0xb800 
                    mov es, ax               ; point es to video base 
                    mov di, 0                ; point di to top left column 

nextloc:            mov word [es:di], 0x0720 ; clear next char on screen 
                    add di, 2                ; move to next screen location 
                    cmp di, 4000             ; has the whole screen cleared 
                    jne nextloc              ; if no clear next position 
                    pop di 
                    pop ax 
                    pop es 
                    ret  

HollowTriangle:     push bp                  ; sub routine to print hollow triangle
                    mov bp,sp
                    sub sp,2
                    push ax                  ; save registers
                    push bx
                    push cx
                    push dx
                    push si
                    push di

                    mov ax,0xB800 
                    mov es,ax                ; load video memory segment in es
                    mov bx,[bp+4] 
                    mov cx,[bx]              ; move ending row address in cx 
                    mov ch,0 
                    mov bx,[bp+6]
                    sub cl,byte[bx]          ; subtract starting row from ending row
                    mov [bp-2],cx            ; put the difference in local variable
                    mov ah,0
                    mov bx,[bp+6] 
                    mov al,[bx]              ; move starting row in al
                    mov bl,80 
                    mul bl                   ; multiply starting row with 80
                    add ax,39                ; move to central column
                    shl ax,1                 ; get offset
                    mov di,ax                ; initialize di
                    mov si,ax                ; initialize si
                    mov bx,[bp+8] 
                    mov dl,[bx]              ; put the character in dl
                    mov dh,0x07              ; put the attribute in dh

                    mov cx,0
loop1:              cmp cx,[bp-2]            ; loop1 runs cx times
                    je loop2                 ; jump to loop2 if loop1 ends
                    mov [es:di],dx           ; put character at desired location
                    mov [es:si],dx           ; put character at desired location
                    add di,160               ; move di to next row
                    add si,160               ; move si to next row
                    sub di,2                 ; move to previous column 
                    add si,2                 ; move to next column
                    add cx,1                 ; update counter
                    jmp loop1                ; jump to loop1 

loop2:              cmp di,si                ; loop2 prints the last row of the triangle
                    ja endOfHollowTriangle   ; jump to end of subroutine when loop2 ends
                    mov [es:di],dx           ; put character at desired location
                    add di,2                 ; move to next column
                    jmp loop2                ; jump to loop2

endOfHollowTriangle: pop di                  ; restore registers
                     pop si
                     pop dx
                     pop cx
                     pop bx
                     pop ax
                     mov sp,bp
                     pop bp
                     ret 6                   ; return to caller

start:              call clrscr              ; call clear screen subroutine

                    push character           ; push character's address
                    push StartingRow         ; push starting row's address
                    push EndingRow           ; push ending rows's address
                    call HollowTriangle      ; call HollowTriangle

                    mov ah,0
                    int 0x16
                    mov ax,0x4c00            ; end of program
                    int 0x21