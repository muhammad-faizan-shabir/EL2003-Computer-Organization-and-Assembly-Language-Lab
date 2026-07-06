;lab2task2code
[org 0x0100]
;code
Mov ax, [num1] ;ax=0A0B ah=0A al=0B
Mov ax, [num2] ;ax=0E0D ah=0E al=0D
Mov ax, [num2+2] ;ax=0C0D ah=0C al=0D
Mov ax, [num2+1] ;ax=0D0E ah=0D al=0E
Mov al, [num2+3] ;ax=0D0C ah=0D al=0C
Mov ah, [num1] ;ax=0B0C ah=0B al=0C
Mov ax, [array1] ;ax=0102 ah=01 al=02
Mov ax, [array1+2] ;ax=0304 ah=03 al=04
Mov al, [array2] ;ax=0305 ah=03 al=05
Mov al, [array2+1] ;ax=0306 ah=03 al=06
Mov ax, [array2] ;ax=0605 ah=06 al=05
mov ax, 0x4c00 ; termination statements
int 21h
; data
num1: dw 0A0Bh
num2: dd 0C0D0E0Dh
array1: dw 0102h , 0304h
array2: db 05h , 06h, 07h