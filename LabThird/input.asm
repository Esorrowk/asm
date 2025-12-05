section .bss
    input_buffer resb 16

section .data
    global input_signed

section .text
;========================================
; Функция для ввода знакового числа
; Выход: AX = число (-32768..32767)
; CF = 0 если успех, CF = 1 если ошибка
input_signed:
    push esi
    push edi
    push ebx
    push ecx
    push edx
    
    ; Чтение строки
    mov eax, 3              ; sys_read
    mov ebx, 0              ; stdin
    mov ecx, input_buffer
    mov edx, 15
    int 0x80
    
    cmp eax, 1
    jb .error
    
    ; Преобразование строки в число
    mov esi, input_buffer
    xor edx, edx            ; Накопленное число
    xor ecx, ecx            ; Счетчик позиции
    xor ebx, ebx            ; Текущий символ
    xor edi, edi            ; Флаг знака (0=+, 1=-)
    
    ; Проверка первого символа
    mov bl, byte [esi]
    cmp bl, '-'
    jne .check_plus
    mov edi, 1              ; Устанавливаем флаг отрицательности
    inc ecx
    jmp .convert_loop

.check_plus:
    cmp bl, '+'
    jne .convert_loop
    inc ecx                 ; Пропускаем символ плюса

.convert_loop:
    mov bl, byte [esi + ecx]
    
    cmp bl, 10              ; LF
    je .done
    cmp bl, 13              ; CR
    je .done
    cmp bl, 0               ; нуль-терминатор
    je .done
    
    ; Проверка, что символ - цифра
    cmp bl, '0'
    jb .error
    cmp bl, '9'
    ja .error
    
    ; Преобразование цифры
    sub bl, '0'
    
    ; Умножение текущего результата на 10
    mov eax, edx
    mov edx, 10
    imul edx
    jo .error
    
    mov edx, eax
    
    ; Добавление новой цифры
    movsx eax, bl
    add edx, eax
    jo .error
    
    inc ecx
    cmp ecx, 6              ; Максимум 6 символов
    jae .error
    jmp .convert_loop

.done:
    ; Проверка, что ввели хотя бы одну цифру
    cmp ecx, edi
    je .error
    
    ; Проверка диапазона для 16-битного знакового числа
    test edi, edi
    jz .positive_number
    
    ; Отрицательное число
    cmp edx, 32768
    ja .error
    neg edx
    jmp .check_range

.positive_number:
    cmp edx, 32767
    ja .error

.check_range:
    mov ax, dx
    clc                     ; Успех
    jmp .exit

.error:
    stc                     ; Ошибка

.exit:
    pop edx
    pop ecx
    pop ebx
    pop edi
    pop esi
    ret
