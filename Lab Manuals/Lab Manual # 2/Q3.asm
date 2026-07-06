;lab2task2code
[org 0x0100]
;code
Mov ax, 9876h
Mov bx, 5432h
Mov [num1], ax ; [num1] =9876
Mov [num2], bx ; [num2]=5432
Mov [num2+2], bx ; [num2+2]=5432
Mov [array1], ax ; [array1]=9876
Mov [array2], bl ; [array2]=32
Mov [array2], ax ; [array2]=9876
Mov word [num1], 0000h ; [num1]=0000
Mov byte [num1], 01h ; [num1]=01;
Mov byte [num2+1], 11h ;  [num2+1]=11
Mov word [array1+2], 3870h ;  [array1+2]=3870
mov ax, 0x4c00 ; termination statements
int 21h
; data
num1: dw 0A0Bh
num2: dd 0C0D0E0Dh
array1: dw 0102h , 0304h
array2: db 05h , 06h, 07h