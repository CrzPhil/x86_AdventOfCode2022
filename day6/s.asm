%include        "functions.asm"

SECTION .data
datain  db      "input.txt", 0h

SECTION .bss
data    resb    5000,
length  resd    1

SECTION .text
global  _start

_start:

	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx
	
	push	5000
	push	data
	push	datain
	call	readFile
	
	mov [length], dword 4               ; length of chunks
	mov esi, data

	mov	ecx, 0		; counter of start-of-packet chunk
	mov	edi, 0		; iterator

_loop:

	cmp	al, byte 0
	jne	_done

	mov	edi, 1

	push	ecx

	push	dword [length]
	add	[esp], ecx

.for:

	cmp	edi, [length]
	je	_loop

	mov	al,	byte [esi+ecx]

.for2:

	inc	ecx

	cmp	ecx, [esp]
	je	.next	

	xor	ebx, ebx
	mov	bl,	byte[esi+ecx]

	cmp	al,	bl
	je	.dup

	jmp	.for2

.dup:

	pop	ebx
	mov	al, 0
	pop	ecx
	inc	ecx
	jmp	_loop
;	sub	ecx, edi
;	inc	ecx
;	inc	ecx
;	jmp	_loop

.next:

	pop	ebx
	inc	edi
	mov	ecx, edi
	jmp	.for

_done:
	
	inc	ecx,
	mov	eax, ecx
	call	iprintLF
	
	call	quit
