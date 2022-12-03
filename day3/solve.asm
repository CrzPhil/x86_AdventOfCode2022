%include	"functions.asm"

SECTION	.data
datain	db	"input.txt", 0h

SECTION	.bss
data	resb	15000,
halflen	resd	1,
fulllen	resd	1,

SECTION	.text
global	_start

_start:

	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx

	push	15000
	push	data
	push	datain
	call	readFile

	mov	esi, data		; iterator for first compartment
	mov	edi, 0			; edi holds our total

_mainloop:

	cmp	byte [esi], 0Ah		; if esi points to \n we are done
	je	_done	

	mov	eax, esi		; check line's length
	call	slenNewline

	mov	[fulllen], eax		; fulllen holds total length

	xor	edx, edx

	mov	ebx, 2
	div	ebx		; Get half of string length
	mov	[halflen], eax		; halflen holds half of total length

	xor	ecx, ecx

.L1:

	cmp	ecx, [halflen]		; when ecx hits halflen, we iterated through the whole first compartment, meaning we move on to the next line 
	je	.nextline

.L2:
	cmp	eax, [fulllen]	; when eax hits fulllen we finished comparing all items and need to increment the first compartment's iterator
	je	.nextitem

	movzx	ebx, byte [esi+ecx]
	push	esi
	add	esi, ecx
	add	esi, eax
	movzx	edx, byte [esi]
	pop	esi
	cmp	bl, dl
;	movzx	edx, byte [esi+ecx+eax]	; for debugging
;	cmp	bl, byte [esi+ecx+eax]		; eax holds half of string length, so we just add it to iterator
	je	.getVal			; if equal, go get the priority value and proceed to next line

	inc	eax
	jmp .L2
	
.nextline:

	add	esi, [fulllen]
	inc	esi
	jmp	_mainloop

.nextitem:
	
	inc	ecx		; counter
	mov	eax, [halflen]
	sub	eax, ecx
	jmp	.L1

.getVal:

	; bl holds the value when we come here
	mov	eax, ebx
	call	iprintLF
	
	cmp	ebx, 96		; a -> 97, A -> 65
	jl	.caps

	xor	edx, edx

	mov	eax, ebx
	mov	ebx, 96		; 'x' % 96
	div	ebx

	add edi, edx		; remainder is item value
	; after a match is found we can move on to next line
	jmp	.nextline

.caps:

	mov	eax, ebx
	mov	ebx, 64
	xor	edx, edx
	div	ebx

	add	edx, 26		; after mod we need to add 26, as capitals' values start from 27
	add	edi, edx
	jmp	.nextline

_done:

	mov	eax, edi
	call	iprintLF

_quit:

	call	quit

