[org 0x0100]
		 jmp start

findPattern: 	 push bp
             	 mov bp,sp
             	 sub sp,2
             	 push ax
             	 push bx
             	 push cx
             	 push dx
             	 push si
             	 push di
             	 
                 mov word[bp+10],-1        ; set return value initially to -1 
             	 mov cx,16
             	 sub cx,[bp+4]
             	 shl word[bp+6],cl         ; shift the pattern to the extreme left
             	 add cx,1
                 mov dx,cx
             	 mov cx,0
             	 mov word[bp-2],0 
             	 mov ax,0x8000
loop2:       	 cmp cx,[bp+4] 		   ; loop to make a mask
             	 je endOfloop2
             	 or word[bp-2],ax
             	 shr ax,1
             	 add cx,1
             	 jmp loop2

endOfloop2:  	 mov cx,0
loop1:       	 cmp cx,dx
             	 je endOfSubroutine
             	 mov ax,[bp+8]
             	 shl ax,cl
             	 and ax,[bp-2]
             	 xor ax,[bp+6]
               	 jz found
             	 add cx,1
             	 jmp loop1

found: 		 mov [bp+10],cx

endOfSubroutine: pop di
	         pop si
		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 mov sp,bp
		 pop bp
 	 	 ret 6

start:  	 sub sp,2
		 mov ax,1101010011011000b ; the number
		 push ax
		 mov ax,11011b   	  ; the pattern
		 push ax
		 mov ax,5 		  ; value of n
		 push ax
		 call findPattern
		 pop ax

		 mov ax,0x4c00
		 int 0x21