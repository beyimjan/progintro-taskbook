; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:	xor ecx, ecx		; sum of digits
getch:	GETCHAR
	cmp eax, -1
	je break
	cmp al, `\n`
	je break
	cmp al, '0'
	jnae getch
	cmp al, '9'
	jnbe getch
	sub al, '0'
	add ecx, eax
	jmp short getch

break:	jecxz quit
print:	PUTCHAR '*'
	loop print

quit:	FINISH
