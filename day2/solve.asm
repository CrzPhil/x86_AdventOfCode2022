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

	sub	ebx, 87		; Convert X-Y-Z to true value of choice (1-2-3)
	add	ecx, ebx

	mov	bl, [esi]	; move ascii back into bl, subtract ascii (ABC) and 1 
	sub	ebx, eax
	dec	ebx

	mov	eax, ebx	; take modulo of the above sum
	mov	ebx, 3
	div	ebx

	mov	eax, edx	; multiply by three to get win-draw-loss points
	mul	ebx

	add	ecx, eax	; add to total

.nextline:

	inc	esi

	cmp	byte [esi], 0h
	je	_done

	jmp	_mainloop

_done:

	mov	eax, ecx
	call	iprintLF

_quit:

	call	quit

