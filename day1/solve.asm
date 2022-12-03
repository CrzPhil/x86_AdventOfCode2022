%include	"functions.asm"

SECTION	.data
datain	db	"input.txt", 0h

SECTION	.bss
data	resb	15000,

SECTION	.text
global	_start

_start:

	xor	eax, eax
	xor	ebx, ebx
	xor	ecx, ecx
	xor	edx, edx

_readFile:

	mov	ecx, 0
	mov	ebx, datain
	mov	eax, 5
	int	80h		; Get FD (read)

	mov	edx, 15000
	mov	ecx, data
	mov	ebx, eax
	mov	eax, 3
	int	80h		; Read file save in data

	mov	eax, 6
	int	80h		; Close FD

_main:

	mov	esi, ecx		; start of &data
	mov	eax, 0

	xor	ebx, ebx
	xor	ecx, ecx		; highest value in calories
	xor	edi, edi		; intermediary total of one elf's calories

	jmp	_mainloop

_resetcounter:

	xor	edi, edi
	xor	eax, eax

_mainloop:

	cmp	byte [esi], 0Ah		; check if end of line
	je	.calc
	mov	bl, [esi]

	cmp	bl, 48		; compare to ascii val 48 -> 0
	jl	.finished	; if less than, it's not a number
	cmp	bl, 57
	jg	.finished	; greater than, not a number

	sub	bl, 48		; convert to decimal rep of ascii value
	add	eax, ebx	; eax holds the intermediary total
	mov	ebx, 10		; multiply eax by 10 
	mul	ebx

	inc	esi
	jmp	_mainloop

.calc:

	mov	ebx, 10		; compensate for the one extra multiplication
	div	ebx
	add	edi, eax	; current line added to edi
	xor	eax, eax
	inc	esi			; go to next line
	
	cmp	byte [esi], 0Ah		; second \n means this chunk is done and we need to compare
	jne	_mainloop

	inc	esi
	cmp	edi, ecx	; if smaller jump to next chunk, else update ecx and continue
	jl _resetcounter	

.newhigh:

	mov	ecx, edi
	jmp	_resetcounter 

.finished:

	mov	eax, ecx
	call	iprintLF

_quit:

	mov	ebx, 0
	mov	eax, 1
	int	80h

