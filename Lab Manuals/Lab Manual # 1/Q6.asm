[org 0x0100]
       mov bx,Fib     ; moving address Fib in bx
       mov word[bx],0 ; moving 0 at first index
       add bx,2       ; move to next index
       mov word[bx],1 ; moving 1 to second index
       add bx,2       ; move to next index
       
       mov cx,8       ; initialize cx with 8
start: mov ax,0       ; initialize ax with 0
       mov dx,[bx-4]  ; move data from second last index from current index
       add ax,dx      ; add data from second last index from current index to ax
       mov dx,[bx-2]  ; move data from last index from current index
       add ax,dx      ; add data from last index from current index to ax
       mov [bx],ax    ; move generated term to current index using indirect addressing
       add bx,2       ; move to next index
       sub cx,1       ; update counter
       jnz start      ; jump to start of loop based on condition
       
       mov ax,0x4c00 
       int 0x21
Fib:   dw 0,0,0,0,0,0,0,0,0,0