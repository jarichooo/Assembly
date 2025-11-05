; ==================================================================================================
; SECTION: DATA (Static String Literals and Constant Data)
; ==================================================================================================
section .data

    ; Menu display
    menu db '==== MULTI-FUNCTION NUMBER CALCULATOR by Joshua Jericho D. Barja ====', 10, \
    '[0] Exit', 10, \
    '[1] LCM', 10, \
    '[2] GCF', 10, \
    '[3] Factors', 10, \
    '[4] Multiples', 10, \
    '[5] Prime Factorization', 10, 0

    option db 'Enter choice: ', 0                   ; Prompt for menu choice
    option_format db '%d', 0                        ; Format string for scanf (integer)
    exit_msg db 'Thank you!', 0                     ; Exit message

    ; User input prompts
    nums db 'Enter the 3 two-digit numbers (separated by space): ', 0
    nums_format db '%d %d %d', 0                    ; scanf format for three integers

    error_msg db 'Inputs should only be between 1 to 99. Please enter your valid inputs.', 10, 0

    ; Operation headers and format strings
    lcm_header db '==== LCM ====', 10, 0
    lcm_msg db 'LCM: %d', 10, 0

    gcf_header db '==== GCF ====', 10, 0
    gcf_msg db 'GCF: %d', 10, 0

    factors_header db '==== FACTORS ====',10,0
    factors_label db 'Factors of %d: ',0
    factor_value db '%d ',0

    multiples_header db '==== MULTIPLES ====', 10, 0
    multiples_label db 'Multiples of %d: ', 0
    multiples_value db '%d ', 0

    prime_factors_header db '==== PRIME FACTORIZATION ====', 10, 0
    prime_factors_label db 'Prime factors of %d: ', 0
    prime_factors_separator db ' x ', 0             ; Separator between prime factors

    newline db 10,0                                 ; Newline character

    loop_back_msg db 'The entered choice is not on the menu. Please enter a valid choice.', 10, 0


; ==================================================================================================
; SECTION: BSS (Uninitialized Variables)
; ==================================================================================================
section .bss

    option_var resd 1       ; Stores user's chosen menu option
    num1 resd 1             ; First input number
    num2 resd 1             ; Second input number
    num3 resd 1             ; Third input number


; ==================================================================================================
; SECTION: TEXT (Code Instructions)
; ==================================================================================================
section .text
    global _main
    extern _printf
    extern _scanf

_main:
; ==================================================================================================
; ENTRY POINT / MAIN MENU LOOP
; ==================================================================================================
menu_loop:
    ; Print the main menu text
    push menu
    call _printf
    add esp, 4

    ; Ask user to enter a menu option
    push option
    call _printf
    add esp, 4

    ; Read the user input (integer choice)
    push option_var
    push option_format
    call _scanf
    add esp, 8

    ; Load inputted option value into EAX for comparison
    mov eax, [option_var]

    ; 0 → Exit
    cmp eax, 0
    je exit_loop

    ; 1 → LCM
    cmp eax, 1
    je lcm

    ; 2 → GCF
    cmp eax, 2
    je gcf

    ; 3 → Factors
    cmp eax, 3
    je factors

    ; 4 → Multiples
    cmp eax, 4
    je multiples

    ; 5 → Prime Factorization
    cmp eax, 5
    je prime_factorization

    ; Invalid choice → re-prompt
    push loop_back_msg
    call _printf
    add esp, 4
    jg menu_loop


; ==================================================================================================
; FUNCTION: three_num
; Prompts user for 3 valid two-digit integers and validates them.
; ==================================================================================================
three_num:
    ; Display input prompt
    push nums
    call _printf
    add esp, 4

    ; Read three integer inputs into num1, num2, num3
    push num3
    push num2
    push num1
    push nums_format
    call _scanf
    add esp, 16

    ; Validate num1
    mov eax, [num1]
    call check_num
    test eax, eax
    jnz input_error

    ; Validate num2
    mov eax, [num2]
    call check_num
    test eax, eax
    jnz input_error

    ; Validate num3
    mov eax, [num3]
    call check_num
    test eax, eax
    jnz input_error

    ret


