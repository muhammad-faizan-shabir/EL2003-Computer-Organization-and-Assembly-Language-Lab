[org 0x0100]
              jmp main

oldisr:       dd 0                    ; old isr offset and segment
buffer:       times 2000 dw 0         ; buffer to save video memory

clrscr:       push es                 ; subroutine to clear video screen 
              push ax
              push di
              mov ax, 0xb800
              mov es, ax
              mov di, 0
nextchar:     mov word [es:di], 0x720
              add di, 2
              cmp di, 4000
              jne nextchar
              pop di
              pop ax
              pop es
              ret

store_buffer: push bp                 ; subroutine to store video memory in buffer
              mov bp, sp
              push ax
              push cx
              push si
              push di
              push es
              push ds

              mov ax, 0xb800          
	      mov ds, ax	      ; ds points to video memory segment
	      mov si, 0
	      mov ax, cs
	      mov es, ax              ; es points to buffer segment  
	      mov di, buffer
	      mov cx, 2000

 	      cld
	      rep movsw               ; move data from video memory to buffer

	      pop ds
	      pop es
	      pop di
	      pop si
	      pop cx
	      pop ax
	      pop bp
	      ret

load_buffer:  push bp                 ; subroutine to load buffer data to video memory
              mov bp, sp
              push ax
              push cx
              push si
              push di
              push es
              push ds
 
              mov ax, 0xb800          
              mov es, ax              ; es points to video memory segemnt
              mov di, 0
              mov ax, cs
              mov ds, ax              ; ds points to buffer segment
              mov  si, buffer
              mov  cx, 2000

              cld
              rep movsw               ; load buffer in video memory

              pop ds
              pop es
              pop di
              pop si
              pop cx
              pop ax
              pop bp
              ret

kbISR:        push ax                 ; hook key board interrupt with interrupt chaining

              in al, 0x60             ; read a char from keyboard 
              cmp al, 00011101b       ; press code of ctrl
              JNE nextCmp
              CALL store_buffer        ; store video memory in a buffer
              CALL clrscr              ; clear screen
              jmp  exit

nextCmp:      cmp al, 10011101b        ; release code of ctrl
              JNE noMatch
              CALL load_buffer         ; load buffer in video memory
              jmp exit

noMatch:      pop ax
              jmp far [cs:oldisr]       ; CALL the original ISR

exit:          mov al, 0x20            ; send EOI signal
               out 0x20, al
               pop ax
               iret                    ; return  

main:          xor ax, ax
               mov es, ax

               mov ax, [es:9*4]        ; save old keyboard isr
               mov [oldisr], ax
               mov ax, [es:9*4+2]
               mov [oldisr+2], ax

               cli
               mov word [es:9*4],kbISR ; hook keyboard interrupt
               mov [es:9*4+2], cs
               sti

               mov dx, main            ; to make program TSR
               add dx, 15
               mov cl, 4
               shr dx, cl
               mov ax, 0x3100
               INT 0x21
