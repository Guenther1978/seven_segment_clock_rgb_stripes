	;; @file

rtc_init:
	ldi	r16, 0
	rcall	getRtcData
	andi	r16, 0x80
	breq	rtcIsOn
	rcall	twiStart
	ldi	r16, RTC_ADR | TWI_WRITE
	ldi	r20, 0
	rcall	twiWriteByte
	ldi	r16, 0
	ldi	r20, 0
	rcall	twiWriteByte
	ldi	r16, 0
	ldi	r20, 0
	rcall	twiWriteByte
	rcall	twiStop
rtcIsOn:
	ret

getSeconds:
	ldi	r16, 0
	rcall	getRtcData
	andi	r16, 0x7f
	ret

getMinute:
	ldi	r16, 1
	rcall	getRtcData
	ret

getHours:
	ldi	r16, 2
	rcall	getRtcData
	andi	r16, 0x3f
	ret

;; @fn getRtcData
getRtcData:
	push	r20
	push	r16
	; sende Addresse
	rcall	twiStart
	ldi	r16, RTC_ADR | TWI_WRITE
	ldi	r20, 0			; kein ACKN
	rcall	twiWriteByte
	pop	r16			; Adresse
	ldi	r20, 0			; kein ACKN
	; Daten lesen
	rcall	twiStart		; TWI starten
	ldi	r16, RTC_ADR | TWI_READ
	rcall	twiWriteByte		; Daten schreiben
	ldi	r20, 0			; kein ACKN
	rcall	twiReadByte		; Daten lesen
	rcall	twiStop			; TWI beenden
	pop	r20
	ret

;; @fn sendTime
sendTime:
	push	r16
	rcall	getHour
	rcall	sendBCD
	ldi	r16, ':'
	rcall	putChar
	rcall	getMinute
	rcall	sendBCD
	ldi	r16, ':'
	rcall	putChar
	rcall	getSeconds
	rcall	sendBCD
	ldi	r16, 10
	rcall	putChar
	pop	r16
	ret
