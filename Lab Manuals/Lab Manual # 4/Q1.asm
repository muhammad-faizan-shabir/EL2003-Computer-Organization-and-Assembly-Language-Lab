[org 0x0100]

            mov bx,0xB189        ; initialize bx 
            mov ax,0xABA5        ; initialize ax

            mov cx,1             ; initialize cx to test 0th bit
loop1:      cmp cx,0             ; loop1 ends when cx becomes zero
            je endOfLoop1  
            test cx,bx           ; test each bit of bx
            jz skip              ; jump to skip if a bit of bx is  not 1
            inc word[oneCounter] ; count the number of one bits in bx
skip:       shl cx,1             ; shift cx towards left to check the next bit in bx
            jmp loop1

endOfLoop1: mov cx,0             ; initilize cx with 0
            mov dx,1             ; initialize dx to set 0th bit
loop2:      cmp cx,[oneCounter]  ; loop2 ends when the required number of bits have become 1
            je endOfLoop2 
            or [mask],dx         ; set the required bit to create a mask
            shl dx,1             ; shift dx towards left to set the next bit in the mask
            inc cx               ; update cx
            jmp loop2

endOfLoop2: xor ax,[mask]        ; invert the required bits of ax using the mask and XOR operation

            mov ax,0x4c00
            int 0x21
oneCounter: dw 0
mask:       dw 0