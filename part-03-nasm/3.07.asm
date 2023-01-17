; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text
_start:	GETCHAR
	cmp eax, -1
	je eof
	cmp al, 'A'
	jne no
	PRINT 'YES'
	jmp quit
no:	PRINT 'NO'
quit:	FINISH
eof:	FINISH 1
