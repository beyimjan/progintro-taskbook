; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .data
pcount	dw 0
mcount	dw 0

section .text
_start:
getch:	GETCHAR
	cmp eax, -1
	je count
	cmp al, `\n`
	je count

plus:	cmp al, '+'
	jne minus
	inc dword [pcount]
	jmp short getch
minus:	cmp al, '-'
	jne other
	inc dword [mcount]
other:	jmp short getch

count:	mov ax, [pcount]
	mul dword [mcount]
	mov cx, dx
	shl cx, 8
	mov cx, ax

	jecxz quit
print:	PUTCHAR '*'
	loop print
quit:	FINISH
