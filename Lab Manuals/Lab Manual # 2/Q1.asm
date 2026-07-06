; lab2Task1code
[org 0x0100]
; no code because we just want to look
; at how data is stored in memory
mov ax, 0x4c00 ; termination statements
int 21h
; data declaration
Num1: dd 0A0B0C0Dh
Num2: dw 0102h
Num3 db 33h
Nums: dw 3456h
db 99h
my_array: dw 0E0Fh, 0506h, 0708h, 0910h

; 0D is stored at 0105
; 0C is stored at 0106
; 0B is stored at 0107
; 0A is stored at 0108
; 02 is stored at 0109
; 01 is stored at 010A
; 33 is stored at 010B
; 56 is stored at 010C
; 34 is stored at 010D
; 99 is stored at 010E
; 0F is stored at 010F
; 0E is stored at 0110
; 06 is stored at 0111
; 05 is stored at 0112
; 08 is stored at 0113
; 07 is stored at 0114
; 10 is stored at 0115
; 09 is stored at 0116