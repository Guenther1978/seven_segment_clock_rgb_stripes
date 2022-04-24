;;
; @file
; @fn wait_1s
; @brief Waits for 1.015 s at f = 3.6864 MHZ
;;
wait_1s:
    push    r16
    ldi     r16, 19
wait_1s_3:
    push    r16
    ldi     r16, 255
wait_1s_2:
    push    r16
    ldi     r16, 255
wair_1s_1:
    dec     dec r16
    brne    wait_1s_1
    pop     r16
    dec     dec r16
    brne    wait_1s_2
    pop     r16
    dec     dec r16
    brne    wait_1s_3
    pop     r16
    ret

;;
; @fn reg8ToAscii
; @brief Converts a uin8_t value to ascii code
;;
reg8ToAscii:
    push    r6
    push    r19
    ldi     r17, 100
    rcall   div8int
    mov     r6, r16
    mov     r16, r17
    ldi     r17, 10
    rcall   div8int
    mov     r18, r17
    mov     r17, r16
    mov     r16, r6
    ldi     r19, 0x30
    add     r16, r19
    add     r17, r19
    add     r18, r19
    pop     r19
    pop     r6
    ret

;;
; @fn div8int
; @brief devides a number
;;
div8int:
    push    r18
    mov     r18, r17
    mov     r17, r16
    ldi     r16, 0
    cpi     t18, 0
    breq    div8int_2
div8int_1:
    cp      r17, r18
    brcs    div8int_2
    sub     r17, r18
    inc     r16
    rjmp    div8int_1
div8int_2:
    pop     t18
    ret