; ==================================================================================================
; FUNCTION: check_num
; Checks if number in EAX is between 1 and 99.
; Returns:
;   EAX = 0 if valid
;   EAX = 1 if invalid
; ==================================================================================================
check_num:
    cmp eax, 1
    jl invalid_num
    cmp eax, 99
    jg invalid_num
    mov eax, 0
    ret

invalid_num:
    mov eax, 1
    ret


; ==================================================================================================
; FUNCTION: gcd
; Compute the Greatest Common Divisor using Euclidean Algorithm.
; Input:  eax = a, ebx = b
; Output: eax = gcd(a, b)
; ==================================================================================================
gcd:
    mov edx, 0
    cmp ebx, 0
    je .done
.loop:
    mov edx, 0
    div ebx          ; eax / ebx → remainder in EDX
    mov eax, ebx
    mov ebx, edx
    cmp ebx, 0
    jne .loop
.done:
    ret


; ==================================================================================================
; FUNCTION: lcm_two
; Compute the Least Common Multiple of two numbers.
; Formula: LCM(a, b) = (a * b) / GCD(a, b)
; Input:  eax = a, ebx = b
; Output: eax = LCM(a, b)
; ==================================================================================================
lcm_two:
    push eax         ; save 'a'
    push ebx         ; save 'b'

    mov eax, [esp+4] ; a
    mov ebx, [esp]   ; b
    call gcd         ; get gcd(a, b)
    mov ecx, eax     ; store gcd in ECX

    pop ebx          ; restore b
    pop eax          ; restore a

    imul eax, ebx    ; eax = a * b
    cdq
    idiv ecx         ; eax = (a*b)/gcd
    ret


; ==================================================================================================
; FUNCTION: lcm
; Handles 3-number LCM operation
; ==================================================================================================
lcm:
    ; Display header
    push lcm_header 
    call _printf
    add esp, 4

    ; Get input numbers
    call three_num

    ; Compute LCM of num1 and num2
    mov eax, [num1]
    mov ebx, [num2]
    call lcm_two     ; eax = lcm(num1, num2)

    ; Compute LCM of previous result with num3
    mov ebx, [num3]
    call lcm_two     ; eax = lcm(previous_result, num3)

    ; Print result
    push eax
    push lcm_msg
    call _printf
    add esp, 8

    jmp menu_loop


; ==================================================================================================
; FUNCTION: gcf
; Handles 3-number GCF (Greatest Common Factor)
; ==================================================================================================
gcf:
    push gcf_header
    call _printf
    add esp, 4

    call three_num

    ; Compute GCD of first two numbers
    mov eax, [num1]
    mov ebx, [num2]
    call gcd

    ; Compute GCD with third number
    mov ebx, [num3]
    call gcd

    ; Print result
    push eax
    push gcf_msg
    call _printf
    add esp, 8

    jmp menu_loop


; ==================================================================================================
; FUNCTION: factors
; Displays all factors for three input numbers.
; ==================================================================================================
factors:
    push factors_header
    call _printf
    add esp, 4

    call three_num

    ; Factors for num1
    mov eax, [num1]
    push eax
    push factors_label
    call _printf
    add esp, 8

    push dword [num1]
    call print_factors
    add esp, 4

    ; Factors for num2
    mov eax, [num2]
    push eax
    push factors_label
    call _printf
    add esp, 8

    push dword [num2]
    call print_factors
    add esp, 4

    ; Factors for num3
    mov eax, [num3]
    push eax
    push factors_label
    call _printf
    add esp, 8

    push dword [num3]
    call print_factors
    add esp, 4

    jmp menu_loop


; ==================================================================================================
; FUNCTION: print_factors
; Loops through all numbers from 1 → N and prints divisors.
; ==================================================================================================
print_factors:
    push ebp
    mov ebp, esp
    push esi

    mov esi, [ebp+8]     ; original number N
    mov ecx, 1           ; divisor counter = 1

.loop_factors:
    cmp ecx, esi
    jg .done

    mov eax, esi
    mov edx, 0
    div ecx              ; divide N / d

    cmp edx, 0
    jne .next

    ; Factor found → print
    push ecx
    push ecx
    push factor_value
    call _printf
    add esp, 8
    pop ecx

