section .data
	TCGETS	equ 0x5401
	TCSETS	equ 0x5402
	ICANON	equ 0x0002
	ECHO	equ 0x0008

section .bss

    termios_buf resb 36

section .text

global	enable_raw_mode
global	disable_raw_mode

; enable_raw_mode: disables canonical mode and echo
enable_raw_mode:

	pushad				; save all extended registers

	; get current terminal settings
	mov	eax, 54			; sys_ioctl
	mov	ebx, 0			; stdin
	mov	ecx, TCGETS
	mov	edx, termios_buf
	int	0x80

	; modify settings: disable ICANON and ECHO
	mov	esi, termios_buf
	add	esi, 12			; c_lflag offset
	mov	eax, [esi]
	and	eax, ~(ICANON | ECHO)
	mov	[esi], eax

	; apply new settings
	mov	eax, 54			; sys_ioctl
	mov	ebx, 0			; stdin
	mov	ecx, TCSETS
	mov	edx, termios_buf
	int	0x80

	popad				; restore all extended registers

	ret

; disable_raw_mode: restores canonical mode and echo
disable_raw_mode:

	pushad				; save all extended registers

	; get current terminal settings
	mov	eax, 54
	mov	ebx, 0
	mov	ecx, TCGETS
	mov	edx, termios_buf
	int	0x80

	; restore ICANON and ECHO
	mov	esi, termios_buf
	add	esi, 12
	mov	eax, [esi]
	or	eax, (ICANON | ECHO)
	mov	[esi], eax

	; apply restored settings
	mov	eax, 54
	mov	ebx, 0
	mov	ecx, TCSETS
	mov	edx, termios_buf
	int	0x80

	popad				; restore all extended registers

	ret
