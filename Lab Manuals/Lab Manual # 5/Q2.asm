[org 0x0100]
               jmp start
arr1:          dw 9,8,4,5,2 ; array1 
arr2:          dw 7,3,9,2,3 ; array2
size:          dw 5 ; size of both arrays

multiply:      push bp ; start of multiply subroutine
               mov bp,sp
               push ax ; save registers
               push bx
               push cx
               mov ax,[bp+4] ; move multiplicand in ax
               mov bx,[bp+6]; move multiplier in bx
               mov word[bp+8],0 ; initialize return value with 0

               mov cx,0 ; start counter with 0
loop1:         cmp cx,8 ; compare counter with 8 since 8 bit multiplication
               je endOfMultiply ; jump to end of subroutine if all bits of multiplier are checked
               shr bx,1 ; shift multiplier right by one bit
               jnc skip ; jump to skip if bit from multiplier is not 1
               add word[bp+8],ax ; add multiplican in the retur value
skip:          shl ax,1 ; shift the multiplicand left by one bit
               inc cx ; update counter
               jmp loop1 ; jump to loop1

endOfMultiply: pop cx ; restore values of registers
               pop bx
               pop ax
               mov sp,bp 
               pop bp ; restore bp
               ret 4 ; return to caller

series:        push bp ; start of series subroutine
               mov bp,sp 
               push ax ; save registers
               push bx
               push cx
               push dx
               push si
               push di
               mov word[bp+10],0 ; initialize return value with zero
               mov ax,[bp+4] ; move size of arrays in ax
               add ax,ax ; double the value of size
               mov [bp+4],ax ; overwrite the value of size with the doubled value

               mov si,0 ; initialze si with zero
loop2:         cmp si,[bp+4] ; compare si with last index+2
               je endOfSeries ; jump if whole array(s) is traversed 
               sub sp,2 ; making space for return value on stack for multiply subroutine
               mov bx,[bp+8]
               mov ax,[bx+si]
               push ax ; push each element of array1 on stack as parameter
               mov bx,[bp+6]
               mov ax,[bx+si]
               push ax ; push each element of array2 on stack as parameter
               call multiply ; call multiply subroutine
               pop ax ; retrieve return value in ax from multiply subroutine
               add [bp+10],ax ; add returned value/product in return value of series subroutine
               add si,2 ; increment si to point to next index position of arrays
               jmp loop2 ; jump to loop2

endOfSeries:   pop di ; restore values of registers
               pop si
               pop dx
               pop cx
               pop bx
               pop ax
               mov sp,bp
               pop bp ; restore bp
               ret 6 ; return to caller

start:         sub sp,2 ; making space for return value on stack for series subroutine
               mov ax,arr1 
               push ax ; push address of array1 as parameter to series subroutine
               mov ax,arr2
               push ax ; push address of array2 as parameter to series subroutine
               mov ax,[size]
               push ax ; push size of arrays as parameter to series subroutine
               call series ; call series subroutine
               pop cx ; retrieve return value in cx from series subroutine

               mov ax,0x4c00
               int 0x21