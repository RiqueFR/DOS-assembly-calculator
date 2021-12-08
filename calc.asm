segment code
..start:

    ;INICIA OS SEGMENTOS
    mov ax, dados
    mov ds, ax
    mov ax, stack
    mov ss,ax
    mov sp,stacktop

    ;INICIO DOS CODIGOS

    call peganum1
    call imprimenovalinha
    ;mov dx,[num1]
    ;call imprimenumero

    call peganum2
    call imprimenovalinha
    ;mov dx,[num2]
    ;call imprimenumero
    
    call pegaop
    
    ;termina programa
    mov ah,4CH
    int 21h


imprimenovalinha:
    mov dl, 10
    mov ah, 02h
    int 21h
    ret

peganum1:
    mov dx,mensnum1
    mov ah,9
    int 21h
    call leituranum
    mov [num1],dx
    ret

peganum2:
    mov dx,mensnum2
    mov ah,9
    int 21h
    call leituranum
    mov [num2],dx
    ret

pegaop:
    mov dx,mensop
    mov ah,9
    int 21h
    mov ah,01h
    int 21h
    mov [op],al
    ret

leituranum:
    mov cx,0
    mov bx,10
    mov dx,0
    loopleitura:
        mov ax,dx    
        mul bx
        mov dx,ax
        mov ah,01h
        int 21h
        sub al,48
        xor ah,ah
        add dx,ax
        inc cx
        cmp cx,4
        jne loopleitura
    ret

imprimenumero:
; Save the context
    pushf
    push AX
    push BX
    push CX
    push DX

    mov DI,saida
    call bin2ascii

    mov DX,saida
    mov AH,9h
    int 21h         

; Upgrade the context
    pop DX
    pop CX
    pop BX
    pop AX
    popf
    ret

bin2ascii:
    cmp DX,10
    jb  Uni
    cmp DX,100 
    jb  Des
    cmp DX,1000
    jb  Cen
    cmp DX,10000
    jb  Mil
    JMP Dezmil

Uni:
    add DX,0x0030
    mov byte [DI],DL
    ret

Des:
    mov AX,DX
    mov BL,10
    div BL
    add AH,0x30
    add AL,0x30
    mov byte [DI],AL
    mov byte [DI+1],AH
    ret

Cen:
    mov AX,DX
    mov BL,100
    div BL
    add AL,0x30
    mov byte [DI],AL
    mov AL,AH
    and AX,0x00FF
    mov BL,10
    div BL
    add AH,0x30
    add AL,0x30
    mov byte [DI+1],AL  
    mov byte [DI+2],AH
    ret

Mil:
    mov AX,DX
    mov DX,0
    mov BX,1000
    div BX
    add AL,0x30
    mov byte [DI],AL
    mov AX,DX
    mov BL,100
    div BL
    add AL,0x30
    mov byte [DI+1],AL  
    mov AL,AH
    and AX,0x00FF
    mov BL,10
    div BL
    add AH,0x30
    add AL,0x30
    mov byte [DI+2],AL  
    mov byte [DI+3],AH
    ret

Dezmil:
    mov AX,DX
    mov DX,0
    mov BX,10000
    div BX
    add AL,0x30
    mov byte [DI],AL
    mov AX,DX   
    mov DX,0
    mov BX,1000
    div BX
    add AL,0x30
    mov byte [DI+1],AL
    mov AX,DX
    mov BL,100
    div BL
    add AL,0x30
    mov byte [DI+2],AL  
    mov AL,AH
    and AX,0x00FF
    mov BL,10
    div BL
    add AH,0x30
    add AL,0x30
    mov byte [DI+3],AL
    mov byte [DI+4],AH
    ret

segment dados ;segmento de dados inicializados
    num1: dw 0
    num2: dw 0
    op: dw 0
        db 13,10,'$'
    res: dd 0
    mensnum1: db 'Digite o primeiro numero: ','$'
    mensnum2: db 'Digite o segundo numero: ','$'
    mensop: db 'Escolha uma das operacoes (+ - / *): ','$'
    mensres: db 'A resposta da operacao é: ','$'
    saida: resb 5
        db 13,10,'$'

segment stack stack
    resb 256 ; reserva 256 bytes para formar a pilha
stacktop: