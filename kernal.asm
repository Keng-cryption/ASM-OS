BITS 32
ORG 0x1000

start:
    ; Print CPU cores count (using CPUID leaf 1)
    mov eax, 1
    cpuid
    mov bl, bh               ; EBX bits 23-16 = logical processor count
    shr ebx, 16
    and ebx, 0xFF
    ; BL now holds logical processor count
    ; Convert BL to ascii and print below

    ; Print CPU cores count
    mov esi, cpu_msg
    call print_string
    mov al, bl
    call print_num
    call print_newline

    ; Print memory info using BIOS int 15 E820 (must switch back to real mode or vm86)
    ; This is complicated in protected mode — typically done in real mode or with BIOS calls early on.

    ; For demo, just print placeholder
    mov esi, mem_msg
    call print_string
    mov esi, mem_size_msg
    call print_string

    ; Halt
.halt:
    hlt
    jmp .halt

; --------------------
; Print string pointed by ESI, zero terminated
print_string:
    .print_char:
        lodsb
        test al, al
        jz .done
        mov ah, 0x0E
        mov bh, 0
        mov bl, 7
        int 0x10
        jmp .print_char
    .done:
        ret

; Print number in AL as decimal
print_num:
    push ax
    push bx
    push cx
    push dx

    mov cx, 0
    mov bx, 10

    mov bl, 10
    xor cx, cx

    mov ah, 0
    mov bx, 10

    mov dx, 0

    mov ax, 0
    mov al, al

    ; Simple convert al to decimal digit characters
    ; Assuming single digit (for demo)
    add al, '0'
    mov ah, 0x0E
    mov bh, 0
    mov bl, 7
    int 0x10

    pop dx
    pop cx
    pop bx
    pop ax
    ret

print_newline:
    mov al, 0x0D
    mov ah, 0x0E
    mov bh, 0
    mov bl, 7
    int 0x10

    mov al, 0x0A
    mov ah, 0x0E
    int 0x10
    ret

cpu_msg db "CPU Logical processors: ", 0
mem_msg db "Memory info (placeholder): ", 0
mem_size_msg db "Total memory detection requires real mode BIOS calls", 0
