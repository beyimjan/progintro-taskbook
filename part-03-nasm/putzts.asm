; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "procedure.inc"
%include "kernel.inc"

extern strlen

global putzts

section .text

putzts:	; dd *str
	push ebp
	mov ebp, esp

	pcall strlen, dword [ebp+8]
	kernel sys_write, stdout, [ebp+8], eax

	mov esp, ebp
	pop ebp
	ret
