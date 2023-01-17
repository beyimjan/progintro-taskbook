; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global putstr

section .text

putstr:	; dd *str, length
	mov ecx, [esp+4]
	xor eax, eax

.again:	cmp eax, [esp+8]
	je .quit
	PUTCHAR [ecx+eax]
	inc eax
	jmp short .again

.quit:	ret
