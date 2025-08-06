; boot.asm — Stage 1 bootloader
; Assemble: nasm -f bin boot.asm -o boot.bin

BITS 16
ORG 0x7C00

start:
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Load kernel (sectors 2–4 from disk into 0x1000)
    mov bx, 0x1000
    mov dh, 0          ; head
    mov dl, [BOOT_DRIVE]
    mov ch, 0          ; cylinder
    mov cl, 2          ; sector 2
    mov ah, 0x02       ; read sectors
    mov al, 3          ; 3 sectors
    int 0x13

    ; Set up GDT
    lgdt [gdt_descriptor]

    ; Enable protected mode
    mov eax, cr0
    or  eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_pm

; -----------------
; 32-bit section
BITS 32
init_pm:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov esp, 0x90000

    call 0x1000         ; jump to kernel

hang:
    hlt
    jmp hang

; -----------------
; GDT
gdt_start:
    dq 0x0000000000000000     ; null
    dq 0x00CF9A000000FFFF     ; code segment
    dq 0x00CF92000000FFFF     ; data segment
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ 0x08
DATA_SEG equ 0x10

BOOT_DRIVE db 0

times 510 - ($ - $$) db 0
dw 0xAA55
