[org 0x0100]

      mov si,0         ; index for outre loop
l1:   mov di,0         ; index for inner loop
      mov ax,[arr1+si] ; each value of arr1

l2:   mov dx,[arr2+di] ; each value of arr2
      cmp ax,dx        ; compare value of arr1 and arr2
      je if       
      jmp skip
if:   mov bx,[k]       ; intersection of values
      mov [arr3+bx],dx
      add word[k],2
skip: add di,2         ; update index for inner loop
      cmp di,[len2]
      jne l2
      
      add si,2         ; update index for outer loop
      cmp si,[len1]
      jne l1

end:  mov ax,0x4c00
      int 0x21
k:    dw 0
len1: dw 20
len2: dw 20
arr1: dw 1,2,3,4,5,6,7,8,9,10
arr2: dw 1,43,5,33,8,67,10,23,50,2
arr3: dw 0,0,0,0,0,0,0,0,0,0
 