[org 0x0100]
                 jmp start

string:          db 'hello'
length:          dw 5

findString: 	 push bp
            	 mov bp,sp
            	 sub sp,2
            	 push ax
            	 push bx
            	 push cx
            	 push dx
            	 push si
           	 push di
            	 mov word[bp+8],-1 ; the return value is initially set to -1 
            	 mov bx,[bp+4]
            	 mov cx,[bx] ; lenght of string in cx
            	 mov [bp-2],cx
            	 mov bx,[bp+6]
            	 mov ax,0xB800
          	 mov es,ax
           	 mov si,0

loop1:    	 cmp si,4000
          	 je endOfSubroutine
          	 mov bx,[bp+6]
          	 mov ax,[es:si]
           	 cmp al,[bx]
          	 je found
           	 add si,2
           	 jmp loop1

found:		 mov [bp+8],si

endOfSubroutine: pop di
                 pop si
		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 mov sp,bp
		 pop bp
		 ret 4

start:           sub sp,2
                 push string
                 push word[length]
                 call findString
                 pop ax ; pop the offset in ax
                 mov ax,0x4c00
                 int 0x21