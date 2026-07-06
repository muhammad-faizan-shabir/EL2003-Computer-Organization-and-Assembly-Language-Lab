[org 0x0100]
            jmp start

xcord:      dw 0
ycord:      dw 0

offsetCalc: push bp                  ; subroutine to calculate required offset in the video memory
            mov bp,sp
            push ax                  ; save registers
            
            mov ah,0                 ; clear ah
            mov al,80                ; put 80 in al
            mul byte[bp+4]           ; multiply y coordinate with 80 
            add ax,[bp+6]            ; add x coordinate in ax
            shl ax,1                 ; multiply ax by 2
            mov [bp+8],ax            ; put the calculated offset in the return value 
            
            pop ax                   ; restore registers
            mov sp,bp
            pop bp
            ret 4

timer:      push ax                  ; timer interrupt service routine
            push di
            push es

            mov ax,0xB800
            mov es,ax
            sub sp,2
            mov ax,[cs:xcord]
            push ax
            mov ax,[cs:ycord]
            push ax
            call offsetCalc
            pop di
            mov word[es:di],0x0720   ; print empty space on current position before moving to next position

check1:     cmp word[cs:ycord],0     ; check if ycord is equal to 0
            jne check2
            cmp word[cs:xcord],79    ; check if xcord is less than 79
            jnb check2
            add word[cs:xcord],1     ; increment xcord
            jmp skipall

check2:     cmp word[cs:xcord],79    ; check if xcord is 79
            jne check3
            cmp word[cs:ycord],24    ; check if ycord is less than 24
            jnb check3
            add word[cs:ycord],1     ; increment ycord
            jmp skipall 

check3:     cmp word[cs:ycord],24    ; check if ycord is equal to 24
            jne check4
            cmp word[cs:xcord],0     ; check f xcord is greater than 0
            jna check4  
            sub word[cs:xcord],1     ; decrement xcord
            jmp skipall

check4:     cmp word[cs:xcord],0     ; check if xcord is equal to zero
            jne skipall
            cmp word[cs:ycord],0     ; check if ycord is greater than 0
            jna skipall 
            sub word[cs:ycord],1     ; decrement ycord

skipall:    sub sp,2
            mov ax,[cs:xcord]
            push ax
            mov ax,[cs:ycord]
            push ax
            call offsetCalc
            pop di
            mov word[es:di],0x072A   ; print asterisk at the updated position

            mov al, 0x20
            out 0x20, al             ; end of interrupt
            pop es
            pop di
            pop ax
            iret                     ; return from interrupt

start:      xor ax, ax
            mov es, ax               ; point es to IVT base

            cli                      ; disable interrupts
            mov word [es:8*4], timer ; store offset at n*4
            mov [es:8*4+2], cs       ; store segment at n*4+2
            sti                      ; enable interrupts

            mov dx, start            ; end of resident portion
            add dx, 15               ; round up to next para
            mov cl, 4
            shr dx, cl               ; number of paras
            mov ax, 0x3100           ; terminate and stay resident
            int 0x21