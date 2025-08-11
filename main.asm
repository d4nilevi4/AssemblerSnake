; GAME MODE TYPES
; 0 => welcome mode

[section .bss]

	need_sleep	resb 1
	gm		resb 1			; type of game mode

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

	mov	dword [need_sleep], 1

	call	enable_raw_mode

	push	dword 0

.update:

	call	handle_input

	call	draw_screen

	call	sleep

	jmp	.update

	call	exit

draw_screen:
	call	clear_scr

	call	welcome_screen

	ret

handle_input:

	call	read_char
	pop	eax

	cmp	al, 0
	je	no_need_sleep

	call	handle_exit_input

	ret

no_need_sleep:

	mov	dword [need_sleep], 0

	ret

handle_exit_input:

	cmp	al, 113
	je	exit

	cmp	al, 81
	je	exit

	ret

sleep:

	pushad

;	mov	al, [need_sleep]
;	cmp	al, 0
;	je	.done

	mov	eax, 162		; nano sleep
	mov	ebx, .timespec
	xor	ecx, ecx
	int	0x80

.done:	mov	dword [need_sleep], 1

	popad

	ret

.timespec:
	dd 0				; tv_sec (0 sec)
	dd 500000000			; tv_nsec (0.5 sec)

exit:
	call	clear_scr
	call	disable_raw_mode
	mov	eax, 1		; sys_exit 0x01
	xor	ebx, ebx	; ebx contains error code
	int	0x80		; syscall
