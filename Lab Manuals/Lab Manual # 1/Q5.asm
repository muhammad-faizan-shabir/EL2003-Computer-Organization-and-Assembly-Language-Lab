[org 0x0100]
         mov ax,[num]     ; move number 6 to ax
         mov bx,4         ; for multiplication by 4
         mov cx,4         ; counter
mult:    add [mresult],ax ; start of loop
         sub cx,1         ; updating counter
         jnz mult         ; jumping to start of loop based on condition
         
         mov ax,[mresult] ; moving previous answer to ax
         mov cx,0         ; counter
division:inc cx           ; start of loop
         sub ax,3         ; subtraction by three
         jnz division     ; jumping to start of loop based on condition
         mov [dresult],cx ; moving result to memory
         
         mov ax,0x4c00
         int 0x21
num:     dw 6
mresult: dw 0
dresult: dw 0