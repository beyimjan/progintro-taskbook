; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

global strtoi

section .text

; EAX < 0 -- error: ECX = error index
strtoi: ; dd *str, length
	push ebp
	mov ebp, esp
	push ebx
	push esi

	xor ecx, ecx			; ECX = 0 -- index

	cmp dword [ebp+12], 0		; length = 0?
	jne .nzl			;   NO!
	jmp short .err			;     YES

.nzl:	xor eax, eax			; EAX = 0 -- result

	mov esi, [ebp+8]		; ESI = string
	xor ebx, ebx			; EBX = 0

.again:	mov bl, [esi+ecx]		; BL = current character

	cmp bl, '0'
	jnae .err
	cmp bl, '9'
	jnbe .err

	sub bl, '0'

	mov edx, 10			; EAX =
	mul edx				;   EAX * 10
	add eax, ebx			;   + EBX

	inc ecx				; ECX++
	cmp ecx, [ebp+12]
	jne .again

	jmp short .quit

.err:	mov eax, -1			; ECX = error index

.quit:	pop esi
	pop ebx
	mov esp, ebp
	pop ebp
	ret
