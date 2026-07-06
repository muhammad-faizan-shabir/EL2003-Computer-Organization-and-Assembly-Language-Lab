[org 0x0100]

         mov ah,[array]    ; ah will store max number
         mov al,[array]    ; al will store min number
         mov bx,1          ; bx will ax as counter  

start:   mov cl,[array+bx] ; fetch each each element from arary
         cmp ah,cl         ; compare each element with current max 
         jb high           
         cmp al,cl         ; compare each element with current min
         ja low
counter: add bx,1          ; increment bx each time
         cmp bx,10         ; compare bx with 10
         jne start         ; jump to start until all numbers are fetched
         jmp end
low:     mov al,cl         ; code to update min num
         jmp counter
high:    mov ah,cl         ; code to update max num
         jmp counter

end:     mov ax,0x4c00
         int 0x21
array:   db 1,2,3,4,5,6,7,8,9,10