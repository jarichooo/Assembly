section .data
    input db 'Enter two numbers: ', 0
    input_format db '%d %d', 0
    output_format db 'Addition: %d + %d = %d', 10, 0
    sub_format db 'Subtraction: %d - %d = %d', 10, 0
    mul_fomrat db 'Multiplication: %d * %d = %d', 10, 0 
    div_format db 'Division: %d / %d = %d (remainder: %d) ', 10, 0
    error_msg db 'Error: Division by Zero', 10, 0

section .bss
    num1 resd 1
    num2 resd 1

section .text
    global _main
    extern _scanf
    extern _printf

_main: 
    ; get user input
    push num2
    push num1
    push input_format
    call _scanf
    add esp, 12

    ; Addition
    mov eax, [num1]
    add eax, [num2]
    
    push eax
    push dword [num2]
    push dword [num1]
    push output_format
    call _printf
    add esp, 16

    ; Subtraction
    mov eax, [num1]
    sub eax, [num2]

    push eax
    push dword [num2]
    push dword [num1]
    push sub_format
    call _printf
    add esp, 16


    ; Multiplication
    mov eax, [num1]
    mul dword [num2]

    push eax
    push dword [num2]
    push dword [num1]
    push mul_fomrat
    call _printf
    add esp, 16

    ; Division
    mov eax, [num2]
    cmp eax, 0
    je division_error ; jump if divisor == 0

    mov edx, 0 ; remainder
    mov eax, [num1] ; dividend 
    mov ecx, [num2] ; divisor
    div ecx 

    push edx 
    push ecx
    push dword [num2]
    push dword [num1]
    push div_format
    call _printf
    add esp, 20
    
    jmp division_done

    division_error:
        push error_msg
        call _printf
        add esp, 4

    division_done:
        ret
    
    ret