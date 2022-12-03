
slen:
	push	ebx
	mov	ebx, eax

.nextchar:
	cmp	byte [eax], 0
	jz	.finished
	inc	eax
	jmp	.nextchar

.finished:
	sub	eax, ebx
	pop	ebx
	ret

; Get string length of a string terminated by a newline character
slenNewline:
	push	ebx
	mov	ebx, eax

.nextchar:
	cmp	byte [eax], 0Ah
	jz	.finished
	inc	eax
	jmp	.nextchar

.finished:
	sub	eax, ebx
	pop	ebx
	ret


sprint:
	push	edx
	push	ecx
	push	ebx
	push	eax
	call	slen

	mov	edx, eax
	pop	eax

	mov	ecx, eax
	mov	ebx, 1
	mov	eax, 4
	int	80h

	pop	ebx
	pop	ecx
	pop	edx
	ret


sprintLF:
	call	sprint

	push	eax
	mov	eax, 0Ah
	push	eax
	mov	eax, esp
	call	sprint
	pop	eax
	pop	eax
	ret


iprint:
	push	eax
	push	ecx
	push	edx
	push	esi
	mov	ecx, 0

.divideLoop:
	inc	ecx
	mov	edx, 0
	mov	esi, 10
	idiv	esi
	add	edx, 48
	push	edx
	cmp	eax, 0
	jnz	.divideLoop

.printLoop:
	dec	ecx
	mov	eax, esp
	call sprint
	pop	eax
	cmp	ecx, 0
	jnz	.printLoop

	pop	esi
	pop	edx
	pop	ecx
	pop	eax
	ret

iprintLF:
	call	iprint

	push	eax
	mov	eax, 0Ah
	push	eax
	mov	eax, esp
	call	sprint
	pop	eax
	pop	eax
	ret


; print a single char
cprint:
	push edx
	push ecx
	push ebx
	push eax

	mov	edx, 1	; length -> 1
	mov	ecx, eax
	mov	ebx, 1
	mov	eax, 4
	int	80h
	pop eax
	pop ebx
	pop ecx
	pop edx
	ret

; getFDread(filename) -> (read only) file descriptor in eax
getFDread:
        push    ecx
        push    ebx

        mov     ecx, 0
        mov     ebx, eax
        mov eax, 5
        int     80h

        pop     ebx
        pop     ecx
        ret

; getFDboth(filename) -> (r/w) file descriptor in eax
getFDboth:
        push    ecx
        push    ebx

        mov     ecx, 2
        mov     ebx, eax
        mov     eax, 5
        int     80h

        pop     ebx
        pop     ecx
        ret

; readFile(size, contentsmemory, filename) -> Contents in memory location
readFile:
        push    edx
        push    ecx
        push    ebx
        push    eax

        add     esp, 20         ; skip the saved registers
        mov     eax, [esp]              ; filename -> eax
        sub esp, 20             ; put esp back on top of stack

        call    getFDread

        add esp, 28             ; point esp back to parameters
        mov edx, [esp]          ; Size to read (size of allocated memory will do)
        sub esp, 4
        mov ecx, [esp]          ; Address of allocated memory (in .bss (?))
        mov ebx, eax            ; File descriptor
        mov     eax, 3  ; opcode
        int     80h

        sub esp, 24

        mov     eax, ebx
        call    closeFD

        pop     eax
        pop     ebx
        pop     ecx
        pop     edx
        ret


; closeFD(fileDescriptor) -> Void
closeFD:
        push    ebx

        mov     ebx, eax
        mov     eax, 6
        int     80h

        pop     ebx
        ret

quit:
	mov	ebx, 0
	mov	eax, 1
	int	80h
	ret

