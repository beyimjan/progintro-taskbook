; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global getistr

section .text

; dd *str, length
;   EAX = characters count
;   ECX = -1: EOF
;   ECX = -2: not enough memory
;   ELSE: CL = last character
getistr:
	mov ecx, [esp+4]
	xor edx, edx		; EDX = 0

.getch:	GETCHAR
	cmp eax, -1
	je .eof

	cmp al, '0'
	jnae .ndgt
	cmp al, '9'
	jnbe .ndgt

	inc edx
	cmp edx, [esp+8]
	jnbe .nmem

	mov [ecx+edx-1], al
	jmp short .getch

.eof:	mov ecx, -1
	jmp short .quit

.nmem:	mov ecx, -2
	jmp short .quit

.ndgt:	mov ecx, eax
	jmp short .quit

.quit:	mov eax, edx
	ret
