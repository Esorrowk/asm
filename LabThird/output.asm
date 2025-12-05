section .bss
    print_buffer resb 8
    remainder_buf resb 8

section .data
    global print_string, print_signed
    newline db 10, 0

section .text
;========================================
; Вывод строки
; Вход: ESI - указатель на строку
print_string:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    xor edx, edx
.count_loop:
    cmp byte [esi + edx], 0
    je .count_done
    inc edx
    jmp .count_loop

.count_done:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, esi        ; строка
    int 0x80
    
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

;========================================
; Вывод знакового числа
; Вход: AX - число для вывода
print_signed:
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Инициализация буфера
    mov edi, print_buffer
    mov byte [edi], 0
    
    mov cx, ax          ; Сохраняем число
    mov esi, edi
    
    ; Проверка знака
    test cx, cx
    jns .positive
    mov byte [esi], '-'
    inc esi
    neg cx
    jmp .convert

.positive:
    mov byte [esi], ' '
    inc esi

.convert:
    ; Преобразование в строку
    mov ax, cx
    mov bx, 10
    mov ecx, 0          ; Счетчик цифр
    
.digit_loop:
    xor dx, dx
    div bx              ; AX = частное, DX = цифра
    add dl, '0'
    push dx             ; Сохраняем цифру в стек
    inc ecx
    
    test ax, ax
    jnz .digit_loop
    
    ; Извлечение цифр из стека
.pop_digits:
    pop ax
    mov [esi], al
    inc esi
    loop .pop_digits
    
    mov byte [esi], 0   ; Нуль-терминатор
    
    ; Вывод результата
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov ecx, print_buffer
    mov edx, esi
    sub edx, print_buffer
    int 0x80
    
    ; Вывод перевода строки
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
