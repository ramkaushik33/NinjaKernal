; boot/boot.asm
section .text
global _start
_start:
    ; This is where GRUB will start loading the kernel, nothing needs to be done here
    ; Switch to 32-bit protected mode before loading the kernel
    mov eax, 0xCAFEBABE     ; Placeholder code, later GRUB will jump to kernel directly
    hlt                     ; Halt the system
