section .bss
    global a, c_val, d, result
    a       resw 1      ; 16-битные переменные
    c_val   resw 1
    d       resw 1
    result  resw 1

section .data
    ; Сообщения для пользователя
    msg_title       db "Вычисление выражения: (3*c + 8 - d) / (a - c/4)", 10, 10, 0
    msg_input_a     db "Введите a (-32768..32767): ", 0
    msg_input_c     db "Введите c (-32768..32767): ", 0
    msg_input_d     db "Введите d (-32768..32767): ", 0
    msg_result      db "Результат: ", 0
    msg_error       db "Ошибка ввода!", 10, 0
    msg_div_zero    db "Ошибка: деление на ноль!", 10, 0
    msg_overflow    db "Ошибка: переполнение!", 10, 0
    msg_denom_zero  db "Ошибка: знаменатель равен нулю после вычислений!", 10, 0
    msg_remainder   db " (остаток: ", 0
    msg_close       db ")", 10, 0
    
    ; Сообщения для диаграммы
    diagram1 db "╔══════════════════════════════════════╗", 10, 0
    diagram2 db "║  Алгоритм вычисления выражения:      ║", 10, 0
    diagram3 db "║  (3*c + 8 - d) / (a - c/4)           ║", 10, 0
    diagram4 db "╠══════════════════════════════════════╣", 10, 0
    diagram5 db "║  1. Вычислить числитель: 3*c + 8 - d ║", 10, 0
    diagram6 db "║  2. Вычислить знаменатель: a - c/4   ║", 10, 0
    diagram7 db "║  3. Разделить числитель на знаменатель║", 10, 0
    diagram8 db "║  4. Проверить деление на ноль        ║", 10, 0
    diagram9 db "╚══════════════════════════════════════╝", 10, 10, 0

section .text
    global _start
    extern input_signed
    extern print_string
    extern print_signed
    extern calculate_expression

_start:
    ; Вывод заголовка и диаграммы
    mov esi, msg_title
    call print_string
    
    mov esi, diagram1
    call print_string
    mov esi, diagram2
    call print_string
    mov esi, diagram3
    call print_string
    mov esi, diagram4
    call print_string
    mov esi, diagram5
    call print_string
    mov esi, diagram6
    call print_string
    mov esi, diagram7
    call print_string
    mov esi, diagram8
    call print_string
    mov esi, diagram9
    call print_string

    ; Ввод переменной a
input_a:
    mov esi, msg_input_a
    call print_string
    call input_signed
    jc input_error
    mov [a], ax
    
    ; Ввод переменной c
input_c:
    mov esi, msg_input_c
    call print_string
    call input_signed
    jc input_error
    mov [c_val], ax
    
    ; Ввод переменной d
input_d:
    mov esi, msg_input_d
    call print_string
    call input_signed
    jc input_error
    mov [d], ax
    
    ; Вычисление выражения
    call calculate_expression
    
    ; Проверка результата
    cmp ax, 0x8000          ; Код ошибки деления на ноль
    je division_error
    cmp ax, 0x8001          ; Код ошибки переполнения
    je overflow_error
    cmp ax, 0x8002          ; Код ошибки нулевого знаменателя
    je denominator_zero
    
    ; Сохранение результата
    mov [result], ax
    
    ; Вывод результата
    mov esi, msg_result
    call print_string
    
    mov ax, [result]
    call print_signed
    
    ; Завершение программы
    jmp exit_program

input_error:
    mov esi, msg_error
    call print_string
    jmp exit_program

division_error:
    mov esi, msg_div_zero
    call print_string
    jmp exit_program

overflow_error:
    mov esi, msg_overflow
    call print_string
    jmp exit_program

denominator_zero:
    mov esi, msg_denom_zero
    call print_string
    jmp exit_program

exit_program:
    ; Выход из программы
    mov eax, 1      ; номер системного вызова exit
    xor ebx, ebx    ; код возврата 0
    int 0x80
