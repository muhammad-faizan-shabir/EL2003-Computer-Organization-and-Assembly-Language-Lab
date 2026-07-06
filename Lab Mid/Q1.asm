[org 0x0100]
                jmp start

decipher:       push bp
                mov bp,sp
                sub sp,10
                push ax
                push bx
                push cx
                push dx
                push si
                push di
                mov word[bp-2],0000000000000000b
                mov word[bp-4],0000000000000010b
                mov word[bp-6],0000000000000100b
                mov word[bp-8],0000000000000110b
                mov ax,[bp+4]
                mov word[bp-10],ax
                mov word[bp+6],ax

step1:          and word[bp-10],0000000000000111b
                xor word[bp-10],0000000000000000b
                jz pattern11
                jmp step2
pattern11:      shr word[bp+6],1
                jmp step5

step2:          mov word[bp-10],ax
                and word[bp-10],0000000000000111b
                xor word[bp-10],0000000000000010b
                jz pattern21
                jmp step3
pattern21:      shl word[bp+6],1
                jmp step5

step3:          mov word[bp-10],ax
                and word[bp-10],0000000000000111b
                xor word[bp-10],0000000000000100b
                jz pattern31
                jmp step4
pattern31:      ror word[bp+6],2
                jmp step5

step4:          mov word[bp-10],ax
                and word[bp-10],0000000000000111b
                xor word[bp-10],0000000000000110b
                jz pattern41
                jmp step5
pattern41:      rol word[bp+6],2
                jmp step5

step5:          mov word[bp-10],ax
                and word[bp-10],0000000000111000b
                xor word[bp-10],0000000000000000b
                jz pattern12
                jmp step6
pattern12:      shr word[bp+6],1
                jmp step9

step6:          mov word[bp-10],ax
                and word[bp-10],0000000000111000b
                xor word[bp-10],0000000000010000b
                jz pattern22
                jmp step7
pattern22:      shl word[bp+6],1
                jmp step9

step7:          mov word[bp-10],ax
                and word[bp-10],0000000000111000b
                xor word[bp-10],0000000000100000b
                jz pattern32
                jmp step8
pattern32:      ror word[bp+6],2
                jmp step9

step8:           mov word[bp-10],ax
                 and word[bp-10],0000000000111000b
                 xor word[bp-10],0010000000110000b
                 jz pattern42
                 jmp step9
pattern42:       rol word[bp+6],2
                 jmp step9

step9:           mov word[bp-10],ax
                 and word[bp-10],0000000111000000b
                 xor word[bp-10],0000000000000000b
                 jz pattern13
                 jmp step10
pattern13:       shr word[bp+6],1
                 jmp step13

step10:          mov word[bp-10],ax
                 and word[bp-10],0000000111000000b
                 xor word[bp-10],0000000010000000b
                 jz pattern23
                 jmp step11
pattern23:       shl word[bp+6],1
                 jmp step13

step11:          mov word[bp-10],ax
                 and word[bp-10],0000000111000000b
                 xor word[bp-10],0000000100000000b
                 jz pattern33
                 jmp step12
pattern33:       ror word[bp+6],2
                 jmp step13

step12:          mov word[bp-10],ax
                 and word[bp-10],0000000111000000b
                 xor word[bp-10],0000000110000000b
                 jz pattern43
                 jmp step13
pattern43:       rol word[bp+6],2
                 jmp step13

step13:          mov word[bp-10],ax
                 and word[bp-10],0000111000000000b
                 xor word[bp-10],0000000000000000b
                 jz pattern14
                 jmp step14
pattern14:       shr word[bp+6],1
                 jmp step17

step14:          mov word[bp-10],ax
                 and word[bp-10],0000111000000000b
                 xor word[bp-10],0000010000000000b
                 jz pattern24
                 jmp step15
pattern24:       shl word[bp+6],1
                 jmp step17

step15:          mov word[bp-10],ax
                 and word[bp-10],0000111000000000b
                 xor word[bp-10],0000100000000000b
                 jz pattern34
                 jmp step16
pattern34:       ror word[bp+6],2
                 jmp step17

step16:          mov word[bp-10],ax
                 and word[bp-10],0000111000000000b
                 xor word[bp-10],0000110000000000b
                 jz pattern44
                 jmp step17
pattern44:       rol word[bp+6],2
                 jmp step17

step17:          mov word[bp-10],ax
                 and word[bp-10],0111000000000000b
                 xor word[bp-10],0000000000000000b
                 jz pattern15
                 jmp step18
pattern15:       shr word[bp+6],1
                 jmp endOfSubroutine

step18:          mov word[bp-10],ax
                 and word[bp-10],0111000000000000b
                 xor word[bp-10],0010000000000000b
                 jz pattern25
                 jmp step19
pattern25:       shl word[bp+6],1
                 jmp endOfSubroutine

step19:          mov word[bp-10],ax
                 and word[bp-10],0111000000000000b
                 xor word[bp-10],0100000000000000b
                 jz pattern35
                 jmp step20
pattern35:       ror word[bp+6],2
	         jmp endOfSubroutine

step20: 	 mov word[bp-10],ax
        	 and word[bp-10],0111000000000000b
       	 	 xor word[bp-10],0110000000000000b
       	         jz pattern45
        	 jmp endOfSubroutine
pattern45:	 rol word[bp+6],2
 	         jmp endOfSubroutine

endOfSubroutine: pop di
		 pop si
		 pop dx
		 pop cx
		 pop bx
		 pop ax
		 mov sp,bp 
		 pop bp
		 ret 2

start:           sub sp,2
                 push 0xC5C6    ;push the number to be decrypted
                 call decipher
                 pop ax         ; pop the decrypted number in ax

                 mov ax,0x4c00
                 int 0x21