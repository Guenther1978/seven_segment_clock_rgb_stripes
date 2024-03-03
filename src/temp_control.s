    ;;
    ; @file
    ;;

    .equ    REG_TEMP, 0b00000000
    .equ    REG_CONFIG, 0b00000001
    .equ    REG_HYST, 0b00000010
    .equ    REG_SET, 0b00000011

    push    r16
    ;; Clock
    ldi     r16, ((F_CPU/TWI_CLOCK) - 16)/2
    out     TWBR, r16
    ;; TWI status register, predevider
    ldi     r16, 0
    out     TWSR, r16
    ;; Bus Address
    ldi     r16, TWI_ADR
    out     TWAR, r16
    ;; Enable
    ldi     r16, _TWINT | TWEN
    out     TWCR, r16
    pop     r16
    ret

twiStart:
    push    r16
    ldi     r16, _TWINT | _TWSTA | TWEN
    out     TWCR, r16
TWI_Start_wait1:
    in      r16, TWCR
    sbrs    r16, POS_TWINT
    rjmp    TWI_Start_wait1
    pop     r16
    ret

twiStop:
    push    r16
    in      r16, TWRC
    andi    r16, _TWEN | _TWIE
    ori     r16, _TWINT | _TWSTO
    out     TWCR, r16
    pop     r16
    ret

twiWriteByte:
    push    r16
    out     TWDR, r16
    in      r16, TWCR
    andi    r16, _TWEN | _TWIE
    ori     r16, _TWINT
    sbrc    r20, 0
    ori     r16, _TWEA
    out     TWCR, r16
twiWriteByte_wait2:
    in      r16, TWCR
    sbrs    r16, POS_TWINT
    rjmp    twiWriteByte_wait2
    pop     r16
    ret

twiReadByte:
    in      r16, TWCR
    andi    r16, _TWEN | _TWIE
    ori     r16, _TWINT
    sbrc    r20, 0
    ori     r16, _TWEA
    out     TWCR, r16
twiReadByte_wait2:
    in      r16, TWCR
    sbrs    r16, POS_TWINT
    rjmp    twiReadByte_wait2
    in      r16, TWDR
    ret
