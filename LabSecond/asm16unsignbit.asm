section .text
extern a_unsign, b_unsign 
extern result_unsign
global asm_unsign

asm_unsign:
    MOV AX, [a_unsign]
    MOV BX, [b_unsign]
    CMP AX, BX
    ja above
    je equal
    jb below

below:
    MUL BX
    MOV BX, 4
    XOR DX, DX
    DIV BX
    jmp end

above:
    ADD AX, 2
    XOR DX, DX
    DIV BX
    jmp end

equal:
    MOV AX, 21
    jmp end

end:
    MOV [result_unsign], AX
    ret
