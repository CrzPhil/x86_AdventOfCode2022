%include	"functions.asm"

SECTION	.data
asdf	db	"AEcFteAQpNmM", 0h

SECTION	.bss
tse	resw	1,
ptse	resw	1,


SECTION	.text
global	_start

_start:

	mov	eax, 0x73
	mov	ebx, 0x60
	mov	edx, 0x73
	div	ebx

	mov	eax, edx
	call	iprintLF
	call	quit
