; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "procedure.inc"
%include "kernel.inc"

extern strlen
extern putzts

global _start

section .text

nlstr	db `\n`, 0

_start:	cmp dword [esp], 1
	je .err

	xor edi, edi			; EDI = 0 -- max string length
	mov ebx, 2			; EBX = 2 -- longest parameter
	mov esi, 2			; ESI = 2

.again:	cmp esi, [esp]
	ja .break
	pcall strlen, dword [esp+esi*4]
	cmp eax, edi
	jbe .cont
	mov edi, eax
	mov ebx, esi
.cont:	inc esi
	jmp short .again

.break:	pcall putzts, dword [esp+ebx*4]
	pcall putzts, dword nlstr

.quit:	kernel sys_exit, 0
.err:	kernel sys_exit, 1
