[section .text]
	escape		db 27		; escape code

[section .bss]
	ret_adr		resb 4		; return adress
	xPos		resb 4		; cursor x position
	yPos		resb 4		; cursor y position
	offset		resb 4		; offset value

[section .text]

global set_pos
global cursor_up
global cursor_down
global cursor_left
global cursor_right

extern print_char
extern print_int
extern gen_escape

cursor_up: ; ANSI escape code ESC[{offset}A

	pop	dword [ret_adr]		; save return adress
	pop	dword [offset]		; pop offset value
	push	dword [ret_adr]		; restore return adress

	pushad				; save all extended registers in stack

	push	dword [escape]
	call	print_char
	push	dword "["
	call	print_char
	push	dword [offset]
	call	print_int
	push	dword "A"
	call	print_char

	popad

	ret

cursor_down: ; ANSI escape code ESC[{offset]B

	pop	dword [ret_adr]
	pop	dword [offset]
	push	dword [ret_adr]

	pushad

	push	dword [escape]
	call	print_char
	push	dword "["
	call	print_char
	push	dword [offset]
	call	print_int
	push	dword "B"
	call	print_char

	popad

	ret

cursor_right: ; ANSI escape code ESC[{offset}C

	pop	dword [ret_adr]
	pop	dword [offset]
	push	dword [ret_adr]

	pushad

	push	dword [escape]
	call	print_char
	push	dword "["
	call	print_char
	push	dword [offset]
	call	print_int
	push	dword "C"
	call	print_char

	popad

	ret

cursor_left: ; ANSI escape code ESC[{offset}D

	pop	dword [ret_adr]
	pop	dword [offset]
	push	dword [ret_adr]

	pushad

	push	dword [escape]
	call	print_char
	push	dword "["
	call	print_char
	push	dword [offset]
	call	print_int
	push	dword "D"
	call	print_char

	popad

	ret

; pop x and y position from stack and move cursor in (x, y) position
set_pos: ; ANSI escape code ESC[{line};{column}H

        pop     dword [ret_adr]         ; save return adress
        pop     dword [yPos]            ; pop y position value
        pop     dword [xPos]            ; pop x position value
        push    dword [ret_adr]         ; restore return adress

        pushad                          ; save all extended registers in stack

        push    dword [escape]          ; start ansi escape code, push ESC code
        call    print_char              ; call print character procedure
        push    dword "["               ; push secode ansi escape code character
        call    print_char              ; call print character procedure
        push    dword [yPos]            ; push y position value to stack
        call    print_int               ; print y position into stdout
        push    dword ";"               ; push ; into stack
        call    print_char              ; call print character procedure
        push    dword [xPos]            ; push x position value to stack
        call    print_int               ; print x position into stdout
        push    dword "H"               ; push last asni escape code character
        call    print_char              ; call print character procedure

        popad                           ; restore all extended registers

        ret
