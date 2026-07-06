[org 0x0100]

                 mov bx,0           ; intialize bx with 0
outerLoop:       cmp bx,20          ; compare bx with 20 since there are 10 words
                 je end             ; jump to end if bx becomes 20
                 mov ax,[arr+bx]    ; fetch elements from arr

                 mov si,bx          ; initialize si with index succeeding bx
                 add si,2
innerLoop1:      cmp si,20          ; compare si with 20 since there are 10 words
                 je endofInnerLoop1
                 mov dx,[arr+si]    ; fetch elements succeeding current element
                 cmp dx,ax          ; match succeeding elements with current element
                 je skip            ; jump to skip if any of the succeeding elements matches with the current element
                 add si,2           ; update si
                 jmp innerLoop1     ; jump to innerLoop1 

endofInnerLoop1: mov si,bx          ; initialize si with index preceeding bx
                 sub si,2
innerLoop2:      cmp si,-2          ; compare si with -2 which marks the point previous to 0th index
                 je addition        ; end of this loop means that the current element is unique
                 mov dx,[arr+si]    ; fetch elements preceeding the current element
                 cmp dx,ax          ; match preceeding elements with current element
                 je skip            ; jump to skip if any of the preceeding elements matches with the current element
                 sub si,2           ; update si
                 jmp innerLoop2     ; jump to innerLoop2

addition:        add [sum],ax       ; add the unique element in the sum
skip:            add bx,2           ; update bx
                 jmp outerLoop      ; jump to outerLoop

end:             mov ax,0x4c00
                 int 0x21
sum:             dw 0
arr:             dw 2,5,7,2,6,7,9,3,4,2