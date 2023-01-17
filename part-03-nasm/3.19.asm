; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:
main:	xor ecx, ecx		; ECX = 0 = characters count

getch:	GETCHAR
	cmp eax, -1		; if eof
	je res
	inc ecx			; ECX++
	jmp short getch

res:	mov eax, ecx		; starting to push all digits in reverse order
	mov ebx, 10		;   EAX = ECX
	xor ebp, ebp		;   EBP = 0 = digits count
digit:	xor edx, edx
	div ebx
	add dl, '0'
	push edx		; digit pushed
	inc ebp
	test eax, eax
	jnz digit

print:	pop eax
	PUTCHAR al
	dec ebp
	jnz print
	PUTCHAR `\n`
quit:	FINISH
