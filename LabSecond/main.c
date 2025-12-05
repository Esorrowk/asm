#include <stdio.h>
#include <stdint.h>

int16_t a_sign, b_sign;
uint16_t a_unsign, b_unsign;

int16_t result_sign;
uint16_t result_unsign;

extern void asm_sign();
extern void asm_unsign();

void print_diagram() {
    printf("╭─────────────────╮\n");
    printf("│   Вход: a, b    │\n");
    printf("╰─────────────────╯\n");
    printf("        │\n");
    printf("        ├─ a < b ────> (a*b)/4\n");
    printf("        │\n");
    printf("        ├─ a > b ────> (a+2)/b\n");
    printf("        │\n");
    printf("        └─ a = b ────> 21\n\n");
}

int calc_sign(int16_t a, int16_t b) {
    if (a > b) {
        return (a + 2) / b;
    } else if (a == b) {
        return 21;
    } else {
        return (a * b) / 4;
    }
}

int calc_unsign(uint16_t a, uint16_t b) {
    if (a > b) {
        return (a + 2) / b;
    } else if (a == b) {
        return 21;
    } else {
        return (a * b) / 4;
    }
}

int main() {
    print_diagram();
    
    printf("Введите знаковые a и b (-32768 до 32767):\n");
    printf("a-> ");
    scanf("%hd", &a_sign);
    printf("b-> ");
    scanf("%hd", &b_sign);
    
    if (b_sign == 0) {
        printf("Ошибка: b не может быть 0\n");
        return 1;
    }
    
    result_sign = calc_sign(a_sign, b_sign);
    printf("Результат на C: %d  |  ", result_sign);
    
    asm_sign();
    printf("Результат на ASM: %d\n\n", result_sign);
    
    printf("Введите беззнаковые a и b (0 до 65535):\n");
    printf("a-> ");
    scanf("%hu", &a_unsign);
    printf("b-> ");
    scanf("%hu", &b_unsign);

    if (b_unsign == 0) {
        printf("Ошибка: b не может быть 0\n");
        return 1;
    }

    result_unsign = calc_unsign(a_unsign, b_unsign);
    printf("Результат на C: %u   |  ", result_unsign);

    asm_unsign();
    printf("Результат на ASM: %u\n\n", result_unsign);
    
    return 0;
} 
