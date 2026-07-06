[org 0x0100]

              mov cl, 32                  ; initialize bit count to 32
             
checkbit:     shr word[multiplier+2],1    ; move right most bit in carry with extended right shift
              rcr word[multiplier],1
              jnc skip                    ; skip addition if bit is zero
              
              mov ax, [multiplicand]
              add word[result], ax        ; add least significant words
              mov ax, [multiplicand+2]
              adc word[result+2], ax      ; add next significant words with carry
              mov ax, [multiplicand+4]
              adc word[result+4], ax      ; add next significant words with carry
              mov ax, [multiplicand+6]
              adc word[result+6], ax      ; add most significant words with carry

skip:         shl word[multiplicand], 1   ; shift left least significant word of multiplicand
              rcl word[multiplicand+2], 1 ; shift left next significant word of multiplicand 
              rcl word[multiplicand+4], 1 ; shift left next significant word of multiplicand 
              rcl word[multiplicand+6], 1 ; shift left most significant word of multiplicand
              
              dec cl                      ; decrement bit count
              jnz checkbit                ; repeat if bits left

              mov ax, 0x4c00              ; terminate program
              int 0x21
multiplicand: dq 0xABCDD4E1               ; 32bit multiplicand 64bit space
multiplier:   dd 0xAB5C32                 ; 32bit multiplier
result:       dq 0                        ; 64bit result