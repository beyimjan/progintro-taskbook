; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:
main:	xor ecx, ecx		; ECX = number read from stdin
	mov ebx, 10		; EBX = 10 = multiplier to get a number

getch:	GETCHAR
	cmp eax, -1
	je star

	cmp al, '0'
	jnae star
	cmp al, '9'
	jnbe star

	sub al, '0'		; add digit to number
	mov ebp, eax		;   save EAX
	mov eax, ecx		;   EAX = ECX
	mul ebx			;   EAX *= 10
	mov ecx, eax		;   ECX = EAX
	mov eax, ebp		;   restore EAX
	add ecx, eax		;   ECX += EAX

	jmp short getch

star:	jecxz quit
print:	PUTCHAR '*'
	loop print
	PUTCHAR `\n`
quit:	FINISH
