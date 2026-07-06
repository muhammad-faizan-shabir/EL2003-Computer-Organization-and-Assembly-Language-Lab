[org 0x0100]
                jmp start                ; execution begins from start

clrscr:         push es                  ; subroutine to clear the screen
                push ax 
                push di 
                mov ax, 0xb800 
                mov es, ax               ; point es to video base 
                mov di, 0                ; point di to top left column 

nextloc:        mov word [es:di], 0x0720 ; clear next char on screen 
                add di, 2                ; move to next screen location 
                cmp di, 4000             ; has the whole screen cleared 
                jne nextloc              ; if no clear next position 
                pop di 
                pop ax 
                pop es 
                ret  

offsetCalc:     push bp                  ; subroutine to calculate offset from x and y coordinates
                mov bp,sp 
                push ax                  ; save registers
                
                mov ah,0                 ; clear ah
                mov al,80                ; put 80 in al
                mul byte[bp+4]           ; multiply y coordinate with 80 
                add ax,[bp+6]            ; add x coordinate in ax
                shl ax,1                 ; multiply ax by 2
                mov [bp+8],ax            ; move the calculated offset in return value
                pop ax                   ; restore registers
                mov sp,bp
                pop bp
                ret 4

PrintRectanlge: push bp                  ; subroutine to print rectangle
                mov bp,sp
                push ax                  ; save registers
                push si
                push di
                push es
                mov ax,0xB800 
                mov es,ax                ; initialize es with offset of video memory
                mov al,[bp+4]            ; put the attribute in al

                mov si,[bp+12]            ; put the x coordinate of TopLeft in si
loop1:          cmp si,[bp+8]             ; comapre x coordinate of TopLeft with x coordinate of BottomRight
                ja endOfLoop1             ; loop1 runs (the diffrence of both x coordinates + 1) times
                sub sp,2                  ; make space for return value
                push si                   ; push x coordinate
                push word[bp+10]          ; push y coordinate of TopLeft
                call offsetCalc           ; call offsetCalc
                pop di                    ; pop the offset in di
                mov byte[es:di+1],al      ; put attribute at the calculated offset
                sub sp,2                  ; make space for return value
                push si                   ; push x coordinate
                push word[bp+6]           ; push y coordinate of BottomRight
                call offsetCalc           ; call offsetCalc
                pop di                    ; pop the offset in di
                mov byte[es:di+1],al      ; put attribute at the calculated offset
                add si,1                  ; move to next x coordinate from TopLeft
                jmp loop1                 ; jump to loop1

endOfLoop1:     mov si,[bp+10]            ; put the y coordinate of TopLeft in si
loop2:          cmp si,[bp+6]             ; comapre y coordinate of TopLeft with y coordinate of BottomRight
                ja endOfLoop2             ; loop2 runs (the diffrence of both y coordinates + 1) times
                sub sp,2                  ; make space for return value
                push word[bp+12]          ; push x coordinate of TopLeft
                push si                   ; push y coordinate
                call offsetCalc           ; call offsetCalc
                pop di                    ; pop the offset in di
                mov byte[es:di+1],al      ; put attribute at the calculated offset
                sub sp,2                  ; make space for return value
                push word[bp+8]           ; push x coordinate of BottomRight
                push si                   ; push y coordinate
                call offsetCalc           ; call offsetCalc
                pop di                    ; pop the offset in di
                mov byte[es:di+1],al      ; put attribute at the calculated offset
                add si,1                  ; move to next y coordinate from TopLeft
                jmp loop2                 ; jump to loop2

endOfLoop2:     pop es                    ; restore registers
                pop di
                pop si
                pop ax
                mov sp,bp 
                pop bp
                ret 10

start:          call clrscr               ; call clrscr
                push 9                    ; push the x coordinate of TopLeft
                push 1                    ; push the y coordinate of TopLeft
                push 59                   ; push the x coordinate of BottomRight
                push 19                   ; push the y coordinate of BottomRight
                push 0x4F                 ; push the desired attribute
                call PrintRectanlge       ; call PrintRectanlge

end:            mov ah,0                  ; end of program
                int 0x16
                mov ax,0x4c00
                int 0x21


