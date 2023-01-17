; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "stud_io.inc"

global _start

section .text

; ZF = 1 if al is `\t` or ' ', otherwise ZF = 0
alwp:	cmp al, `\t`
	je .quit
	cmp al, ' '
.quit:	ret

; ZF = 1 if dl is `\t` or ' ', otherwise ZF = 0
dlwp:	cmp dl, `\t`
	je .quit
	cmp dl, ' '
.quit:	ret

_start:	xor ecx, ecx		; ECX = 0: start of the line
	xor ebx, ebx		; EBX = 0: first word in a line
.getch:	mov edx, eax		; EDX = previous character
	GETCHAR			; EAX = current character

	cmp eax, -1		; EOF?
	jne .neof		;   NO!
	test ecx, ecx		;   YES: start of the line?
	jz .quit		;     YES
	cmp dl, `\n`		;   end of the line?
	je .quit		;     YES
	call dlwp		;   end of the word?
	jz .eofnl		;     NO
	PUTCHAR ')'		;     YES
.eofnl:	PUTCHAR `\n`
	jmp .quit		;   QUIT!

.neof:	cmp al, `\n`		; EOF not reached
				;   AL = `\n`?
	jne .nnl		;     NO
	test ecx, ecx		;     YES: start of the line?
	jz .nl			;       YES
	call dlwp		;       NO: end of the word?
	jz .nl			;         NO
	PUTCHAR ')'		;         YES
.nl:	xor ecx, ecx		;     ECX = 0 -- next line is new
	xor ebx, ebx		;     EBX = 0 -- next word is first in a line
	PUTCHAR `\n`
	jmp .getch
.nnl:	test ecx, ecx		; start of the line?
	jnz .mofl		;   NO: middle of the line
	mov ecx, 1		;   YES
	call alwp		;   start of the word?
	jz .getch		;     NO
	PUTCHAR '('		;     YES
	PUTCHAR al
	jmp .getch
.mofl:	call dlwp		; middle of the line
	jnz .meofw		;   in the middle (or end) of the word
	call alwp		;   start of the word?
	jz .getch		;     NO
	test ebx, ebx		;     YES
	jz .ob
	PUTCHAR ' '
.ob:	PUTCHAR '('
	PUTCHAR al
	jmp .getch
.meofw:	call alwp		; middle (or end) of the word
	jnz .mofw		;   middle of the word
	PUTCHAR ')'		;   end of the word
	mov ebx, 1		;     EBX = 1: next word isn't first
	jmp .getch
.mofw:	PUTCHAR al
	jmp .getch
.quit:	FINISH
