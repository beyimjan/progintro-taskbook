; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:	GETCHAR
	cmp eax, -1
	je eof
	cmp al, '0'
	jnae ndigit
	cmp al, '9'
	jnbe ndigit
	sub al, '0'
	mov ecx, eax
	jecxz quit
print:	PUTCHAR '*'
	loop print
quit:	FINISH
eof:	FINISH 1
ndigit:	FINISH 2
