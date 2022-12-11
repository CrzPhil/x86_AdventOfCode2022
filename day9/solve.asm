%include	"functions.asm"

SECTION	.data
datain	db	"input.txt", 0h

SECTION .bss
data	resb	5000, 
visited	resd	1000,
d	resd	4,
v	resd	4,

SECTION	.text
global	_start

_start:

	xor	eax,eax
	xor	ebx,ebx
	xor	ecx,ecx
	xor	edx,edx

	push	5000
	push	data
	push	datain
	call	readFile

	mov	esi, data

_mainloop:

	cmp byte [esi], 0h
	je	_done
	
	mov	eax, esi
	call	slenNewline
	push	eax

.parse:

	; first byte of line is always direction
	movzx	eax, byte [esi]
	mov	[d], eax
	mov	edi, 2

.parseval:

	cmp	edi, [esp]
	je	.calc

	movzx	eax, byte [esi+edi]
	push	eax

	mov	eax, [esp]
	call	atoi

	mov	[v+edi-2], eax
	pop	eax
	inc	edi
	jmp	.parseval
	
.calc:

.nextline:

	; Go to next line
	pop	eax
	add	esi, eax
	inc	esi
	jmp	_mainloop

_done:

	mov	eax, ecx
	call	iprintLF

_end:

	call	quit
