%include        "functions.asm"

SECTION .data
datain  db      "input.txt", 0h

SECTION .bss
data    resb    15000,

SECTION .text
global  _start

_start:

        xor     eax, eax
        xor ebx, ebx
        xor     ecx, ecx
        xor     edx, edx

        push	15000 
        push	data
        push	datain
        call	readFile

        mov	edi, 0
        mov	esi, data

        ; ecx -> total score
        ; esi -> iterator

_mainloop:

        cmp	byte [esi], 0Ah         ; check if eol
        je	.nextline

		mov	al, [esi]

        add	esi, 2          ; skip space go to next char

		mov	bl, [esi]
		sub	ebx, 0x58		; subtract "X" (get true val 1-2-3)

		push	eax			; save ABC on stack

		mov	eax, ebx		; X -> 0 (loss), Y -> 1 (draw), Z -> 3 (win)
		mov	ebx, 3			;
		mul ebx

		add	ecx, eax		; add outcome value to total score

		mov	bl, [esi]		; XYZ
		pop	eax				; ABC

		add	eax, ebx		; ascii value of ABC + XYZ - 1 mod 3 -> value of choice
		dec	eax

		mov	ebx, 3			; mod means div and get remainder from edx
		div	ebx

		inc	edx
		add	ecx, edx

.nextline:

        inc     esi

        cmp     byte [esi], 0h
        je      _done

        jmp     _mainloop

_done:

        mov     eax, ecx
        call    iprintLF

_quit:

        call    quit
