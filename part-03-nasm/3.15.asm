; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:
main:	xor ebx, ebx		; If EBX = 0 then brackets are balanced

getch:	GETCHAR
	cmp eax, -1		; If EOF is reached then
	jz quit			;   Finish the program
	cmp al, `\n`		; Elif AL = `\n`
	jz print		;   Display the result
	cmp al, '('		; Elif AL = '(' then
	jnz closed_parentheses
	inc ebx			;   EBX++
	jmp short getch
closed_parentheses:
	cmp al, ')'		; Elif AL = ')' then
	jnz getch
	dec ebx			;   EBX--
	jnge break		; Elif EBX < 0: for the input like ')('
	jmp short getch		; Else
break:	GETCHAR
	cmp eax, -1
	jz quit
	cmp al, `\n`
	jnz break
print:	test ebx, ebx
	jnz no
	PRINT `YES\n`
	jmp short new_line
no:	PRINT `NO\n`
new_line:
	xor ebx, ebx
	jmp getch

quit:	FINISH
