[section .data]
test_text	db "THIS IS THE TEXT TEXT FOR DEBUG", 10, 0
text		db "Welcome to the 'Assybler Snake' game!", 10, 0
text_len	dw 10

[section .text]
global	_start
extern	print_char
extern	print_line
extern	clear_scr
extern	set_pos
extern	cursor_up
extern 	cursor_down
extern	cursor_left
extern	cursor_right

_start:

	call	clear_scr

;	push	dword 50
;	push	dword 20
;	call	set_pos

	push	dword 10
	call	cursor_down

	push	dword 10
	call	cursor_right

	push	dword 5
	call	cursor_up

	push	dword 8
	call	cursor_left

	push	dword text
	call	print_line

	push	dword test_text
	call	print_line

	call	exit

exit:
	mov	eax, 1		; sys_exit 0x01
	xor	ebx, ebx	; ebx contains error code
	int	0x80		; syscall
