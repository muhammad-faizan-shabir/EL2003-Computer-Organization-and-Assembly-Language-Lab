[org 0x0100]
mov ax,0x3500
mov es,ax
mov ds,ax
mov ax,0
mov si,0x1234
mov di,0x123D
mov bx,0
start:mov al,[arr+bx]
cmp al,10
jb less
mov [es:di],al
sub di,1
jmp counter
less: mov [es:si],al
add si,1
counter: add bx,1
cmp bl,[size]
jne start


mov ax,0x4c00
int 0x21
arr: db 9,20,9,20,9,20,9,20,9,20
size: db 10