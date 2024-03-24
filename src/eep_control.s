	;;
	; @file
	;;

	;;
	; @fn init_24cx
	;;
init_24xc:
	clr	r0
	ret

	;;
	; @fn write_ExtEEPROM
	;;
write_ExtEEPROM:
	push	r20
	push	r16
	ldi	r20, 0		; no ACKN
	rcall	twiStart	; start TWI
	ldi	r16, EEP_ADR
	rcall	twiWriteByte	; send EEP_ADR
	mov	r16, r0
	rcall	twiWriteByte	; set internal address
	pop	r16		; get data from stack
	rcall	twiWriteByte	; write data
	rcall	twiStop		; stops TWI
	rcall	wait_10ms	: wait until TWI ready
	pop	r20
	ret

	;;
	; @fn read_ExtEEPROM
	;;
read_ExtEEPROM:
	push	r20
	ldi	r20, 0		; no ACKN
	rcall	twiStart	; start TWI
	ldi	r16, EEP_ADR
	rcall	twiWriteByte	; send EEP_ADR
	mov	r16, r0
	rcall	twiWriteByte	; set internal address
	rcall	twiStart	; start TWI
	ldi	r20, 0b00000001	; TMEA: send data!
	ldi	r16, EEP_ADR + 1; start reading
	rcall	twiWriteByte	; start EEP
	ldi	r20, 0		; no ACKN
	rcall	twiReadByte	; read data
	rcall	twiStop		; stop TWI
	pop	r20
	ret

	;;
	; @fn sendEEP
	;;
sendEEP:
	push	r16
	push	r0
	clr	r0
readNext:
	rcall	read_ExtEEPROM
	rcall	putChar
	inc	r0
	brne	readNext
	pop	r0
	pop	r16
	ret
