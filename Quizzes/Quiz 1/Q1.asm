[org 0x0100]

                  mov si,Given_Array           ; initialize si with address of 0th index
                  mov di,Given_Array
                  add di,[ArrSize]
                  sub di,1                     ; intialize d with address of last index position
                  mov bx,0                     ; intialize bx with 0

start:            cmp si,di                    ; compare si and di
                  je oddCase                   ; if si and di have become equal then there are odd number of elements in the array
                  ja end                       ; if si becomes greater than di then there are even number of elements in the array
                  mov al,[si]                  ; move data from left side indices into al
                  mov dl,[di]                  ; move data from right side indices int dl
                  add al,dl                    ; add al and dl
                  mov [PairwiseSumArray+bx],al ; move the sum to the PairwiseSumArray
                  add si,1                     ; increment si
                  sub di,1                     ; decrement di
                  add bx,1                     ; increment bx
                  jmp start                    ; jump to start of loop

oddCase:          mov al,[si]                  ; handle odd case by moving the middle entry to the last of the PairwiseSumArray
                  mov [PairwiseSumArray+bx],al
 
end:              mov ax,0x4c00
                  int 0x21
ArrSize:          dw 9
Given_Array:      db 10,2,3,4,77,50,62,70,8
PairwiseSumArray: db 0,0,0,0,0,0,0,0,0