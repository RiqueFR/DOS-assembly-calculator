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
    call imprimenovalinha
    mov dx,op
    ;mov ah,9
    ;int 21h
    
    mov ax,[op]
    cmp ax,43
    je soma
    cmp ax,45
    je subtracao
    cmp ax,42
    je multiplicacao
    cmp ax,47
    je divisao
    
termina:
    mov ah,4CH
    int 21h

soma:
    xor ax,ax
    add ax,[num1]
    add ax,[num2]
    mov [res],ax
    mov dx,[res]
    call imprimenumero
    jmp termina

subtracao:
    xor ax,ax
    add ax,[num1]
    sub ax,[num2]
    mov [res],ax
    mov dx,[res]
    call imprimenumero
    jmp termina

multiplicacao:
    mov ax, [num1]
    mov bx, [num2]
    mul bx
    mov [res+2], dx
    mov [res], ax
    call imprimenumeromult
    jmp termina

divisao:
    ;div [num1]
    ;ret


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

;storecontext:
;    pushf
;    push AX
;    push BX
;    push CX
;    push DX

;restorecontext:
;    pop DX
;    pop CX
;    pop BX
;    pop AX
;    popf

imprimenumeromult:
    call printloop
    mov byte [saidad+8], '$'

    mov DX,saidad
    mov AH,9h
    int 21h
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
    ;call printloop

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
    mov byte [DI+1],'$'
    ret

Des:
    mov AX,DX
    mov BL,10
    div BL
    add AH,0x30
    add AL,0x30
    mov byte [DI],AL
    mov byte [DI+1],AH
    mov byte [DI+2],'$'
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
    mov byte [DI+3],'$'
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
    mov byte [DI+4],'$'
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

printloop:
    mov cx, 7

    loop1:
        mov bx,10
        mov dx, 0

        mov ax, [res+2]
        div bx
        mov [res+2], ax

        mov ax, [res]
        div bx
        mov [res], ax
        
        add dl,30h
        mov bx,cx
        mov [saidad+bx],dl

        loop loop1
    ret

segment dados ;segmento de dados inicializados
    num1: dw 0
    num2: dw 0
    ;num1: db 210, 04
    ;num2: db 210, 04
    op: dw 0
        db 13,10,'$'
    ;op: dw '*'
    ;    db 13,10,'$'
    res: dd 0
    callstore: dw 0
    msg: db 0
        db 13,10,'$'
    num: dw 0
    mensnum1: db 'Digite o primeiro numero: ','$'
    mensnum2: db 'Digite o segundo numero: ','$'
    mensop: db 'Escolha uma das operacoes (+ - / *): ','$'
    mensres: db 'A resposta da operacao é: ','$'
    saida: resb 5
        db 13,10,'$'
    saidad: resb 9
        db 13,10,'$'

segment stack stack
    resb 256 ; reserva 256 bytes para formar a pilha
stacktop:
