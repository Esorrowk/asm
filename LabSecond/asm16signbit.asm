section .text
extern a_sign, b_sign
extern result_sign
global asm_sign

asm_sign:
    MOV AX, [a_sign]
    MOV BX, [b_sign]
    CMP AX, BX
    jg bigger
    je equal
    jl smaller

smaller:
    IMUL BX
    MOV BX, 4
    CWD
    IDIV BX
    jmp end

bigger:
    ADD AX, 2
    CWD
    IDIV BX
    jmp end

equal:
    MOV AX, 21
    jmp end

end:
    MOV [result_sign], AX
    ret
