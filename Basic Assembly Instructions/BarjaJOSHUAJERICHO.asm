section .data
    header_msg db 'This program computes for the average of 3 two-digit numbers (00-55).', 10, 0
    input_1 db 'Enter the first number:', 10, 0
    input_2 db 'Enter the second number:', 10, 0
    input_3 db 'Enter the third number:', 10, 0
    ave_output db 'Average is: %d', 10, 0
    remainder db 'With remainder: %d', 0
    input_format db '%d', 0

section .bss
    num1 resd 1 ; use resd because scanf expects an int*
    num2 resd 1
    num3 resd 1
    rem resd 1

section .text
    global _main
    extern _scanf
    extern _printf

_main:
    push header_msg
    call _printf
    add esp, 4

    ; get user input
    push input_1
    call _printf
    add esp, 4 ; clean up 4 bytes
    push num1
    push input_format
    call _scanf
    add esp, 8

    push input_2
    call _printf
    add esp, 4 ; clean up 4 bytes
    push num2
    push input_format
    call _scanf
    add esp, 8

    push input_3
    call _printf
    add esp, 4 ; clean up 4 bytes
    push num3
    push input_format
    call _scanf
    add esp, 8

    ; compute for the average

    mov eax, [num3]
    add eax, [num2]
    add eax, [num1]
    
    mov edx, 0 ; remainder
    mov ecx, 3 ; divisor
    div ecx ; quotient

    ; move edx value to variable in order to print the actual value
    mov [rem], edx

    ;  average value
    push eax
    push ave_output
    call _printf
    add esp, 8

    ; remainder value
    push dword [rem]
    push remainder
    call _printf
    add esp, 8

    ret