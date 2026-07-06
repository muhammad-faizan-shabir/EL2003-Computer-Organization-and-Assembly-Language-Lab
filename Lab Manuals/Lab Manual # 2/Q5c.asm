[org 0x0100]
                mov ax,[temperature]       ; move temperature to ax
                
                cmp ax,0                   ; compare temperature with 0
                jl if1                     ; jump to first if block if temperature<0
                
                cmp ax,25                  ; compare temperature with 25
                jl if2                     ; jump to second if block if temperature>=0 and temperature<25
                
                cmp ax,70                  ; compare temperature with 70
                jl if3                     ; jump to third if block if temperature>=25 and temperature<70
                
                mov word[classification],4 ; else block
                jmp end

if1:            mov word[classification],1 ; first if block
                jmp end

if2:            mov word[classification],2 ; second if block
                jmp end

if3:            mov word[classification],3 ; third if block
                jmp end

end:            mov ax,0x4c00
                int 0x21
temperature:    dw 78
classification: dw 0