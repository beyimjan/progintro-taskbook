; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

global _start

section .text

_start:	mov eax, 1		; EAX = 1: _exit system call

	cmp dword [esp], 4	; argc = 4?
	jne .fail

	xor ebx, ebx		;   YES: EBX = 0
	jmp short .quit

.fail:	mov ebx, 1		;   NO: EBX = 1

.quit:	int 0x80
