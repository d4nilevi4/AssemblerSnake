[section .text]
	escape		db 27		; escape code

[section .bss]
	ret_adr		resb 4		; return adress
	xPos		resb 4		; cursor x position
	yPos		resb 4		; cursor y position

[section .text]

global set_pos

extern print_char
extern print_int

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
