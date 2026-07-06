[org 0x0100]

       mov ax,[word1] ; put word1 in ax
       mov bx,[word2] ; put word2 in bx

       xor ax,bx      ; xor ax with bx
       jnz unset      ; zero flag will not set if word1 and word2 are not equal
       mov dx,1       ; if zero flag is set then this line will put 1 in dx
       jmp end
unset: mov dx,0       ; if zero flag is not set then this line will put 0 in dx

end:   mov ax,0x4c00 
       int 0x21
word1: dw 0x1234
word2: dw 0x1234