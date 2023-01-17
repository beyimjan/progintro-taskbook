; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:
main:	xor ebx, ebx		; if EBX = 0 then brackets are balanced

getch:	GETCHAR
	cmp eax, -1		; if eof then
	jz quit
	cmp al, `\n`		; elif AL = `\n`
	jz print
	cmp al, '('		; elif AL = '(' then
	jnz cb
	inc ebx			;   EBX++
	jmp short getch
cb:	cmp al, ')'		; elif AL = ')' then
	jnz getch
	dec ebx			;   EBX--
	jnge break		; elif EBX < 0
	jmp short getch		; else
break:	GETCHAR
	cmp eax, -1
	jz quit
	cmp al, `\n`
	jnz break		; nested loop
print:	test ebx, ebx
	jnz no
	PRINT `YES\n`
	jmp short nl
no:	PRINT `NO\n`
nl:	xor ebx, ebx
	jmp getch

quit:	FINISH
