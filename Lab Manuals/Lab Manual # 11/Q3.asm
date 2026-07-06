[org 0x0100]
              jmp start

oldisr:       dd 0
oldTimer:     dd 0
flaga:        dw 1
flagb:        dw 0
flagc:        dw 0
flagd:        dw 0
ticks:        dw 0
location:     dw 998

clrscr:       push es
              push ax
	      push di
	      mov ax, 0xb800
	      mov es, ax                      ; point es to video base
	      mov di, 0                       ; point di to top left column
nextloc:      mov word [es:di], 0x0720        ; clear next char on screen
	      add di, 2                       ; move to next screen location
	      cmp di, 4000                    ; has the whole screen cleared
	      jne nextloc                     ; if no clear next position
	      pop di
	      pop ax
	      pop es
              ret

printnum:     push bp
	      mov bp, sp
	      push es
	      push ax
	      push bx
              push cx
              push dx
              push di
              mov ax, 0xb800
              mov es, ax                      ; point es to video base
              mov ax, [bp+4]                  ; load number in ax
              mov bx, 10                      ; use base 10 for division
              mov cx, 0                       ; initialize count of digits
nextdigit:    mov dx, 0                       ; zero upper half of dividend
              div bx                          ; divide by 10
              add dl, 0x30                    ; convert digit into ascii value
              push dx                         ; save ascii value on stack
              inc cx                          ; increment count of values
              cmp ax, 0                       ; is the quotient zero
              jnz nextdigit                   ; if no divide it again
              mov di,[bp+6]
nextpos:      pop dx                          ; remove a digit from the stack
	      mov dh, 0x07                    ; use normal attribute
	      mov [es:di], dx                 ; print char on screen
	      add di, 2                       ; move to next screen location
	      loop nextpos                    ; repeat for all digits on stack
	      pop di
	      pop dx
	      pop cx
	      pop bx
	      pop ax
	      pop es
	      pop bp
	      ret 4

handlea:      pusha
	      push cs
	      pop ds
	      mov word[flagb],0
	      mov word[flagc],0
	      mov word[flagd],0
	      cmp word[flaga],1
	      je endOfhandlea
	      call clrscr
	      mov word[flaga],1
	      mov word[ticks],0
	      mov word[location],998

endOfhandlea: popa
 	      ret

handleb:      pusha
              push cs
              pop ds
              mov word[flaga],0
              mov word[flagc],0
              mov word[flagd],0
              cmp word[flagb],1
              je endOfhandleb
              call clrscr
              mov word[flagb],1
              mov word[ticks],0
              mov word[location],1080

endOfhandleb: popa
              ret

handlec:      pusha
              push cs
              pop ds
	      mov word[flaga],0
	      mov word[flagb],0
	      mov word[flagd],0
	      cmp word[flagc],1
 	      je endOfhandlec
	      call clrscr
	      mov word[flagc],1
	      mov word[ticks],0
	      mov word[location],2758

endOfhandlec: popa
              ret

handled:      pusha 
              push cs
              pop ds
              mov word[flaga],0
              mov word[flagb],0
              mov word[flagc],0
              cmp word[flagd],1
              je endOfhandled
              call clrscr
              mov word[flagd],1
              mov word[ticks],0
              mov word[location],2840

endOfhandled: popa
              ret

kbisr:        pusha
              push cs
	      pop ds
              in al,0x60
              cmp al,0x01
              jne checka
              jmp endOfProgram

checka:       cmp al,0x1E
              jne checkb
	      call handlea
	      jmp nomatch

checkb:       cmp al,0x30
              jne checkc
	      call handleb
	      jmp nomatch

checkc:       cmp al,0x2E
              jne checkd
	      call handlec
	      jmp  nomatch

checkd:       cmp al,0x20
              jne nomatch
              call handled
	      jmp nomatch
		 
nomatch:      popa
              jmp far [cs:oldisr]              ; call the original ISR

endOfProgram: mov al, 0x20
              out 0x20, al
              popa
              add sp,4
              popf

              mov ax,0
	      mov es,ax
	      mov ax,[oldTimer]
	      mov bx,[oldTimer+2]
	      cli 
	      mov [es:8*4],ax
	      mov [es:8*4+2],bx
	      sti
	      mov ax,[oldisr]
	      mov bx,[oldisr+2]
	      cli
	      mov [es:9*4],ax
	      mov [es:9*4+2],bx
	      sti
	      mov ax,0x4c00
	      int 0x21

timer: 	      pusha
	      push cs
	      pop ds
	      inc word [cs:ticks]              ; increment tick count
	      push word[location]
	      push word[cs:ticks]
	      call printnum                    ; print tick count
	      mov al, 0x20
	      out 0x20, al                     ; end of interrupt
	      popa
	      iret

start: 	      call clrscr

	      mov ax,0
	      mov es,ax
	      mov ax,[es:8*4]
	      mov [oldTimer],ax
	      mov ax,[es:8*4+2]
	      mov [oldTimer+2],ax
	      mov ax,[es:9*4]
	      mov [oldisr],ax
	      mov ax,[es:9*4+2]
	      mov [oldisr+2],ax
	      cli
	      mov word[es:8*4],timer
	      mov [es:8*4+2],cs
	      mov word[es:9*4],kbisr
	      mov [es:9*4+2],cs
	      sti
              
              mov dx, start                    ; end of resident portion
	      add dx, 15                       ; round up to next para
	      mov cl, 4
	      shr dx, cl                       ; number of paras
	      mov ax, 0x3100                   ; terminate and stay resident
	      int 0x21



