%include	"functions.asm"

SECTION .data
datain	db	"input.txt", 0h

SECTION	.bss
data	resd	15000,
total	resd	2,
f	resd	4,		; lower bound first range
s	resd	4,		; lower bound second range
x	resd	4,		; upper bound first range 
y	resd	4,		; upper bound second range

SECTION .text
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

	; Initialize the total to 0
	mov [total], byte 0
	
	mov	esi, data

.loop:

	; Check if we have reached the end of the file
	cmp [esi], byte 0Ah
	jz .done
	
	; get length of line
	mov	eax, esi
	call	slenNewline

	mov	edi, eax		; slen to know when to stop parsing
	mov	ecx, 0			; reset line-iterator
	
	; Split first range 
	mov	ebx, 0

.f:
	
	cmp	[esi+ecx], byte 0x2d		; check for '-' 
	je	.px					; if equal jump to upper bound first range
	movzx	eax, byte [esi+ecx]
	mov	[f+ebx], al
	inc	ecx
	inc	ebx
	jmp	.f
	

.px:

	xor	ebx, ebx

.x:
	
	inc	ecx
	cmp	[esi+ecx], byte 0x2c		; check for ','
	je	.ps
	movzx	eax, byte [esi+ecx]
	mov	[x+ebx], al
	inc	ebx
	jmp	.x

.ps:
	
	xor	ebx, ebx

.s:

	inc	ecx
	cmp	[esi+ecx], byte 0x2d
	je	.py					; if equal jump to upper bound first range
	movzx	eax, byte [esi+ecx]
	mov	[s+ebx], al
	inc	ebx
	jmp	.s
	
.py:

	xor	ebx, ebx

.y:
	
	inc	ecx
	cmp	[esi+ecx], byte 0Ah		; check for '\n'
	je	.calc
	movzx	eax, byte [esi+ecx]
	mov	[y+ebx], al
	inc	ebx
	jmp	.y

.calc:

	; when reaching this point, all vars have the ascii representation of the numbers, so we use atoi 
	mov	eax, f
	call	atoi
	mov	[f], eax

	mov	eax, x
	call	atoi
	mov	[x], eax

	mov	eax, s
	call	atoi
	mov	[s], eax

	mov	eax, y
	call	atoi
	mov	[y], eax

	mov	eax, [f]
	mov	ebx, [x]
	mov	ecx, [s]
	mov	edx, [y]

	cmp	eax, ecx
	jg	.gthan

	; if equal, overlap happens no matter what
	cmp	eax, ecx
	je	.addscore

	; this means f <= s and x >= y -> overlap
	cmp	ebx, edx
	jge	.addscore

	jmp	.nextline

.gthan:

	cmp	ebx, edx
	jle	.addscore

	jmp	.nextline
	
.addscore:

	; If the pairs overlap, print the line and increment the total
	mov eax, [total]
	inc eax
	mov [total], eax

.nextline:

	add	esi, edi
	inc	esi
	xor	ecx, ecx
	jmp	.loop
	
.done:
	; Print the total number of overlapping pairs
	mov eax, [total]
	call	iprintLF

_quit:

	call	quit
