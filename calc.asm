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
    
    push ax
    mov dx, [negativo1]
    cmp dx, 00h
    je pulanum1
    mov ax, [num1]
    xor dx, dx
    mov bx, -1
    mul bx
    mov [num1], ax
    pulanum1:
    mov dx, [negativo2]
    cmp dx, 00h
    je pulanum2
    mov ax, [num2]
    xor dx, dx
    mov bx, -1
    mul bx
    mov [num2], ax
    pulanum2:
    pop ax
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
    mov [resultado],ax
    mov dx,[resultado]
    call imprimemensresultado
    call menorquezero
    call imprimenumero
    jmp termina

subtracao:
    xor ax,ax
    add ax,[num1]
    sub ax,[num2]
    mov [resultado],ax
    mov dx,[resultado]
    call imprimemensresultado
    call menorquezero
    call imprimenumero
    jmp termina

menorquezero:
    mov ax, [resultado]
    cmp ax,0
    jge final
    xor dx, dx
    mov bx, -1
    mul bx
    mov [resultado], ax
    mov dx,'-'
    mov ah,02h
    int 21h
    final:
    ret

multiplicacao:
    mov ax, [num1]
    mov bx, [num2]
    mul bx
    mov [resultado+2], dx
    mov [resultado], ax
    call imprimemensresultado
    call imprimenegativo
    call imprimenumero
    jmp termina

divisao:
    xor dx, dx
    mov ax, [num1]
    mov bx, [num2]
    div bx
    push dx
    mov word [resultado+2], 0h
    mov [resultado], ax
    call imprimemensresultado
    call imprimenegativo
    call imprimenumero
    call imprimenovalinha
    pop dx
    mov [resultado], dx
    call imprimemensresto
    call imprimenumero
    call imprimenovalinha
    jmp termina

imprimenegativo:
    mov ax, [negativo1]
    mov dx, [negativo2]
    cmp ax, dx
    je final2
    mov dx,'-'
    mov ah,02h
    int 21h
    final2:
    ret

imprimemensresultado:
    mov dx,mensres
    mov ah,9
    int 21h
    ret

imprimemensresto:
    mov dx,mensresto
    mov ah,9
    int 21h
    ret

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
    mov dx, [negativomem]
    mov [negativo1], dx
    ret

peganum2:
    mov dx,mensnum2
    mov ah,9
    int 21h
    call leituranum
    mov [num2],dx
    mov dx, [negativomem]
    mov [negativo2], dx
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
    mov word [negativomem], 0h
    loopleitura:
        mov ax,dx
        mul bx
        mov dx,ax
        mov ah,01h
        int 21h
        cmp al,45
        jne continue
        mov word [negativomem], 1h
        jmp loopleitura
        continue:
		cmp al,0Dh
		jne nolinebreak
		mov ax, dx
		xor dx, dx
		div bx
		mov dx, ax
		jmp outloop
		nolinebreak:
        sub al,48
        xor ah,ah
        add dx,ax
        inc cx
        cmp cx,4
        jne loopleitura
	outloop:
    mov ax, [negativomem]
    cmp ax, 0000h
    je continue2
    mov ax, dx
    xor dx, dx
    mov bx, -1
    mul bx
    mov dx, ax
    continue2:
    ret
    
imprimenumero:
    call printloop
    mov byte [saida+8], '$'

    mov DX,saida
    mov AH,9h
    int 21h
    ret

printloop:
    mov cx, 7

    loop1:
        mov bx,10
        mov dx, 0

        mov ax, [resultado+2]
        div bx
        mov [resultado+2], ax

        mov ax, [resultado]
        div bx
        mov [resultado], ax
        
        add dl,30h
        mov bx,cx
        mov [saida+bx],dl

        loop loop1
    ret

segment dados ;segmento de dados inicializados
    negativomem: dw 0
    negativo1: dw 0
    negativo2: dw 0
    num1: dw 0
    num2: dw 0
    ;num1: db 25, 0h
    ;num2: db 4, 0h
    op: dw 0
        db 13,10,'$'
    ;op: dw '/'
    ;    db 13,10,'$'
    resultado: dd 0
    callstore: dw 0
    msg: db 0
        db 13,10,'$'
    num: dw 0
    mensnum1: db 'Digite o primeiro numero: ','$'
    mensnum2: db 'Digite o segundo numero: ','$'
    mensop: db 'Escolha uma das operacoes (+ - / *): ','$'
    mensres: db 'A resposta da operacao eh: ','$'
    mensresto: db 'O resto da divisao eh: ','$'
    saida: resb 9
        db 13,10,'$'

segment stack stack
    resb 256 ; reserva 256 bytes para formar a pilha
stacktop:
