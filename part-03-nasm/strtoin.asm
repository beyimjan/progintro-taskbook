; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

global strtoin

section .bss
negative	resd 1

section .text

; dd n, *str, length
;   n -- numeral system
;
;   ECX = 0  -- success
;     EAX -- result
;   ECX = 1  -- invalid numeral system <= 1, > 36
;   ECX = 2  -- invalid string
;     EAX -- error index
strtoin:
	push ebp
	mov ebp, esp
	push ebx
	push esi

	cmp dword [ebp+8], 2
	jb .inv_numeral_system
	cmp dword [ebp+8], 36
	ja .inv_numeral_system

	xor ecx, ecx			; ECX = 0 -- index

	cmp dword [ebp+16], 0		; length = 0?
	jne .nzl			;   NO!
	jmp short .error		;     YES

.nzl:	xor eax, eax			; EAX = 0 -- result

	mov esi, [ebp+12]		; ESI = string
	xor ebx, ebx			; EBX = 0

	mov dword [negative], 0

	cmp byte [esi], '+'
	je .skip_sign

	cmp byte [esi], '-'
	jne .again
	mov dword [negative], 1

.skip_sign:
	inc ecx
	cmp ecx, [ebp+16]
	jae .error

.again:	mov bl, [esi+ecx]		; BL = current character

	cmp bl, '0'
	jnae .error
	cmp bl, '9'
	jnbe .is_letter
	sub bl, '0'
	jmp short .char_check

.is_letter:
	cmp bl, 'A'
	jnae .error
	cmp bl, 'Z'
	jnbe .error
	sub bl, 'A' - 10

.char_check:
	mov dl, [ebp+8]
	dec dl
	cmp bl, dl
	jnbe .error

.continue:
	mul dword [ebp+8]		; EAX = EAX * base
	add eax, ebx			;   + EBX

	inc ecx				; ECX++
	cmp ecx, [ebp+16]
	jb .again

	cmp dword [negative], 0
	je .success

.negative:
	neg eax

.success:
	xor ecx, ecx			; ECX = 0 -- success
	jmp short .quit

.inv_numeral_system:
	mov ecx, 1
	jmp short .quit

.error:	mov eax, ecx
	mov ecx, 2

.quit:	pop esi
	pop ebx
	mov esp, ebp
	pop ebp
	ret
