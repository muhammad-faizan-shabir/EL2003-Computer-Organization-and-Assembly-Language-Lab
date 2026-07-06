[org 0x0100]
mov cx,1
outerLoop:cmp cl,[size]
jae end
mov bx,cx
innerLoop:cmp bx,0
jna endInner
mov al,[arr+bx-1]
cmp al,[arr+bx]
jng endInner
mov dl,[arr+bx]
mov [arr+bx],al
mov [arr+bx-1],dl
sub bx,1
jmp innerLoop
endInner:add cx,1
jmp outerLoop
end:mov ax,0x4c00
int 0x21
arr: db -10,2,0,-15,3,7,14,1,-12,-11
size: db 10