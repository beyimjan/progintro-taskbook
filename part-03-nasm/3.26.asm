; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "procedure.inc"
%include "stud_io.inc"

extern getistr
extern strtoi
extern itostr
extern putstr

global _start

section .bss
nsize	equ 10
n1s	resb nsize
n2s	resb nsize

n1	resd 1
n2	resd 1

section .text

_start:
main:	pcall getistr, n1s, nsize
	cmp ecx, -1
	je .err
	cmp ecx, -2
	je .err
	cmp eax, 0
	je .err
	cmp cl, ' '
	jne .err

	pcall strtoi, n1s, eax
	mov dword [n1], eax

	pcall getistr, n2s, nsize
	cmp eax, -1
	je .err
	cmp ecx, -2
	je .err
	cmp eax, 0
	je .err
	cmp cl, `\n`
	jne .err

	pcall strtoi, n2s, eax
	mov dword [n2], eax

	PRINT "+ "
	mov eax, [n1]
	add eax, [n2]
	pcall itostr, eax, n1s
	pcall putstr, n1s, eax
	PUTCHAR `\n`

	PRINT "- "
	mov eax, [n1]
	sub eax, [n2]
	pcall itostr, eax, n1s
	pcall putstr, n1s, eax
	PUTCHAR `\n`

	PRINT "* "
	mov eax, [n1]
	mov edx, [n2]
	mul edx
	pcall itostr, eax, n1s
	pcall putstr, n1s, eax
	PUTCHAR `\n`

	FINISH

.err:	PRINT `Couldn't parse your input!\n`
	FINISH 1
