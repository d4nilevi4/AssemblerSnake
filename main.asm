[section .data]
screen_width	dd 80
screen_height	dd 43
test_text	db "THIS IS THE TEXT TEXT FOR DEBUG", 10, 0
text		db "Welcome to the 'Assybler Snake' game!", 10, 0
text_len	dw 10

[section .text]
global	_start
extern	print_char
extern	print_line
extern	clear_scr

_start:

	call	clear_scr

	push	dword "A"
	call	print_char

	push	dword 10
	call	print_char

	push	dword text
	call	print_line

	push	dword test_text
	call	print_line

	call	exit

exit:
	mov	eax, 1		; sys_exit 0x01
	xor	ebx, ebx	; ebx contains error code
	int	0x80		; syscall
