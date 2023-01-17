; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "procedure.inc"
%include "kernel.inc"

extern strlen

global _start

section .text

ok_str		db `OK\n`
ok_strlen	equ $-ok_str

_start:	cmp dword [esp], 2
	jne .err

	pcall strlen, dword [esp+8]
	test eax, eax
	jz .err

	xor eax, eax			; EAX = 0 -- sum
	mov esi, [esp+8]		; ESI = string
	xor ecx, ecx			; ECX = 0

.again:	cmp byte [esi], 0
	je .break
	cmp byte [esi], '0'
	jnae .err
	cmp byte [esi], '9'
	jnbe .err

	mov cl, [esi]
	sub cl, '0'
	add eax, ecx

	inc esi

	jmp short .again

.break:	xor edx, edx
	mov ecx, 3
	div ecx
	test edx, edx
	jnz .quit
	kernel sys_write, stdout, ok_str, ok_strlen

.quit:	kernel sys_exit, 0

.err:	kernel sys_exit, 1
