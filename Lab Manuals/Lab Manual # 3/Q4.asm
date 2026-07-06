MOV AX, 0XF0F0
AND AX, 0X0F0F
JZ LABEL1      ; jump is taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, 0XF0F0
OR AX, 0XFF0F
JS LABEL1      ; jump is taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX, 0XF2
SUB AX, 0XFA
JNS LABEL1     ; jump not taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV BX, 0XA2
CMP BX, 0XC0
JL LABEL1      ; jump is taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AX,5
CMP AX,6
JL L1          ; jump is taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV DX,0XA523
CMP DX,0XA523
JE L1          ; jump is taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV DX,0XA523
CMP DX,0XA523
JNE L5         ; jump is not taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AL,+127    ; HEXADECIMAL VALUE IS 7FH 
CMP AL,-128    ; HEXADECIMAL VALUE IS 80H
JG ISGREATER   ; jump is taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AL,+127    ; HEXADECIMAL VALUE IS 7FH 
CMP AL,-128    ; HEXADECIMAL VALUE IS 80H
JA ISABOVE     ; jump is not taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AL,+127    ; HEXADECIMAL VALUE IS 7FH 
CMP AL,-128    ; HEXADECIMAL VALUE IS 80H
JNG LABEL      ; jump is not taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV AL,+127    ; HEXADECIMAL VALUE IS 7FH 
CMP AL,-128    ; HEXADECIMAL VALUE IS 80H
JNA LABEL      ; jump is taken
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MOV Ax, 0xFFFF
SUB AX,2 ;
JA LABEL       ; jump is taken
