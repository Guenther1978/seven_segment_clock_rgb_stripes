    ;;
    ; @file
    ;;

    ;;
    ; @fn init_UART
    ; @brief Initializes the UART module
    ;;
init_UART:
    push    r16
    sbi     UCSRB, 4
    sbi     UCSRB, 3
    ldi     r16, F_CPU/(BAUC * 16) - 1
    out     UBRRL, r16
    pop     r16
    ret

    ;;
    ; @fn putChar
    ; @brief Sends a character
    ;;
putChar:
    sbis    UCSRA, 5
    rjmp    putChar
    out     UDR, r16
    ret
