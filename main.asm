[section .data]
clear	db 27, '[2J', 0		; ANSI-code Clear Screen
home	db 27, '[H', 0		; move cursor to home position (0,0)
welcome	db 'Welcome to "Snake Assembler" game!', 10, 0

[section .text]
global _start

_start:

	call	clear_screen

	call	home_cursor

    	call	print_welcome_screen

	call	exit

clear_screen:
	mov	eax, 4
	mov	ebx, 1
	mov	ecx, clear
	mov	edx, 4
	int 	0x80

	ret

home_cursor:
	mov	eax, 4		; sys_write 0x04
	mov	ebx, 1		; stdout
	mov	ecx, home	; ANSI sequence "clear screen"
	mov	edx, 3		; ANSI code contains 3 bytes
	int	0x80		; syscall

	ret

print_welcome_screen:
	mov	eax, 4		; sys_write 0x04
	mov	ebx, 1		; stdout
	mov	ecx, welcome	; welcome text
	mov	edx, 35		; write 35 bytes
	int	0x80		; syscall

	ret

exit:
	mov	eax, 1		; sys_exit 0x01
	xor	ebx, ebx	; ebx contains error code
	int	0x80		; syscall
