; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "procedure.inc"
%include "kernel.inc"

extern strlen
extern strtoin
extern itostrn

global _start

section .bss
n1		resd 1
n2		resd 1

result		resb 64

section .text

inv_argc_str	db `Invalid argument count!\n`
inv_argc_strlen	equ $-inv_argc_str

inv_argc:	kernel sys_write, stdout, inv_argc_str, inv_argc_strlen
		kernel sys_exit, 1

inv_arg_str	db `Invalid argument!\n`
inv_arg_strlen	equ $-inv_arg_str

inv_arg:	kernel sys_write, stdout, inv_arg_str, inv_arg_strlen
		kernel sys_exit, 1

_start:		mov ebp, esp

		cmp dword [ebp], 3
		jne inv_argc

		pcall strlen, dword [ebp+8]
		pcall strtoin, 8, dword [ebp+8], eax
		test ecx, ecx
		jnz inv_arg
		mov dword [n1], eax

		pcall strlen, dword [ebp+12]
		pcall strtoin, 8, dword [ebp+12], eax
		test ecx, ecx
		jnz inv_arg
		mov dword [n2], eax

		mov word [result], "+ "
		mov ebx, result+2
		mov eax, [n1]
		add eax, [n2]
		pcall itostrn, 8, eax, ebx
		add ebx, eax
		mov byte [ebx], `\n`
		add ebx, 1

		mov word [ebx], "- "
		add ebx, 2
		mov eax, [n1]
		sub eax, [n2]
		pcall itostrn, 8, eax, ebx
		add ebx, eax
		mov byte [ebx], `\n`
		add ebx, 1

		sub ebx, result
		kernel sys_write, stdout, result, ebx

		kernel sys_exit, 0