.next:
    inc ecx
    jmp .loop_factors

.done:
    push newline
    call _printf
    add esp, 4
    pop esi
    mov esp, ebp
    pop ebp
    ret


; ==================================================================================================
; FUNCTION: multiples
; Displays 10 multiples of each input number.
; ==================================================================================================
multiples:
    push multiples_header
    call _printf
    add esp, 4

    call three_num

    ; For num1
    mov eax, [num1]
    push eax
    push multiples_label
    call _printf
    add esp, 8

    push dword [num1]
    call print_multiples
    add esp, 4

    ; For num2
    mov eax, [num2]
    push eax
    push multiples_label
    call _printf
    add esp, 8

    push dword [num2]
    call print_multiples
    add esp, 4

    ; For num3
    mov eax, [num3]
    push eax
    push multiples_label
    call _printf
    add esp, 8

    push dword [num3]
    call print_multiples
    add esp, 4

    jmp menu_loop


; ==================================================================================================
; FUNCTION: print_multiples
; Prints the first 10 multiples of a given number.
; ==================================================================================================
print_multiples:
    push ebp
    mov ebp, esp
    push esi
    push ecx

    mov esi, [ebp+8]     ; N
    mov ecx, 1           ; counter i = 1

.loop_multiples:
    cmp ecx, 10
    jg .done

    mov eax, esi
    imul ecx             ; eax = N * i

    push ecx
    push eax
    push multiples_value
    call _printf
    add esp, 8
    pop ecx

    inc ecx
    jmp .loop_multiples

.done:
    push newline
    call _printf
    add esp, 4
    pop ecx
    pop esi
    mov esp, ebp
    pop ebp
    ret


; ==================================================================================================
; FUNCTION: prime_factorization
; Displays the prime factors of all three numbers.
; ==================================================================================================
prime_factorization:
    push prime_factors_header
    call _printf
    add esp, 4

    call three_num

    ; num1
    mov eax, [num1]
    push eax
    push prime_factors_label
    call _printf
    add esp, 8
    push dword [num1]
    call calculate_prime_factors
    add esp, 4

    ; num2
    mov eax, [num2]
    push eax
    push prime_factors_label
    call _printf
    add esp, 8
    push dword [num2]
    call calculate_prime_factors
    add esp, 4

    ; num3
    mov eax, [num3]
    push eax
    push prime_factors_label
    call _printf
    add esp, 8
    push dword [num3]
    call calculate_prime_factors
    add esp, 4

    jmp menu_loop


; ==================================================================================================
; FUNCTION: calculate_prime_factors
; Performs prime factorization using trial division.
; Algorithm:
;   For d = 2 to N:
;       While N % d == 0:
;           Print d
;           N = N / d
; ==================================================================================================
calculate_prime_factors:
    push ebp
    mov ebp, esp
    push esi
    push ebx
    push edi

    mov esi, [ebp+8]     ; N
    mov ebx, 2           ; divisor
    mov edi, 0           ; flag (first factor indicator)

.outer_loop:
    cmp esi, 1
    jle .done

.inner_loop:
    mov eax, esi
    mov edx, 0
    div ebx

    cmp edx, 0
    jne .increment_divisor

    push eax             ; save quotient

    cmp edi, 1
    jne .print_factor_setup

    push ebx
    push prime_factors_separator
    call _printf
    add esp, 4
    pop ebx

.print_factor_setup:
    mov edi, 1

    push ebx
    push factor_value
    call _printf
    add esp, 8

    pop esi              ; restore quotient
    jmp .inner_loop

.increment_divisor:
    inc ebx
    jmp .outer_loop

.done:
    push newline
    call _printf
    add esp, 4

    pop edi
    pop ebx
    pop esi
    mov esp, ebp
    pop ebp
    ret


; ==================================================================================================
; FUNCTION: exit_loop
; Displays exit message and terminates program.
; ==================================================================================================
exit_loop:
    push exit_msg
    call _printf
    add esp, 4
    ret


; ==================================================================================================
; FUNCTION: input_error
; Displays validation error and re-prompts user input.
; ==================================================================================================
input_error:
    push error_msg
    call _printf
    add esp, 4
    jmp three_num
