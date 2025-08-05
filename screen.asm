%include "stud_io.inc"

[section .data]
	escape		db 27

[section .bss]
	char_buf	resb 4
	escape_buf	resb 32
	ret_adr		resb 4
	text_adr	resb 4
	ascii_char	resb 4
	xPos		resb 4
	yPos		resb 4

[section .text]
	global print_char
	global print_line
	global clear_scr
	global set_pos

print_char:

	pop 	dword [ret_adr]		; save return adress
	pop	dword [char_buf]	; save character
	push	dword [ret_adr]		; push return adress

	; push all used registers to save them
	pushad

	mov	eax, 4			; sys_write
	mov	ebx, 1			; stdout
	mov	ecx, char_buf		; put character adress
	mov	edx, 1			; 1 byte to write
	int	0x80			; syscall

	; restore registers values
	popad

	ret

print_line:

	pop	dword [ret_adr]		; save rutrn adress
	pop	dword [text_adr]	; save text adress
	push	dword [ret_adr]		; restore return adress

	pushad				; save all extended registers

	mov	eax, [text_adr]		; save text adress into eax

.lp:	mov	bl, [eax]		; get character from eax
	cmp	bl, 0			; compare bl with 0
	je	.done			; if b == 0 then return
	push	ebx			; push character to stack
	call	print_char		; call print chacacter procedure
	inc	al			; look for next character
	jmp	.lp			; jump into start loop

.done:	popad				; restore all extended registers

	ret

clear_scr:

	pushad

	mov	eax, 4			; syswrite
	mov	ebx, 1			; stdout
	mov	edx, 4			; size

	mov	ecx, .cursor_home	; payload
	int	0x80

	mov	ecx, .ansi		; payload
	int	0x80			; syscal

	popad

	ret

.ansi:	db 27, "[J", 0
.cursor_home:
	db 27, "[H", 0

set_pos: ;ESC[{line};{column}H

	pop	dword [ret_adr]	; save return adress
	pop	dword [yPos]
	pop	dword [xPos]
	push	dword [ret_adr]	; restore return adress

	pushad

	push	dword 27
	call	print_char
	push	dword "["
	call	print_char
	push	dword [yPos]
	call	print_int
	push	dword ";"
	call	print_char
	push	dword [xPos]
	call	print_int
	push	dword "H"
	call	print_char

	popad

	ret

form_escape:

	pop	dword [ret_adr]		; save return adress

	xor	ecx, ecx

	mov	esi, escape_buf
.lp:
	pop	eax
	cmp	al, 0
	je	.done

	mov	[esi], eax

	inc	cl
	add	esi, ecx
	jmp	.lp

.done:	mov	eax, ecx
	mov	ecx, 4
	mul	ecx
	push	eax
	push	dword [ret_adr]		; restore return adress

	ret

print_int:

	pop	dword [ret_adr]
	pop	dword [ascii_char]
	push	dword [ret_adr]

	pushad

	mov	ecx, 10
	xor	ebx, ebx
	mov	eax, [ascii_char]

.reverse:
	xor	edx, edx
	div	ecx
	add	dl, '0'

	push	edx
	inc	ebx

	test	eax, eax
	jnz	.reverse

.print:
	call	print_char
	dec	ebx
	jnz	.print

	popad
	ret
