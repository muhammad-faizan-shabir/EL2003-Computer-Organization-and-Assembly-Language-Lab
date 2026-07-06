[org 0x0100]

      mov si,0         ; index for outre loop
l1:   mov di,0         ; index for inner loop
      mov al,[arr1+si] ; each value of arr1

l2:   mov dl,[arr2+di] ; each value of arr2
      cmp al,dl        ; compare value of arr1 and arr2
      je if       
      jmp skip
if:   mov bl,[k]       ; intersection of values
      mov [arr3+bx],dl
      add byte[k],1
skip: add di,1         ; update index for inner loop
      cmp di,[len2]
      jne l2
      
      add si,1         ; update index for outer loop
      cmp si,[len1]
      jne l1

end:  mov ax,0x4c00
      int 0x21
k:    db 0
len1: dw 10
len2: dw 10
arr1: db 1,2,3,4,5,6,7,8,9,10
arr2: db 1,43,5,33,8,67,10,23,50,2
arr3: db 0,0,0,0,0,0,0,0,0,0
 