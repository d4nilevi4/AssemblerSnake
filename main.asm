[section .data]
screen_width	dd 80
screen_height	dd 43

[section .text]
global _start
extern print_char

_start:
	push	byte "a"

	call	print_char

	push	byte "b"

	call 	print_char

	push	byte 10

	call	print_char

	push	byte "J"

	call	print_char

	push	byte 10

	call	print_char

	call	exit

clear_screen:
	mov	eax, 4		; sys_write 0x04
	mov	ebx, 1		; stdout
	mov	ecx, .clear	; bytearray to write
	mov	edx, 4		; array length
	int 	0x80		; syscall

	ret

.clear:	db 27, '[2J', 0	; ANSI-code Clear Screen

home_cursor:
	mov	eax, 4		; sys_write 0x04
	mov	ebx, 1		; stdout
	mov	ecx, .home	; ANSI sequence "clear screen"
	mov	edx, 3		; ANSI code contains 3 bytes
	int	0x80		; syscall

	ret

.home:	db 27, '[H', 0          ; move cursor to home position (0,0)

print_frame:

	call print_top_frame
	call print_side_frame

	ret

print_top_frame:
	mov 	esi, 0
.again:	mov	eax, 4
	mov	ebx, 1
	mov	ecx, .frame_top
	mov	edx, 1
	int	0x80
	inc	esi
	cmp	esi, [screen_width]
	jl	.again

	ret

.frame_top:
	db "-"

print_side_frame:
	mov	esi, 0
.again:	mov	eax, 4
	mov	ebx, 1
	mov	ecx, .frame_side
	mov 	edx, 1
	int	0x80
	inc	esi
	cmp	esi, [screen_height]
	jl	.again

	ret

.frame_side:
	db "|"

print_welcome_screen:
	mov	eax, 4		; sys_write 0x04
	mov	ebx, 1		; stdout
	mov	ecx, .wlc_msg	; welcome text
	mov	edx, 35		; write 35 bytes
	int	0x80		; syscall

	ret

.wlc_msg:
	db 'Welcome to "Snake Assembler" game!', 10, 0

exit:
	mov	eax, 1		; sys_exit 0x01
	xor	ebx, ebx	; ebx contains error code
	int	0x80		; syscall
