; Copyright (C) 2022, 2023 Tamerlan Bimzhanov

%include "kernel.inc"

global _start

section .data
current_line_started	dd 1
current_line_terminated	dd 0

section .bss
resffd	resd 1

result	resb 12
ressize	equ $-result

buffer	resb 1024
bufsize	equ $-buffer
bufused	resd 1

section .text

resfile	db "result.dat", 0

resfo_fail_str		db `Couldn't open "result.dat" for writing!\n`
resfo_fail_strlen	equ $-resfo_fail_str

resfo_fail:	kernel sys_write, stdout, resfo_fail_str, resfo_fail_strlen
		kernel sys_exit, 1

_start:
main:		xor ebx, ebx			; total number of lines
		xor esi, esi			; total length of all lines
		xor edi, edi			; length of the longest string

.read_loop:	kernel sys_read, stdin, buffer, bufsize
		cmp eax, 0
		jle .eof
		mov dword [bufused], eax
		xor ecx, ecx			; ECX = 0 -- I
		cmp dword [current_line_started], 1
		je .start_of_line

.middle_ol:	inc ecx
		cmp byte [buffer+ecx-1], `\n`
		je .new_line
		inc ebp
		jmp short .continue

.start_of_line: xor ebp, ebp			; length of the current line
		inc ecx
		cmp byte [buffer+ecx-1], `\n`
		je .new_line
		mov dword [current_line_terminated], 0
		mov dword [current_line_started], 0
		inc ebp
		jmp short .continue

.new_line:	mov dword [current_line_terminated], 1
		mov dword [current_line_started], 1
		inc ebx
		add esi, ebp
		cmp ebp, edi
		jbe .continue
		mov edi, ebp

.continue:	cmp ecx, [bufused]
		je .read_loop
		jmp short .middle_ol

.eof:		cmp dword [current_line_terminated], 1
		je .quit
		cmp dword [current_line_started], 1
		je .quit
		inc ebx

.eof_result:	add esi, ebp
		cmp ebp, edi
		jbe .quit
		mov edi, ebp

.quit:		kernel sys_open, resfile, O_WRONLY|O_CREAT|O_TRUNC, 0666q
		cmp eax, -1
		jne .resf_open_ok
		call resfo_fail

.resf_open_ok:	mov dword [resffd], eax
		mov dword [result], ebx
		mov dword [result+4], esi
		mov dword [result+8], edi
		kernel sys_write, [resffd], result, ressize
		kernel sys_close, [resffd]
		kernel sys_exit, 0
