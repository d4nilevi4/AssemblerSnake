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
extern	print_frame
extern	welcome_screen

_start:

	call	clear_scr

.welc:	call	welcome_screen
	call	sleep

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
	nsec	dd 500000000

exit:
	mov	eax, 1		; sys_exit 0x01
	xor	ebx, ebx	; ebx contains error code
	int	0x80		; syscall
