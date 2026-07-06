[org 0x0100]

mov ax,0
mov cx,0

start: add ax,20
       add cx,1
       cmp cx,20
       jne start

mov ax,0x4c00
int 0x21