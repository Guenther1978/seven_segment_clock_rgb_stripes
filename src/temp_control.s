	;;
	; @file
	;;

	.equ    REG_TEMP, 0b00000000
	.equ    REG_CONFIG, 0b00000001
	.equ    REG_HYST, 0b00000010
	.equ    REG_SET, 0b00000011

	;;
	; @fn init_LM75
	;;
init_LM75:
	ldi	r16, 0
	ldi	r17, 0
	ldi	r18, REG_CONFIG
	rcall   setRegisterLM75
	; hysteresis = switch off
	ldi	r16, 0
	ldi	r17, 19
	ldi	r18, REG_HYST
	rcall	setRegisterLM75
	; set = temperature switch on
	ldi	r16, 0
	ldi	r17, 21
	ldi	r18, REG_SET
	rcall	setRegisterLM75

	;;
	; @ get_temp
	;;
getTemp:
	push	r20
	; send address
	rcall	twiStart
	ldi	r16, LM75_ADR | TWI_WRITE
	ldi	r20, 0
	rcall	twiWriteByte
	ldi	r16, REG_TEMP
	ldi	r20, 0
	rcall	twiWriteByte
	; read slave
	rcall	twiStart
	ldi	r16, LM75_ADR | TWI_READ
	ldi	r20, 0b00000001
	rcall	TwiWriteByte
	ldi	r20, 0b00000001
	rcall	TwiReadByte
	mov	r21, r16
	pop	r20
	ret
