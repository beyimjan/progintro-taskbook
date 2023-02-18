; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .data
pcount	dw 0
mcount	dw 0

section .text
_start:
getch:	GETCHAR			; Input section started
	cmp eax, -1		; Cycle conditions
	je count
	cmp al, `\n`
	je count

plus:	cmp al, '+'		;   If statement N1 in the cycle
	jne minus
	inc dword [pcount]
	jmp short getch
minus:	cmp al, '-'		;   If statement N2 in the cycle
	jne other
	inc dword [mcount]
other:	jmp short getch

count:	mov ax, [pcount]
	mul dword [mcount]
	mov cx, dx
	shl cx, 8
	mov cx, ax		; Input section ended

	jecxz quit
print:	PUTCHAR '*'
	loop print
quit:	FINISH
