[org 0x0100]
               jmp start

string:        db 'DX'

offsetCalc:    push bp
               mov bp,sp
	       pusha
	       mov ax,[bp+4]
	       mov bl,80
	       mul bl
	       add ax,[bp+6]
	       shl ax,1
	       mov [bp+8],ax
	       popa
	       mov sp,bp
	       pop bp
	       ret 4

check:         push bp
               mov bp,sp
	       sub sp,2
	       pusha
	       mov word[bp-2],0
	       sub sp,2
	       push word[bp+10]
	       push word[bp+8]
	       call offsetCalc
	       pop di
	       mov bx,[bp+6]
	       mov ax,0xb800
	       mov es,ax
	       mov si,0

loop3:         cmp si,[bp+4]
	       jae endOfcheck
	       cmp di,3998
	       ja endOfcheck
	       mov al,[es:di]
	       cmp al,[ds:bx+si]
	       jne endOfcheck
	       add di,2
	       add si,1
	       jmp loop3
	   
endOfcheck:    cmp si,[bp+4]
               jne ResultOfCheck
	       mov word[bp-2],1

ResultOfCheck: mov ax,[bp-2]
               mov [bp+12],ax
	       popa
	       mov sp,bp
	       pop bp
	       ret 8
	   
findString:    push bp
               mov bp,sp
	       sub sp,2
	       pusha 
	       mov word[bp-2],0xFFFF
	       mov di,0

loop1:	       cmp di,25
	       jae endOfloop1
	       mov si,0

loop2:	       cmp si,80
	       jae endOfloop2
	       sub sp,2
	       push si
               push di 
               push word[bp+6]
               push word[bp+4]
	       call check
               pop ax
               cmp ax,1
               jne continue 			
	       mov ax,di
	       mov [bp-1],al
               mov ax,si
	       mov [bp-2],al
	       jmp endOfloop1

continue:      add si,1
	       jmp loop2

endOfloop2:    add di,1
               jmp loop1
			
endOfloop1:    mov ax,[bp-2]
               mov [bp+8],ax
	       popa
	       mov sp,bp
	       pop bp
	       ret 4
			
start:         sub sp,2
               mov ax,string
               push ax
	       mov ax,2
	       push ax
	       call findString
	       pop ax
	       mov ax,0x4c00
	       int 0x21