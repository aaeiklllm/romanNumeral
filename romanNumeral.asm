.model small
.data

    message_input db 13, 10, "Input number (001-399): ", "$"
    message_roman db 13, 10, "Roman numeral: ", "$"
    message_error db 13, 10, "Please choose a value between 001 and 399", "$"
    newline db 13, 10, "$"
    number dw ?

    input_ones db ? 
    input_tens db ? 
    input_hundreds db ? 
    
    iterator_hundreds db 0
    iterator_tens db 0
    iterator_ones db 0

.stack 100h
.code

main proc near
    mov ax, @data
    mov ds, ax

    ; input prompt
    lea dx, message_input
    mov ah, 09h
    int 21h

    ; getting user input
    mov ah, 01h
    int 21h
    mov input_hundreds, al

    mov ah, 01h
    int 21h
    mov input_tens, al

    mov ah, 01h
    int 21h
    mov input_ones, al

    ; turning to decimal
    sub input_hundreds, 30h
    sub input_tens, 30h
    sub input_ones, 30h

    ; multiplying by tens
    mov al, input_hundreds
    mov bl, 100
    mul bl

    mov number, ax
    xor ax, ax

    mov al, input_tens
    mov bl, 10
    mul bl

    add number, ax
    xor ax, ax

    mov al, input_ones
    add number, ax

    ; three digit number is in variable number

    .if number > 399
        lea dx, message_error
        mov ah, 09h
        int 21h
        jmp @terminate

    .elseif number == 0
        lea dx, message_error
        mov ah, 09h
        int 21h
        jmp @terminate

    .else
        ; output prompt
        lea dx, message_roman
        mov ah, 09h
        int 21h

        @print_hundreds:
        mov bl, iterator_hundreds
        cmp bl, input_hundreds
        je @print_tens
                    
        mov ah, 02h
        mov dl, 'C'
        int 21h
                    
        inc iterator_hundreds
        jmp @print_hundreds

        @print_tens:
        .if input_tens == 9           
            mov ah, 02h
            mov dl, 'X'
            int 21h

            mov ah, 02h
            mov dl, 'C'
            int 21h

        .elseif input_tens >= 5
            mov ah, 02h
            mov dl, 'L'
            int 21h

            sub input_tens, 5
            jmp @print_tens

        .elseif input_tens == 4
            mov ah, 02h
            mov dl, 'X'
            int 21h

            mov ah, 02h
            mov dl, 'L'
            int 21h

        .else
            mov bl, iterator_tens
            cmp bl, input_tens
            je @print_ones
                    
            mov ah, 02h
            mov dl, 'X'
            int 21h
                        
            inc iterator_tens
            jmp @print_tens

        .endif

        @print_ones:
        .if input_ones == 9           
            mov ah, 02h
            mov dl, 'I'
            int 21h

            mov ah, 02h
            mov dl, 'X'
            int 21h

        .elseif input_ones >= 5
            mov ah, 02h
            mov dl, 'V'
            int 21h

            sub input_ones, 5
            jmp @print_ones

        .elseif input_ones == 4
            mov ah, 02h
            mov dl, 'I'
            int 21h

            mov ah, 02h
            mov dl, 'V'
            int 21h

        .else
            mov bl, iterator_ones
            cmp bl, input_ones
            je @terminate
                    
            mov ah, 02h
            mov dl, 'I'
            int 21h
                        
            inc iterator_ones
            jmp @print_ones
        .endif
    .endif


    
         
    ; @print_tens:
    ; .if number >= 90
    ;     mov ax, dx 
    ;     xor dx, dx
    ;     mov bx, 90
    ;     div bx

    ;     xor cx, cx
    ;     mov cx, ax

    ;     jmp @print_XC

    ; .elseif number >= 50
    ;     mov ax, dx 
    ;     xor dx, dx
    ;     mov bx, 50
    ;     div bx

    ;     xor cx, cx
    ;     mov cx, ax

    ;     jmp @print_L

    ; .elseif number >= 40
    ;     mov ax, dx 
    ;     xor dx, dx
    ;     mov bx, 40
    ;     div bx

    ;     xor cx, cx
    ;     mov cx, ax

    ;     jmp @print_XL
        
    ; .elseif number >= 10
    ;     mov ax, dx 
    ;     xor dx, dx
    ;     mov bx, 10
    ;     div bx

    ;     xor cl, cl
    ;     mov cl, al

    ;     jmp @print_X

    ; .else 
    ;     jmp @print_ones
    ; .endif

    ; @print_ones:
    
    ; .if number >= 9

    ;     mov ax, number
    ;     xor dx, dx
    ;     mov bx, 9
    ;     div bx

    ;     xor cl, cl
    ;     mov cl, al

    ;     jmp @print_IX

    ; .elseif number >= 5

    ;     mov ax, number
    ;     xor dx, dx
    ;     mov bx, 5
    ;     div bx

    ;     xor cl, cl
    ;     mov cl, al

    ;     jmp @print_V

    ; .elseif number >= 4
    ;     mov ax, number 
    ;     xor dx, dx
    ;     mov bx, 4
    ;     div bx

    ;     xor cl, cl
    ;     mov cl, al

    ;     jmp @print_IV

    ; .elseif number >= 1
    ;     mov ax, number 
    ;     xor dx, dx
    ;     mov bx, 1
    ;     div bx

    ;     xor cl, cl
    ;     mov cl, al

    ;     jmp @print_I

    ; .else 
    ;     jmp @terminate
    ; .endif

    ; @print_C:
    ; mov number, dx
    ; xor dx, dx
    
    ; mov ah, 02h
    ; mov dl, 67
    ; int 21h
    ; jmp @print_ones

    ; @print_XC:
    ; mov number, dx
    ; xor dx, dx

    ; mov ah, 02h
    ; mov dl, 88
    ; int 21h

    ; mov ah, 02h
    ; mov dl, 67
    ; int 21h
    ; jmp @print_ones

    ; @print_L:
    ; mov number, dx
    ; xor dx, dx
    ; mov ah, 02h
    ; mov dl, 76
    ; int 21h
    ; jmp @print_ones

    ; @print_XL:
    ; mov number, dx
    ; xor dx, dx
    ; mov ah, 02h
    ; mov dl, 88
    ; int 21h

    ; mov ah, 02h
    ; mov dl, 76
    ; int 21h
    ; jmp @print_ones

    ; @print_X:
    ; mov number, dx
    ; xor dx, dx

    ; mov ah, 02h
    ; mov dl, 67
    ; int 21h

    ; loop @print_X
    ; jmp @print_ones

    ; @print_IX:
    ; mov number, dx
    ; xor dx, dx
    ; mov ah, 02h
    ; mov dl, 88
    ; int 21h
    ; loop @print_IX
    ; jmp @print_ones

    ; @print_V:
    ; mov number, dx
    ; xor dx, dx
    ; mov ah, 02h
    ; mov dl, 86
    ; int 21h
    ; loop @print_V
    ; jmp @terminate

    ; @print_IV:
    ; mov number, dx
    ; xor dx, dx
    ; mov ah, 02h
    ; mov dl, 73
    ; int 21h
    
    ; mov ah, 02h
    ; mov dl, 86
    ; int 21h
    ; jmp @terminate

    ; @print_I:
    ; mov number, dx
    ; xor dx, dx
    ; mov ah, 02h
    ; mov dl, 73
    ; int 21h
    ; loop @print_I
    ; jmp @terminate

    @terminate:
    mov ax, 4c00h
    int 21h

        main endp
    end main