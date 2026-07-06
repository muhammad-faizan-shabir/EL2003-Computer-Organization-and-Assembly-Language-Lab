[org 0x0100]

      mov ax,[num2]       ; move the least significant word of num2 in ax
      sub word[num1],ax   ; subtract the least significant word of num2 from the least significant word of num1 

      mov ax,[num2+2]     ; move the next significant word of num2 in ax
      sbb word[num1+2],ax ; subtract the next significant word of num2 with borrow from the next significant word of num1 

      mov ax,[num2+4]     ; move the next significant word of num2 in ax
      sbb word[num1+4],ax ; subtract the next significant word of num2 with borrow from the next significant word of num1

      mov ax,[num2+6]     ; move the most significant word of num2 in ax
      sbb word[num1+6],ax ; subtract the most significant word of num2 with borrow from the most significant word of num1 

      mov ax,0x4c00
      int 0x21
num1: dq 0x880060FF4000FFFF
num2: dq 0x8F0F000040018000
