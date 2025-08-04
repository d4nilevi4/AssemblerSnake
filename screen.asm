%include "stud_io.inc"

[section .data]
	test_escape	db 27, "[0;0H" ,0

[section .bss]
	char_buf	resb 4
	line_length	resb 4
	escape_buffer	resb 16
	toascii_buf	resb 12
	ret_adr		resb 4
	text_adr	resb 4

[section .text]
	global print_char
	global print_line

print_char:

	pop 	dword [ret_adr]		; save return adress
	pop	dword [char_buf]	; save character
	push	dword [ret_adr]		; push return adress

	; push all used registers to save them
	pushad

	mov	eax, 4			; sys_write
	mov	ebx, 1			; stdout
	mov	ecx, char_buf		; put character adress
	mov	edx, 1			; 1 byte to write
	int	0x80			; syscall

	; restore registers values
	popad

	ret

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

print_at:
    push ebp
    mov ebp, esp

    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; -- Сформировать ESC[y;xH] строку --
    mov esi, escape_buffer

    mov byte [esi], 27        ; ESC
    inc esi
    mov byte [esi], '['       ; [
    inc esi

    ; y -> строка
    mov eax, [ebp+8]
    call int_to_ascii
    mov edi, eax
.copy_y:
    lodsb
    test al, al
    je .after_y
    stosb
    jmp .copy_y
.after_y:

    mov byte [esi], ';'
    inc esi

    ; x -> строка
    mov eax, [ebp+12]
    call int_to_ascii
    mov edi, eax
.copy_x:
    lodsb
    test al, al
    je .after_x
    stosb
    jmp .copy_x
.after_x:

    mov byte [esi], 'H'
    inc esi
    mov byte [esi], 0         ; null terminator

    ; -- Печать управляющей последовательности --
    mov eax, 4
    mov ebx, 1
    mov ecx, escape_buffer
    mov edx, esi
    sub edx, escape_buffer
    int 0x80

    ; -- Печать самого символа --
    mov al, byte [ebp+4]
    mov [char_buf], al

    mov eax, 4
    mov ebx, 1
    mov ecx, "H"
    mov edx, 1
    int 0x80

    ; -- Завершение --
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    pop ebp
    ret 12

; --- int_to_ascii: преобразует EAX в строку ---
; возвращает EAX = указатель на строку

int_to_ascii:
    push ebx
    push ecx
    push edx
    push edi

    mov edi, toascii_buf
    mov ecx, 10
    xor ebx, ebx

.convert:
    xor edx, edx
    div ecx
    add dl, '0'
    push dx
    inc ebx
    test eax, eax
    jnz .convert

.build:
    pop ax
    stosb
    dec ebx
    jnz .build

    mov byte [edi], 0
    mov eax, toascii_buf

    pop edi
    pop edx
    pop ecx
    pop ebx
    ret
