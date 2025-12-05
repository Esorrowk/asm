#include <stdio.h>
#include <stdint.h>

// 8-битные переменные
int8_t a, b, c, d;
int16_t num1, den1, res1;

// 16-битные переменные
uint16_t a_2, b_2, c_2, d_2;
int64_t num3, den4, res2;

extern void func8bit();
extern void func16bit();

// Функция для вычисления на си 8 бит
void c_calculate_8bit(int8_t a, int8_t b, int8_t c, int8_t d) {
    int16_t num, den, res; 
    printf("debug: a=%d, b=%d, c=%d, d=%d\n", a, b, c, d);
    
    num = (3 * c + 8 - d);
    
    if (c % 4 != 0) {
        printf("Warning: c/4 will be truncated (c=%d, c/4=%d)\n", c, c/4);
    }
    den = (a - c / 4);
    
    if (den != 0) {
        res = num / den;
    } else {
        printf("Divide by 0 error! Denominator is zero.\n");
        res = 0;
    }

    printf("Numerator is %d\n", num);
    printf("Denominator is %d\n", den);
    printf("Result is %d\n\n", res);
}

// Функция для вычисления на си 16 бит
void c_calculate_16bit(uint16_t a, uint16_t b, uint16_t c, uint16_t d) {
    int64_t num, den, res; 
    printf("debug: a=%u, b=%u, c=%u, d=%u\n", a, b, c, d);
    
    // Новая формула: (3*c + 8 - d) / (a - c/4)
    num = (3 * (int64_t)c + 8 - (int64_t)d);
    
    if (c % 4 != 0) {
        printf("Warning: c/4 will be truncated (c=%u, c/4=%u)\n", c, c/4);
    }
    den = ((int64_t)a - (int64_t)c / 4);
    
    if (den != 0) {
        res = num / den;
    } else {
        printf("Divide by 0 error! Denominator is zero.\n");
        res = 0;
    }

    printf("Numerator is %lld\n", num);
    printf("Denominator is %lld\n", den);
    printf("Result is %lld\n\n", res);
}

void print_formula() {
    printf("╭─────────────────────────────────╮\n");
    printf("│        (3 × c + 8 - d)          │\n");
    printf("│      ────────────────────       │\n");
    printf("│        (a - c ÷ 4)              │\n");
    printf("╰─────────────────────────────────╯\n");
}

int main() {
    print_formula();

    printf("Enter the values for 8-bit (signed char from -128 to 127):\n");
    printf("a = ");
    scanf("%hhd", &a);
    printf("b = ");
    scanf("%hhd", &b);
    printf("c = ");
    scanf("%hhd", &c);
    printf("d = ");
    scanf("%hhd", &d);

    // Вычисления на Си (8-бит)
    printf("\nCalculation on C 8-bit (signed char)\n");
    c_calculate_8bit(a, b, c, d);

    func8bit();
    printf("\nCalculation on ASM 8-bit (signed char)\n");
    printf("num=%d\nden=%d\nres=%d\n\n", num1, den1, res1);

    printf("\nEnter the values for 16-bit (unsigned short from 0 to 65535):\n");
    printf("a = ");
    scanf("%hu", &a_2);
    printf("b = ");
    scanf("%hu", &b_2);
    printf("c = ");
    scanf("%hu", &c_2);
    printf("d = ");
    scanf("%hu", &d_2);

    // Вычисления на Си (16-бит)
    printf("\nCalculation on C 16-bit (unsigned short)\n");
    c_calculate_16bit(a_2, b_2, c_2, d_2);


    func16bit();
    printf("\nCalculation on ASM 16-bit (unsigned int)\n");
    printf("num=%lld\nden=%lld\nres=%lld\n\n", num3, den4, res2);

    return 0;
}
