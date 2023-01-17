; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

global itostr

section .text

itostr:	; dd i, *str
	push ebp
	mov ebp, esp
	push esi
	push ebx

	; starting to push all digits in reverse order!
	xor ecx, ecx			; ECX = 0 -- length
	mov ebx, 10			; EBX = 10 -- divider
	mov eax, [ebp+8]		; EAX = i

.digit:	xor edx, edx			; EAX =
	div ebx				;   EAX / 10
	add dl, '0'			; EDX(num) -> EDX(char)
	push edx			; push digit!
	inc ecx				; ECX++
	test eax, eax			; EAX = 0?
	jnz .digit			;   NO! push next digit
					;   YES

	mov esi, [ebp+12]		; ESI = string
					; EAX = 0

.char:	pop edx				; pop digit
	mov [esi+eax], dl
	inc eax				; EAX++
	cmp eax, ecx			; all digits?
	jne .char			;   NO
					;   YES!

.quit:	pop ebx
	pop esi
	mov esp, ebp
	pop ebp
	ret
