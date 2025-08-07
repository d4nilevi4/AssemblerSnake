[section .bss]

	ret_adr		resb 4
	in_buf		resb 4

[section .text]

global read_char

; read one character from console and push cahracter
read_char:

	pop	dword [ret_adr]		; save return adress
;	pop	[in_buf]		; save character pointer
;	push	[ret_adr]		; restore return adress

	pushad				; save all extended registers

	mov	eax, 3			; sys read
	mov	ebx, 0			; stdin
	mov	ecx, in_buf		; set buffer
	mov	edx, 1			; 1 byte size
	int	0x80			; syscall

	popad

	push	dword [in_buf]
	push	dword [ret_adr]

	ret
