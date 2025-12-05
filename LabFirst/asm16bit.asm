section .text
extern a_2, b_2, c_2, d_2, num3, den4, res2
global func16bit

func16bit:
    MOVZX EAX, word [c_2]
    MOV EBX, 3
    MUL EBX
    MOV ECX, EAX
    
    ADD ECX, 8
    
    MOVZX EAX, word [d_2]
    SUB ECX, EAX
    MOV [num3], ECX
    
    MOVZX EAX, word [c_2]
    MOV EBX, 4
    XOR EDX, EDX
    DIV EBX
    MOV ESI, EAX
    
    MOVZX EAX, word [a_2]
    SUB EAX, ESI
    MOV [den4], EAX
    
    CMP dword [den4], 0
    JE division_zero_16
    
    MOV EAX, [num3]
    CDQ
    IDIV dword [den4]
    MOV [res2], EAX
    JMP finish_16
    
division_zero_16:
    MOV dword [res2], 0
    
finish_16:
    ret

