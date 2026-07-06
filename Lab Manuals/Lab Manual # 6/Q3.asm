[org 0x0100]
            jmp start              ; execution begins from start
redFlag :   db 1                   ; flag to tell whether the background colour is red or blue

offsetCalc: push bp                ; subroutine to calculate offset from x and y coordinates
            mov bp,sp
            push ax                ; save registers
             
            mov ah,0               ; clear ah
            mov al,80              ; put 80 in al 
            mul byte[bp+4]         ; multiply y coordinate with 80 
            add ax,[bp+6]          ; add x coordinate in ax
            shl ax,1               ; multiply ax by 2
            mov [bp+8],ax          ; put the calculated offset in return value
            pop ax                 ; restore registers
            mov sp,bp
            pop bp
            ret 4

start:      mov ax,0xB800 
            mov es,ax              ; put offset of video memory in es
            mov cx,0               ; initialize cx with zero y coordinate
 
loop1:      cmp cx,25              ; start of loop1
            je end                 ; loop run 25 times
            mov bx,0               ; initilize bx with zero x coordinate

loop2:      cmp bx,80              ; start of loop2
            je endOfLoop2          ; loop runs 80 times
            sub sp,2               ; make space for return value
            push bx                ; push x coordinate
            push cx                ; push y coordinate
            call offsetCalc        ; call offsetCalc
            pop di                 ; pop offset in di
            cmp byte[redFlag],1    ; check whether background is red or blue using redFlag
            je red                 ; if redFlag is true then jump to red
            mov byte[es:di+1],0x1F ; set background as blue for current position on screen
            jmp skip               ; jump to skip
red:        mov byte[es:di+1],0x4F ; set background as red for current position on screen
skip:       add bx,1               ; move to next x coordinate
            jmp loop2              ; jump to loop2

endOfLoop2: xor byte[redFlag],1    ; invert the redFlag
            add cx,1               ; move to next y coordinate
            jmp loop1              ; jump to loop1

end:        mov ah,0               ; end of program
            int 0x16
            mov ax,0x4c00
            int 0x21