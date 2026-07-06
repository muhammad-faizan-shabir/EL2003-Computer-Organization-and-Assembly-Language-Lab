[org 0x0100]
mov ax,10
mov bx,20
mov cx,30

mov dx,cx
mov cx,bx
mov bx,ax
mov ax,dx
mov dx,cx
mov cx,bx
mov bx,ax
mov ax,dx
mov dx,cx
mov cx,bx
mov bx,ax
mov ax,dx ; first rotation complete

mov dx,cx
mov cx,bx
mov bx,ax
mov ax,dx
mov dx,cx
mov cx,bx
mov bx,ax
mov ax,dx
mov dx,cx
mov cx,bx
mov bx,ax
mov ax,dx ; second rotation complete

mov ax,0x4c00
int 0x21

