[org 0x0100]

mov ax,0x5CAA
mov dx,0x3729
mov cx,0x235A

xor al,dl ; AL=83, DL=29, CL=5A, CF=0, OF=0, SF=1

add dl,dl ; AL=83, DL=52, CL=5A, CF=0, OF=0, SF=0

sub cl,dl ; AL=83, DL=52, CL=08, CF=0, OF=0, SF=0

sar al,cl ; AL=FF, DL=52, CL=08, CF=1, OF=0, SF=1

adc al,dl ; AL=52, DL=52, CL=08, CF=1, OF=0, SF=0

mov ax,0x4c00
int 0x21