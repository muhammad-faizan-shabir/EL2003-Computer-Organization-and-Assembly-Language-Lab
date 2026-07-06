mov [02], [ 22]  ; memory to memory operation not allowed
; correction
; mov ax,[22]
; mov [02],ax

mov [wordvar], 20  ; it is not defined whether to treat 20 as a byte or as a word
;correction
; mov word[wordvar], 20

mov bx, al ; size of registers do not match
;correction
;mov bl,al

mov ax, [si+di+100] ; si+di is not allowed to access a memory
correction;
;add di,si
;mov ax,[di+100]