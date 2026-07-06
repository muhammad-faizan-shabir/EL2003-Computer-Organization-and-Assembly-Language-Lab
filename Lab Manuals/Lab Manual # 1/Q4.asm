[org 0x100]
mov ax,[num1]
add [result],ax
mov ax,[num2]
add [result],ax
mov ax,[num3]
add [result],ax
mov ax,[num4]
add [result],ax
mov ax,[num5]
add [result],ax
mov ax, 0x4c00
int 0x21
num1: dw 10
num2: dw 20
num3: dw 30
num4: dw 40
num5: dw 50
result: dw 0