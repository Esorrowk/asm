section .text
    global calculate_expression
    extern a, c_val, d

calculate_expression:
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Проверка: если c = 0, то c/4 = 0, но это нормально
    ; Главное проверить знаменатель после вычислений
    
    ; ВЫЧИСЛЕНИЕ ЧИСЛИТЕЛЯ: 3*c + 8 - d
    
    ; 1. 3 * c
    mov ax, [c_val]
    mov bx, 3
    imul bx            ; DX:AX = 3 * c
    jo .overflow_error ; Проверка переполнения при умножении
    
    ; 2. + 8
    add ax, 8
    jo .overflow_error ; Проверка переполнения при сложении
    
    ; 3. - d
    sub ax, [d]
    jo .overflow_error ; Проверка переполнения при вычитании
    
    mov cx, ax        ; Сохраняем числитель в CX
    
    ; ВЫЧИСЛЕНИЕ ЗНАМЕНАТЕЛЯ: a - c/4
    
    ; 1. c / 4 (целочисленное деление со знаком)
    mov ax, [c_val]
    cwd              ; Расширяем AX в DX:AX
    mov bx, 4
    idiv bx          ; AX = c / 4 (частное)
    
    ; 2. a - (c/4)
    mov bx, [a]
    sub bx, ax
    jo .overflow_error ; Проверка переполнения
    
    ; Проверка знаменателя на ноль
    cmp bx, 0
    je .denominator_zero
    
    ; ДЕЛЕНИЕ: числитель / знаменатель
    mov ax, cx       ; Восстанавливаем числитель
    cwd              ; Расширяем AX в DX:AX для деления
    
    ; Проверка деления на -1 (специальный случай для знаковых чисел)
    cmp bx, -1
    jne .normal_division
    
    ; Если знаменатель = -1, проверяем на переполнение при делении на -1
    cmp ax, -32768
    je .overflow_error ; -32768 / -1 = +32768 (переполнение!)
    
.normal_division:
    idiv bx          ; AX = частное, DX = остаток
    
    ; Проверка на переполнение результата
    cmp ax, 32767
    jg .overflow_error
    cmp ax, -32768
    jl .overflow_error
    
    jmp .success

.overflow_error:
    mov ax, 0x8001   ; Код ошибки переполнения
    jmp .exit

.division_by_zero:
    mov ax, 0x8000   ; Код ошибки деления на ноль
    jmp .exit

.denominator_zero:
    mov ax, 0x8002   ; Код ошибки нулевого знаменателя
    jmp .exit

.success:
    ; AX уже содержит результат

.exit:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    ret
