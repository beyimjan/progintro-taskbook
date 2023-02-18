; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:	GETCHAR
	cmp eax, -1
	je eof

	; EAX is filled with one byte in AL
	cmp al, '0'
	jnae invalid_input
	cmp al, '9'
	jnbe invalid_input
	sub al, '0'

	; Prepare for the loop and avoid iterating for value 0
	mov ecx, eax
	jecxz quit

print:	PUTCHAR '*'
	loop print

quit:	FINISH
eof:	FINISH 1
invalid_input:
	FINISH 2
