[org 0x0100]

   mov ax,0x6552 ; move last 4 digits of roll number in ax
   mov bx,ax     ; copy ax into bx
 
   or bx,ax      ; compute (ax||bx) and store result in bx 

   xor ax,0x1BCD ; compute (ax⊙0x1BCD) and store result in ax

   and bx,ax     ; compute (ax||bx) && (ax⊙0x1BCD) and store result in bx

   mov [f],bx    ; store the result of (ax||bx) && (ax⊙0x1BCD) in memory variable f  
   
   mov ax,0x4c00
   int 0x21
f: dw 0