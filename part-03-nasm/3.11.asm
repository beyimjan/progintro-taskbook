; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:	xor ecx, ecx		; ECX = 0 (Start value of sum of digits)

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
	add ecx, eax		; ECX += EAX (Add a number to the sum)
	jmp short getch

break:	jecxz quit		; Avoid iterating for value 0
print:	PUTCHAR '*'
	loop print

quit:	FINISH
