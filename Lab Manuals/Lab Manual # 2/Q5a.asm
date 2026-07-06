[org 0x0100]

        mov ax,[x]
        mov dx,[y]
        cmp ax,dx
        ja if 
        mov ax,[z] ; else
        cmp dx,ax
        ja if2
        sub ax,dx ; else-> else
        mov [result],ax
        jmp end
if:    mov dx,[z]
        cmp ax,dx
        ja if1
        sub dx,ax ; if ->else 
       mov [result],dx
       jmp end
if2: sub dx,ax
       mov [result],dx
       jmp end
       if1: sub ax,dx
       mov [result],ax
       jmp end

end:mov ax,0x4c00
int 0x21
x : dw 8
y: dw 15
z: dw 20
result: dw 0