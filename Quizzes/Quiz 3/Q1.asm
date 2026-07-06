[org 0x0100]
jmp start
oldisr: dd 0
oldtimer: dd 0
offset: dw 0
flag: dw 0
clrscr:          push es                  ; subroutine to clear the screen
                 push ax 
                 push di 
                 mov ax, 0xb800 
                 mov es, ax               ; point es to video base 
                 mov di, 0                ; point di to top left column 

nextloc:         mov word [es:di], 0x0720 ; clear next char on screen 
                 add di, 2                ; move to next screen location 
                 cmp di, 4000             ; has the whole screen cleared 
                 jne nextloc              ; if no clear next position 
                 pop di 
                 pop ax 
                 pop es 
                 ret  



timer: push ax
       push es
       push di 
 ;cmp word[cs:flag],1
 ;je skip
 cmp word[cs:offset],3998
 jna increment
 mov word[cs:offset],0
 jmp skip
increment:
 mov di,[cs:offset]
 add word[cs:offset],2
 mov ax,0xb800
 mov es,ax
 mov word[es:di],0x0720
 mov di,[cs:offset]
 mov word[es:di],0x072A
 skip:mov al, 0x20 
 out 0x20, al ; end of interrupt 
pop di
pop es
 pop ax 
 iret ; return from interrupt 

kbisr: push ax 
 push es 
 mov ax, 0xb800 
 mov es, ax ; point es to video memory 
 in al, 0x60 ; read a char from keyboard port 
 cmp al, 0x1 
 je end ; no, try next comparison 
 cmp al,0x48
 jmp nomatch ; leave interrupt routine 
nextcmp: cmp al, 0x36 ; is the key right shift 
 jne nomatch ; no, leave interrupt routine 
 mov byte [es:0], 'R' ; yes, print R at top left 
nomatch: ; mov al, 0x20 
 ; out 0x20, al 
 pop es 
 pop ax 
 jmp far [cs:oldisr] ; call the original ISR 
 ; iret

start: 
call clrscr
xor ax, ax 
 mov es, ax ; point es to IVT base 
 mov ax, [es:9*4] 
 mov [oldisr], ax ; save offset of old routine 
 mov ax, [es:9*4+2] 
 mov [oldisr+2], ax ; save segment of old routine 
 cli ; disable interrupts 
 mov word [es:9*4], kbisr ; store offset at n*4 
 mov [es:9*4+2], cs ; store segment at n*4+2 
 sti ; enable interrupts 
xor ax, ax 
 mov es, ax ; point es to IVT base
 mov ax,[es:8*4]
 mov [oldtimer],ax
 mov ax,[es:8*4+2]
 mov [oldtimer+2],ax 
 cli ; disable interrupts 
 mov word [es:8*4], timer; store offset at n*4 
 mov [es:8*4+2], cs ; store segment at n*4+2 
 sti
l1: jne l1 ; if no, check for next key 
end:
 mov word[cs:flag],1
 mov ax, [oldisr] ; read old offset in ax 
 mov bx, [oldisr+2] ; read old segment in bx 
 cli ; disable interrupts 
 mov [es:9*4], ax ; restore old offset from ax 
 mov [es:9*4+2], bx ; restore old segment from bx 
 sti
  
 ;mov bx,[cs:oldtimer+2]
 ;mov ax,[cs:oldtimer]
 ;cli
  ;mov cx,0
 ;mov es,cx 
 ;mov [es:8*4],ax
 ;mov [es:8*4+2],bx
 ;sti
mov ax,0x4c00
int 0x21