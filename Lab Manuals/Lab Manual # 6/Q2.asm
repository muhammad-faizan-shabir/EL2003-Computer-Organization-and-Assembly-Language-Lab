[org 0x0100]
            jmp start        ; execution begins from start

swap:       push bp          ; subroutine to swap memory locations represented by two offsets
            mov bp,sp 
            push ax          ; save registers
            push bx
            push si
            push di
            push es

            mov ax,0xB800  
            mov es,ax        ; move video memory offset in es
            mov si,[bp+4]    ; move offset1 in si
            mov di,[bp+6]    ; move offset2 in di
            mov ax,[es:si]   ; exchange data of the two offsets
            mov bx,[es:di] 
            mov [es:si],bx
            mov [es:di],ax

            pop es           ; restore registers
            pop di
            pop si
            pop bx
            pop ax
            mov sp,bp
            pop bp
            ret 4

offsetCalc: push bp         ; subroutine to calculate required offset in the video memory
            mov bp,sp
            push ax         ; save registers
            
            mov ah,0        ; clear ah
            mov al,80       ; put 80 in al
            mul byte[bp+4]  ; multiply y coordinate with 80 
            add ax,[bp+6]   ; add x coordinate in ax
            shl ax,1        ; multiply ax by 2
            mov [bp+8],ax   ; put the calculated offset in the return value 
            
            pop ax          ; restore registers
            mov sp,bp
            pop bp
            ret 4

start:      mov ax,0        ; first row to be exchanged
            mov bx,13       ; first row to be exchanged
            mov cx,12       ; set counter to 12

loop1:      cmp cx,0        ; start of loop1
            je endOfLoop1   ; loop1 runs 12 times
            mov si,0        ; initialize si with 0 x coordinate

loop2:      cmp si,80       ; start of loop2
            je endOfLoop2   ; loop runs 80 times
            sub sp,2        ; make space for return value
            push si         ; push x coordinate 
            push ax         ; push y coordinate
            call offsetCalc ; call offsetCalc
            pop dx          ; pop offset2 in dx
            sub sp,2        ; make space for return value
            push si         ; push x coordinate
            push bx         ; push y coordinate
            call offsetCalc ; call offsetCalc
            pop di          ; pop offset1 in di
            push dx         ; push offset2
            push di         ; push offset1
            call swap       ; call swap
            add si,1        ; increment si
            jmp loop2       ; jump to loop2

endOfLoop2: add ax,1        ; next row to be exchanged
            add bx,1        ; next row to be exchanged
            sub cx,1        ; update counter
            jmp loop1       ; jump to loop1

endOfLoop1: mov cx,12       ; set counter to 12
            mov ax,12       ; row to be exchanged
            mov bx,11       ; row to be exchanged

loop3:      cmp cx,0        ; start of loop3
            je end          ; loop runs 12 times
            mov si,0        ; initialize si with 0 x coordinate

loop4:      cmp si,80       ; start of loop4
            je endOfLoop4   ; loop runs 80 times
            sub sp,2        ; make space for return value
            push si         ; push x coordinate
            push ax         ; push y coordinate
            call offsetCalc ; call offsetCalc
            pop dx          ; pop offset2 in dx
            sub sp,2        ; make space for return value
            push si         ; push x coordinate
            push bx         ; push y coordinate
            call offsetCalc ; call offsetCalc
            pop di          ; pop offset1 in di
            push dx         ; push offset2
            push di         ; push offset1
            call swap       ; call swap
            add si,1        ; update x coordinate
            jmp loop4       ; jump to loop4

endOfLoop4: sub ax,1        ; next row to be exchanged
            sub bx,1        ; next row to be exchanged
            sub cx,1        ; update counter
            jmp loop3       ; jump to loop3

end:        mov ah,0        ; end of program
            int 0x16
            mov ax,0x4c00
            int 0x21