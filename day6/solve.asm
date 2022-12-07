%include	"functions.asm"

SECTION	.data
datain	db	"input.txt", 0h

SECTION	.bss
data	resb	5000,
length	resd	1

SECTION	.text
global	_start

_start:

	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx

	push	5000
	push	data
	push	datain
	call	readFile

	mov	[length], dword 4		; length of chunks

	mov	esi, data

_loop:

	cmp	[esi], byte 0h
	je	_done

	xor	eax, eax
	xor	ebx, ebx

	call	isUnique
	cmp	al, byte 0
	jne	_done

	inc	esi
	jmp	_loop


_done:

	mov	eax, ecx
	call	iprintLF

	call	quit

isUnique:
    ; iterate through each character in the string
	mov	edx, [length]
	add	edx, ecx

.for:

    cmp ecx, edx            ; check if we reached the end of the string
    jge .done                     ; if equal, exit the loop

    mov al, [data + ecx]        ; get the current character
    mov bl, al                   ; save a copy in bl

	inc	ecx
    ; iterate through the rest of the string, checking if the current character
    ; is present in the rest of the string
.for2:
    cmp ecx, edx            ; check if we reached the end of the string
    je .next                     ; if equal, exit the loop

    cmp bl, [data + ecx]        ; check if the current character is present
    je .dup                      ; if equal, the string is not unique

    inc ecx                      ; move to the next character
    jmp .for2                    ; repeat the loop

.next:
    inc ecx                      ; move to the next character
    jmp .for                     ; repeat the loop

.dup:
    mov al, 0                    ; set al to 0
    jmp .done                    ; exit the function

.done:
    ret                          ; return from the function
