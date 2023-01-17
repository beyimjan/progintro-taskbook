; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

global itostrn

section .text

; dd n, i, *str
;   n -- numeral system
itostrn:	push ebp
		mov ebp, esp
		push esi
		push ebx

		cmp dword [ebp+8], 2
		jb .inv_numeral_system
		cmp dword [ebp+8], 35
		ja .inv_numeral_system

		; starting to push all digits in reverse order!
		xor ecx, ecx			; ECX = 0 -- length
		mov ebx, [ebp+8]		; EBX -- base
		mov eax, [ebp+12]		; EAX = i

		cmp eax, 0			; EAX >= 0?
		jge .digit			;   YES
		neg eax				;   NO: EAX = -EAX

.digit:		xor edx, edx			; EAX =
		div ebx				;   EAX / base

		cmp dl, 9
		ja .letter
		add dl, '0'
		jmp short .push_digit

.letter:	add dl, 'A' - 10

.push_digit:	push edx
		inc ecx				; ECX++
		test eax, eax			; EAX = 0?
		jnz .digit			;   NO! push next digit
						;   YES

		mov esi, [ebp+16]		; ESI = string
						; EAX = 0

		cmp dword [ebp+12], 0		; I >= 0?
		jge .char			; YES
		push dword '-'			; NO
		inc ecx

				; EAX = 0
.char:		pop edx				; pop digit
		mov [esi+eax], dl
		inc eax				; EAX++
		cmp eax, ecx			; all digits?
		jne .char			;   NO
		jmp short .quit			;   YES!

.inv_numeral_system:
		xor eax, eax

.quit:		pop ebx
		pop esi
		mov esp, ebp
		pop ebp
		ret
