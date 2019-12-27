MEMORY_SIZE equ 1000
STACK_SIZE equ 1000
CODE_SIZE equ 1000

section .data
    var_str_title   db      'BrainF**k VM Writern by Nasm x64', 0
    var_str_0       db      'Hello! Welecome to bf_asm vm.', 10,  0
    var_str_1       db      'Your bf code is: ', 0
    var_str_2       db      10, '--------------start--------------', 0
    var_str_3       db          '--------------stop---------------', 0
    var_str_4       db      'Finished!', 0
    var_str_5       db      'Please input corret argvs.', 0
    var_test        db      'test.bf', 0
    code            db      '++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.', 0
    ;code            db      '++++++[>+++++[>+++<-]<-]>>.', 0
    ;code            resb    CODE_SIZE
    memory          resb    MEMORY_SIZE ;The vm memory
    stack           resd    STACK_SIZE ; 
    code_index      dd 0
    mery_index      dd 0
    stck_index      dd 0
    file_point      dd 0, 0
    f_read_sign         db 'r' , 0
    printf_format_d     db '%d'
    printf_format_c     db '%c'
    printf_format_s     db '%s'
    printf_format_s_CR  db '%s', 10

section .text

extern printf
extern puts
extern getchar
extern putchar
extern MessageBoxA
extern fopen
extern fgets
global  main

main: 
    push rbp
    mov rbp, rsp
    sub rsp, 48             ; x64 shadow stack

        cmp ecx, 1
        je buqdsh
            mov rcx, var_str_5
            call puts
            jmp main_sub_end
        buqdsh:

        ; call init_code
        call init_hello     ; print_hello
        call init_memory    ; initilize memory
        call init_stack     ; initilize stack

        call prase          ; start prase


        mov rcx, var_str_3  ; print_stop_divider
        call puts

        mov ecx, 0          ; show_messagebox
        mov rdx, var_str_4
        mov r8, var_str_title
        mov r9d, 0
        call MessageBoxA
    
        main_sub_end:

    add rsp, 48
    pop rbp
mov rax, 10 ; return 10
ret 
main_end: 

init_hello:
    push rbp
    mov rbp, rsp
    sub rsp, 48
        push rcx
            mov rcx, var_str_0  ; print_hello
            call puts

            mov rcx, var_str_1
            call puts

            mov rcx, code
            call puts

            mov rcx, var_str_2
            call puts
        pop rcx
    add rsp, 48
    pop rbp
ret

init_memory:                    ; initilize memory - fill memory with 0
    push rax
        mov DWORD eax, MEMORY_SIZE
        dec eax
        nbl5ze:
            cmp eax, 0
            je nbl5ze_end
                mov BYTE [-1 + rax + memory], 0
                dec eax
            jmp nbl5ze
        nbl5ze_end:
    pop rax
ret

init_stack:                     ; initilize stack - fill stack with 0
    push rax
        mov DWORD eax, STACK_SIZE
        dec eax
        bot40v:
            cmp eax, 0
            je bot40v_end
                mov BYTE [-1 + rax + stack], 40
                dec eax
            jmp bot40v
        bot40v_end:
    pop rax
ret

init_code:
;TODO
    push rbp
    mov rbp, rsp
    sub rsp, 1056
        push rax
        push rcx
        push rdx
            mov rax, rdx
            add rax, 8
            mov QWORD rax, [rax] ; rax <- argv[1]


            mov rax, var_test
            mov rdi, rax
            mov rsi, f_read_sign
            call fopen


            ; mov rdx, f_read_sign
            ; mov rcx, rax
            ; call fopen  ; rax <- fopen(rax, "r");


            ; mov rdx, rax
            ; mov r8, rdx
            ; mov rax, code
            ; mov edx, CODE_SIZE
            ; mov rcx, code
            ; call fgets


            ; mov rcx, code
            ; call puts

        pop rdx
        pop rcx
        pop rax
    add rsp, 1056
    pop rbp
ret


