%include	"functions.asm"

SECTION	.data
datain	db	"input.txt", 0h

SECTION	.bss
data	resb	15000,

SECTION	.text
global	_start

_start:

	xor	eax, eax
	xor ebx, ebx	
	xor	ecx, ecx
	xor	edx, edx

	push	15000 
	push	data
	push	datain
	call	readFile

	mov	edi, 0
	mov	esi, data

	; ecx -> total score
	; esi -> iterator

_mainloop:

	cmp	byte [esi], 0Ah		; check if eol
	je .nextline
	mov	al, [esi]

	add	esi, 2		; skip space go to next char

	mov	bl,	[esi]

	cmp	al, "A"
	je	.A
	cmp	al, "B"
	je	.B
	cmp	al, "C"
	je	.C
	
	; neither option means we are done
	jmp	_done	

.nextline:

	inc	esi
	jmp	_mainloop

_done:

	mov	eax, ecx
	call	iprintLF

_quit:

	call	quit

