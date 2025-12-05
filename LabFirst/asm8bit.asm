section .text
extern a, b, c, d, num1, den1, res1
global func8bit

func8bit:
    MOV AL, byte [c]
    MOV BL, 3
    IMUL BL
    MOV CX, AX
    
    ADD CX, 8
    
    MOV AL, byte [d]
    CBW
    SUB CX, AX
    MOV [num1], CX
    
    MOV AL, byte [c]
    CBW
    MOV BL, 4
    IDIV BL
    MOVSX BX, AL
    
    MOV AL, byte [a]
    CBW
    SUB AX, BX
    MOV [den1], AX
    
    CMP word [den1], 0
    JE division_zero_8
    
    MOV AX, [num1]
    CWD
    IDIV word [den1]
    MOV [res1], AX
    JMP finish_8
    
division_zero_8:
    MOV word [res1], 0
    
finish_8:
    ret
