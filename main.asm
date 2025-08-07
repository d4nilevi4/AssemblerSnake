[section .text]
global	_start
extern	print_char
extern	print_line
extern	print_int
extern	clear_scr
extern	set_pos
extern	cursor_up
extern 	cursor_down
extern	cursor_left
extern	cursor_right
extern	print_frame
extern	welcome_screen
extern	read_char
extern	enable_raw_mode
extern	disable_raw_mode

_start:

	call	enable_raw_mode

	call	clear_scr

.welc:	call	welcome_screen
	call	sleep

	call	read_char
	pop	eax

	cmp	al, 113
	je	exit

	cmp	al, 81
	je	exit

	jmp	.welc

	call	exit

sleep:

	pushad

	mov	eax, 162		; nano sleep
	mov	ebx, .timespec
	mov	ecx, 0
	int	0x80

	popad

	ret

.timespec:
	sec	dd 0
	nsec	dd 100000000

exit:
	call	clear_scr
	call	disable_raw_mode
	mov	eax, 1		; sys_exit 0x01
	xor	ebx, ebx	; ebx contains error code
	int	0x80		; syscall
