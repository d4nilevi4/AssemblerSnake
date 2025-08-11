[section .bss]

	ret_adr		resb 4
	in_buf		resb 4

[section .text]

global	read_char

extern	print_char

; read one character from console and push cahracter
read_char:

	pop	dword [ret_adr]		; save return adress

	pushad				; save all extended registers

	mov	dword [in_buf], 0

	mov	eax, 3			; sys read
	mov	ebx, 0			; stdin
	mov	ecx, in_buf		; set buffer
	mov	edx, 1			; 1 byte size
	int	0x80			; syscall

	popad

	mov	al, [in_buf]
	cmp	al, 0
	je	.print_z

	push	dword "n"
	call	print_char

.done:	push	dword [in_buf]
	push	dword [ret_adr]

	ret

.print_z:
	push	dword "z"
	call	print_char
	jmp	.done
