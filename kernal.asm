; kernel.asm — Stage 2 kernel
; Assemble: nasm -f bin kernel.asm -o kernel.bin

BITS 32
ORG 0x1000

start:
    mov esi, msg
.print_loop:
    lodsb
    test al, al
    jz .done
    mov ah, 0x0E
    mov bh, 0
    mov bl, 7
    int 0x10
    jmp .print_loop
.done:
    hlt
    jmp .done

msg db "Hello from 32-bit protected mode!", 0