prase:
    push rbp
    mov rbp, rsp
    sub rsp, 48
        push rax
        push rbx
        start_prase_loop:
            mov DWORD eax, [code_index]
            mov BYTE  bl,  [eax + code]

            cmp bl, '+'
                je uv5u1q
            jmp uv5u1q_end
                    uv5u1q:
                        call incr
                    uv5u1q_end:
            
            cmp bl, '-'
                je fidnke
            jmp fidnke_end
                    fidnke:
                        call decr
                    fidnke_end:
            
            cmp bl, '<'
                je s2oxau
            jmp s2oxau_end
                    s2oxau:
                        call prev
                    s2oxau_end:
            
            cmp bl, '>'
                je yvsvfr
            jmp yvsvfr_end
                    yvsvfr:
                        call next
                    yvsvfr_end:

            cmp bl, ','
                je ruekup
            jmp ruekup_end
                    ruekup:
                        call read
                    ruekup_end:

            cmp bl, 46
                je mestpk
            jmp mestpk_end
                    mestpk:
                        call print
                    mestpk_end:

            cmp bl, '['
                je notvpc
            jmp notvpc_end
                    notvpc:
                        call sloop
                    notvpc_end:

            cmp bl, ']'
                je trxtyo
            jmp trxtyo_end
                    trxtyo:
                        call eloop
                    trxtyo_end:

            cmp bl, 0
                je end_parse_loop
            jmp start_prase_loop

        end_parse_loop:
        pop rbx
        pop rax
    add rsp, 48
    pop rbp
ret




next:                                   ; >
    push rax
        mov DWORD eax, [mery_index]
        inc eax
        mov DWORD [mery_index], eax
        inc DWORD [code_index]
    pop rax
ret

prev:                                   ; <
    push rax
        mov DWORD eax, [mery_index]
        dec eax
        mov DWORD [mery_index], eax
        inc DWORD [code_index]
    pop rax
ret

incr:                                   ; +
    push rax
        mov DWORD eax, [mery_index]
        inc BYTE [eax + memory]
        inc DWORD [code_index]
    pop rax
ret

decr:                                   ; -
    push rax
        mov DWORD eax, [mery_index]
        dec BYTE [eax + memory]
        inc DWORD [code_index]
    pop rax
ret

read:                                   ; ,
    push rbp
    mov rbp, rsp
    sub rsp, 48
        push rax
        push rbx
            mov DWORD ebx, [mery_index]
            call getchar
            mov BYTE [ebx + memory], al
            inc DWORD [code_index]
        pop rbx
        pop rax
    add rsp, 48
    pop rbp
ret

print:                                  ; .
    push rbp
    mov rbp, rsp
    sub rsp, 48
        push rax
        push rcx
            mov DWORD eax, [mery_index]
            mov BYTE ecx, [eax + memory]
            call putchar
            inc DWORD [code_index]
        pop rcx
        pop rax
    add rsp, 48
    pop rbp
ret

sloop:                                  ; [
    push rax
    push rbx
        inc DWORD [code_index]
        inc DWORD [stck_index]
        inc DWORD [stck_index]
        inc DWORD [stck_index]
        inc DWORD [stck_index]
        mov DWORD eax, [stck_index]
        mov DWORD ebx, [code_index]
        mov DWORD [eax + stack], ebx
    pop rbx
    pop rax
ret

eloop:                                   ; ]
    push rax
    push rbx
        mov DWORD eax, [mery_index]
        mov BYTE  bl, [eax + memory]
        cmp bl, 0
        je loop_stop
        jmp loop_continue
            loop_continue:
                mov DWORD eax, [stck_index]
                mov DWORD eax, [eax + stack]
                mov DWORD [code_index], eax
            jmp pjczyt

            loop_stop:
                inc DWORD [code_index]
                dec DWORD [stck_index]
                dec DWORD [stck_index]
                dec DWORD [stck_index]
                dec DWORD [stck_index]
            jmp pjczyt
        pjczyt:
    pop rbx
    pop rax
ret

section .drectve info 
        db      '/defaultlib:user32.lib /defaultlib:msvcrt.lib /defaultlib:legacy_stdio_definitions.lib '