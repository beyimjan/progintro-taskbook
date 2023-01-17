; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:
getch:	GETCHAR
	cmp eax, -1
	je quit
	PUTCHAR al
	jmp short getch
quit:	FINISH
