%include "stud_io.inc"

[section .data]
	escape		db 27		; escape ASCII code, start for ANSI escape codes
	screen_width	db 80		; screen width size
	screen_hight	db 43		; ccreen heigh size

[section .bss]
	char_buf	resb 4		; char buffer used for save character to print in some place
	escape_buf	resb 32		; buffer for escape secuence
	ret_adr		resb 4		; retur addres
	text_adr	resb 4		; pointer on text
	xPos		resb 4		; cursor x position
	yPos		resb 4		; cursor y position

[section .text]
	global print_char
	global print_line
	global clear_scr
	global gen_escape
	global print_int

; pop character code from stack, and print one character
print_char:

	pop 	dword [ret_adr]		; save return adress
	pop	dword [char_buf]	; save character
	push	dword [ret_adr]		; push return adress

	pushad				; push all used registers to save them

	mov	eax, 4			; sys_write
	mov	ebx, 1			; stdout
	mov	ecx, char_buf		; put character adress
	mov	edx, 1			; 1 byte to write
	int	0x80			; syscall

	; restore registers values
	popad

	ret

; pop text adress from stack, and print one by one character, until find zero code '0'
print_line:

	pop	dword [ret_adr]		; save rutrn adress
	pop	dword [text_adr]	; save text adress
	push	dword [ret_adr]		; restore return adress

	pushad				; save all extended registers

	mov	eax, [text_adr]		; save text adress into eax

.lp:	mov	bl, [eax]		; get character from eax
	cmp	bl, 0			; compare bl with 0
	je	.done			; if b == 0 then return
	push	ebx			; push character to stack
	call	print_char		; call print chacacter procedure
	inc	al			; look for next character
	jmp	.lp			; jump into start loop

.done:	popad				; restore all extended registers

	ret

; clear screen procedure
clear_scr:

	pushad				; push all extended registers

	mov	eax, 4			; syswrite
	mov	ebx, 1			; stdout
	mov	edx, 4			; size

	mov	ecx, .cursor_home	; payload
	int	0x80

	mov	ecx, .ansi		; payload
	int	0x80			; syscal

	popad				; restore all extended registers

	ret

.ansi:	db 27, "[J", 0			; ANSI escape code to cleal screen
.cursor_home:
	db 27, "[H", 0			; ANSI escape code to move cursor (0,0) position

; generates a ANSI escape code, pop from stack character and store them into [escape_buf], until find zero code '0'
; push into stack size of escape buffer
; EXAMPLE move cursor to (0,0) position ANSI escape code -> "ESC[H"
;	push	dword 0
;	push	dword "H"
;	push	dword "["
;	push	dword [escape]
;	call	gen_escape

gen_escape:

	pop	dword [ret_adr]		; save return adress

	xor	ecx, ecx		; ecx := 0

	mov	esi, escape_buf		; save escape_buf pointer
.lp:
	pop	eax			; pop character from stack
	cmp	al, 0			; compare al with zero code '0'
	je	.done			; jump in end of procedure if find zero code

	mov	[esi], eax		; move character in [esi] adress

	inc	cl			; increment cl counter
	add	esi, ecx		; shift esi adress on characters counter value
	jmp	.lp			; jump into start loop

.done:	mov	eax, ecx		; move characters count value in eax register
	mov	ecx, 4			; move 4 into ecx (size of dword)
	mul	ecx			; multiply eax on ecx (count_of_characters*4)
	push	eax			; push result ANSI escape code size
	push	dword [ret_adr]		; restore return adress

	ret

; print character value as number, pop from stack dword number
; EXAMPLE
; push	dword 10
; call	print_int
; OUTPUT "10"
print_int:

	pop	dword [ret_adr]		; save return adress
	pop	dword [char_buf]	; save integer
	push	dword [ret_adr]		; restore return adress

	pushad				; push all extended registers

	mov	ecx, 10			; ecx := 10
	xor	ebx, ebx		; ebx := 0 (symbols counter)
	mov	eax, [char_buf]		; save integer into eax

.reverse:
	xor	edx, edx		; edx := 0
	div	ecx			; divide eax on ecx and move remider from division into edx
	add	dl, '0'			; make from edx value ASCII code of this value ('0' == 0x30)

	push	edx			; push ASCII code value
	inc	ebx			; increment ebx the symbols counter

	test	eax, eax		; compare eax with 0. Same: "cmp eax, 0"
	jnz	.reverse		; jump if zero into start of reverse loop

.print:
	call	print_char		; pprint character from stack
	dec	ebx			; decrement ebx (symbols counter)
	jnz	.print			; jump if zero into start of print loop

	popad				; restore all extended registers
	ret
