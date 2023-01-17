; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "procedure.inc"
%include "kernel.inc"

extern strlen
extern strtoin
extern itostrn

global _start

section .bss
base1		resd 1
base2		resd 1

result		resb 32

section .text

inv_argc_str	db `Invalid argument count!\n`
inv_argc_strlen	equ $-inv_argc_str

inv_argc:	kernel sys_write, stdout, inv_argc_str, inv_argc_strlen
		kernel sys_exit, 1

inv_arg_str	db `Invalid argument!\n`
inv_arg_strlen	equ $-inv_arg_str

inv_arg:	kernel sys_write, stdout, inv_arg_str, inv_arg_strlen
		kernel sys_exit, 1

; EAX = 0 -- valid numeral system
;   ECX -- numeral system
; EAX = 1 -- invalid numeral system
check_arg_1_2:	; dd *ztstr
		pcall strlen, dword [esp+4]
		cmp eax, 1		; length = 1?
		jne .false		; NO
					; YES
		mov edx, [esp+4]
		xor ecx, ecx
		mov cl, [edx]

		cmp cl, '2'
		jnae .false
		cmp cl, '9'
		jnbe .is_letter

		sub cl, '0'
		jmp .true

.is_letter:	cmp cl, 'A'
		jnae .false
		cmp cl, 'Z'
		jnbe .false

		sub cl, 'A' - 10

.true:		xor eax, eax
		jmp short .quit

.false:		mov eax, 1

.quit:		ret

_start:		mov ebp, esp

		cmp dword [esp], 4
		jne inv_argc

		pcall check_arg_1_2, dword [ebp+8]	; argument 1
		test eax, eax
		jnz inv_arg
		mov [base1], ecx

		pcall check_arg_1_2, dword [ebp+12]	; argument 2
		test eax, eax
		jnz inv_arg
		mov [base2], ecx

		pcall strlen, dword [ebp+16]
		pcall strtoin, dword [base1], dword [ebp+16], eax
		test ecx, ecx
		jnz inv_arg

		pcall itostrn, dword [base2], eax, result
		mov byte [result+eax], `\n`
		inc eax
		kernel sys_write, stdout, result, eax

		kernel sys_exit, 0
