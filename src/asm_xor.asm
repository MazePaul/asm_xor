section .data
    welcome_message db "-- xor encryption software --", 0
    encrypt_prompt db "1 - String to xor?", 0
    rc db 10
    exit_prompt db "2 - Quit the program!", 0
    user_choice db "your choice? ", 0
    encrypt_string_prompt db "Enter a string to encrypt: ", 0
    encrypt_key_prompt db "Enter a key you want to use to encrypt your string: ", 0
    encrypted_string db "Your encrypted string: ", 0

section .bss
    string_to_encrypt resb 256
    key_to_encrypt resb 256
    encrypted_user_string resb 256
    user_choice_value resb 8

section .text
global _start

_start:
    jmp .menu
    ;need to add epilogue at the beginning of the functions to manage stack

.menu:
    push welcome_message        ;push the *address of the buffer* into the stack
    push 29                     ;push the *buffer size* which is the third paramter for .print function
    call .print

    call .return_cariage
    call .return_cariage

    push encrypt_prompt         ;current string that we want to print
    push 18                     ;size of the message (22 Bytes) (iterate for .print functions)
    call .print

    call .return_cariage

    push exit_prompt
    push 21
    call .print

    call .return_cariage

    push user_choice
    push 13
    call .print

    ;set user_choice
    push user_choice_value
    push 2
    call .user_input
    xor rax, rax
    mov rax, [user_choice_value]       ;on mov la valeur de l'input dans rax pur faire le test

    cmp rax, 0x31
    je .encrypt
    jl .menu

    cmp rax, 0x32       ;on regarder si l'utilisateur a rentré '3' pour quitter le programme (51 ascii for int 3)
    je .exit
    jg .menu



.print:
    mov rax, 1          ;set syscall to write_so
    mov rdi, 1          ;file descriptor set to 1 (stdout)

;architecture de la stack: [return_address; buffer_size; strin_to_sprint]
    pop rbp             ;pop la valeur d'addresse de retour, à l'endroit où la fonction a été appelé
    pop rdx             ;pop la taille du buffer
    pop rsi             ;pop la string à print

    push rbp            ;push dans la stack, l'addresse de retour à l'endroit ou la fonction a été appelé
    syscall

    ret

.user_input:
    pop rbp
    pop rdx                     ;retrieve buffer_size
    pop rsi                     ;retrieve buffer

    ;sysread call
    xor rax, rax                ;set syscall rax to 0 (sysread)
    xor rdi, rdi                ;rdi to 0 (file descriptor stdin)
    push rbp
    syscall

    ; Null-terminate the input
    mov byte [rsi+rax], 0               ; place null terminator after the last byte read

    ;In the context of the sys_read system call on Linux (invoked with syscall), the number of bytes read
    ;is returned in the rax register.
    ;rsi contains the address of 'user_input' which is the start of the address
    ;rax contains the number of bits readden, meaning that [rsi+rax] contains the end of the address..
    dec rax
    cmp byte [rsi+rax], 10              ;comparing last character to new line '/n'
    jne .no_newline
    mov byte [rsi+rax], 0               ;if there is a return carriage, replace this character with '0'
    ret

    ;rsi address that contains the start of 'user_input'
    ;rax contains number of bits readden

.no_newline:
    ret

.encrypt:
    xor rax, rax

    call .return_cariage
    call .return_cariage

    ;Ask for the string to encrypt
    push encrypt_string_prompt
    push 27
    call .print

    push string_to_encrypt
    push 256
    call .user_input
    mov r10, rax                ;r10 is the length of r9

    ;Ask for the key that will encrypt the string
    push encrypt_key_prompt
    push 51
    ;push 51
    call .print

    push key_to_encrypt
    push 256
    call .user_input

    ;push parameters into the stack
    push r10        ;user's string length
    push rax        ;user's key length

    ;push rsi and call function
    call .compare_string_length

    xor r10,r10
    xor rax,rax

    mov rax, 60
    syscall
    ;clear registers

    ret

.decrypt:
    xor rax, rax

.compare_string_length:
    ;rbp is the register that stores the return's address
    ;r10 Source string's length
    ;r9 Destination string's length

    ;push rbp


    ;comparing the length of the two strings from user's input (which will be easier for string operations)
    ;basically, xor's calculation will be divided in three parts
    cmp rax, r10
    je .xor_equal_length
    jl .xor_string_sub_to_key
    jg .xor_string_greater_to_key

.xor_equal_length:
    xor rax, rax                        ;rax will store source current byte
    xor rbx, rbx                        ;rbx will store destination current byte
    xor rdx, rdx

    lea rsi, [string_to_encrypt]
    lea rdi, [key_to_encrypt]
    lea rdx, [encrypted_user_string]

    mov rcx, r9

    call .loop
    
    push encrypted_user_string
    push 4                     ;technically, both r9,10 or even rcx is equal, but let's stick to rcx by convention
    call .print

.xor_string_sub_to_key:
    ret

.xor_string_greater_to_key:
    ret

.loop:
    mov rax, [rsi]
    mov rbx, [rdi]

    xor al, bl

    mov [rdx], al

    inc rsi
    inc rdi
    inc rdx

    cmp rax, 0x0
    jne .loop
    ret

.return_cariage:
    push rc
    push 1
    call .print

    ret


.exit:
    xor rax, rax    ;quickly set rax to 0
    mov rax, 60     ;syscall for exit

    syscall
