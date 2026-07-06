[org 0x0100]

                        mov bx,0                  ; initialize bx with 0
                        mov cl,[startingBit]      ; move starting bit number to cl, cl will eventually store the remainder from division by 8
loop1:                  cmp cl,0                  ; compare cl with 0
                        je multipleOfEightCase    ; if cl is 0 then starting bit number is divisible by 8
                        cmp cl,8                  ; compare cl with 8
                        jb notMultipleOfEightCase ; if cl is less than 8 then starting bit number is not divisible by 8
                        sub cl,8                  ; repeatedly subtract 8 from cl to perform division by 8
                        inc bx                    ; bx stores the quotient from the division
                        jmp loop1

multipleOfEightCase:    mov al,[buffer+bx]        ; move the complete byte to al in case starting bit number is divisible by 8
                        jmp end

notMultipleOfEightCase: mov ah,[buffer+bx]        ; move the byte to ah conatining one portion of required 8 bits
                        mov al,[buffer+bx+1]      ; move the other byte to al conating the other portion of required 8 bits
                        shl ax,cl                 ; shift left the register ax by remainder number of times to drop remainder number of excess bits on the left
                        shr ax,8                  ; shift right the register ax by 8 to drop the 8 excess bits on the right
                        jmp end

end:                    mov ax,0x4c00
                        int 0x21
buffer:                 db 37,12,38,60,5,28,76,27,23,0,98,73,60,44,70,25,73,56,58,27,93,32,38,36,67,22,16,57,39,68,85,82 ; 32 bytes
startingBit:            db 7