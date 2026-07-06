[org 0x0100]

          mov ax,[p] 
          mov dx,[q]
          cmp ax,dx
          jb if             ; entering if block
        
          mov ax,[r]        ; entering else block
          cmp dx,ax
          jb if2            ; entering else's if block
        
          mov [smallest],ax ; entering else's else block
          jmp end

if:       mov dx,[r]        ; if block
          cmp ax,dx
          jb if1            ; entring if's if block
        
          mov [smallest],dx ; entering if's else block
          jmp end

if2:      mov [smallest],dx ; else's if block
          jmp end

if1:      mov [smallest],ax ; if's if block
          jmp end

end:      mov ax,0x4c00
          int 0x21
p :       dw 42
q:        dw 18
r:        dw 30
smallest: dw 0