[org 0x0100]
              jmp start 
arr:          dw 1,2,3,4       ; array
size:         dw 4             ; size of array

rotate:       push bp          ; start of rotate subroutine
              mov bp,sp
              push ax          ;saving registers
              push bx
              push cx
              push dx
              push si
              push di
              mov ax,[bp+8]    ; move the size parameter in ax
              add ax,ax        ; multiply ax by 2
              mov [bp+8],ax    ; mov ax back into the size parameter 
              mov bx,[bp+10]   ; move address of array in bx
              mov ax,[bp+6]    ; move the direction parameter in ax
              cmp ax,0         ; compare the direction with 0
              je leftRotation  ; if direction is zero then jump to letfRotation code
                
              mov cx,0         ; right rotation code starts here
loop3:        cmp cx,[bp+4]    ; comapare cx with number of rotations parameter
              je end           ; jump to end of subroutine if required number of rotations are completed
              mov si,0         ; intialize si with zero
              add si,[bp+8]    ; add size parameter to si
              sub si,2         ; move si to last element of array
              mov dx,[bx+si]   ; save the last element of array in dx
              sub si,2         ; move si to 2nd last element of array
loop4:        cmp si,-2        ; compare si with -2
              je endOfloop4    ; jump to end of loop4 if one pass is completed
              mov ax,[bx+si]   ; move current element in ax
              mov [bx+si+2],ax ; move current element one position ahead
              sub si,2         ; move si to next element
              jmp loop4        ; jump to loop4
endOfloop4:   mov [bx],dx      ; move the value saved in dx at the first index position in the array
              add cx,1         ; increment counter           
              jmp loop3        ; jump to loop3
                
leftRotation: mov cx,0         ; start of leftRotation code
loop1:        cmp cx,[bp+4]    ; comapare cx with number of rotations parameter
              je end           ; jump to end of subroutine if required number of rotations are completed
              mov dx,[bx]      ; save first element of array in dx
              mov si,2         ; move si 2nd element
loop2:        cmp si,[bp+8]    ; compare si with size of array
              je endOfloop2    ; jump to end of loop2 if one pass is completed
              mov ax,[bx+si]   ; move current element in ax
              mov [bx+si-2],ax ; move current element one position behind
              add si,2         ; move si to next element
              jmp loop2        ; jump to loop2
endOfloop2:   sub si,2
              mov [bx+si],dx   ; move the value saved in dx at the last index position in the array
              add cx,1         ; increment counter
              jmp loop1        ; jump to loop1
 
end:          pop di           ; restore register values
              pop si
              pop dx
              pop cx
              pop bx
              pop ax
              mov sp,bp        ; restore sp
              pop bp           ; restore bp
              ret 8            ; return to caller

start:        mov ax,arr 
              push ax          ; passing address of array as parameter
              mov ax,[size]
              push ax          ; passing size of array as parameter
              mov ax,1 
              push ax          ; passing direction of rotation as parameter
              mov ax,1
              push ax          ; passing number of rotations as parameter
              call rotate      ; calling rotate subroutine
              
              mov ax,0x4c00
              int 0x21
