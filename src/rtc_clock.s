;+-----------------------------------------------------------------------------
;| Title      : Assembler Grundgeruest für ATmega8
;+-----------------------------------------------------------------------------
;| Funktion   : ...
;| Schaltung  : ...
;+-----------------------------------------------------------------------------
;| Prozessor  : ATmega8
;| Takt       : 3,6864 MHz
;| Sprache    : Assembler
;| Datum      : ...
;| Version    : ...
;| Autor      : ...
;+-----------------------------------------------------------------------------
.include        "AVR.H"
;------------------------------------------------------------------------------
begin:
    rjmp    main                        ; RESET External Pin, Power-on Reset, Brown-out Reset and Watchdog Reset
    reti                                ; INT0 External Interrupt Request 0
    reti                                ; INT1 External Interrupt Request 1
    reti                                ; TIMER2 COMP Timer/Counter2 Compare Match
    reti                                ; TIMER2 OVF Timer/Counter2 Overflow
    reti                                ; TIMER1 CAPT Timer/Counter1 Capture Event
    reti                                ; TIMER1 COMPA Timer/Counter1 Compare Match A
    reti                                ; TIMER1 COMPB Timer/Counter1 Compare Match B
    reti                                ; TIMER1 OVF Timer/Counter1 Overflow
    reti                                ; TIMER0 OVF Timer/Counter0 Overflow
    reti                                ; SPI, STC Serial Transfer Complete
    reti                                ; USART, RXC USART, Rx Complete
    reti                                ; USART, UDRE USART Data Register Empty
    reti                                ; USART, TXC USART, Tx Complete
    reti                                ; ADC ADC Conversion Complete
    reti                                ; EE_RDY EEPROM Ready
    reti                                ; ANA_COMP Analog Comparator
    reti                                ; TWI 2-wire Serial Interface
    reti                                ; SPM_RDY Store Program Memory Ready
;------------------------------------------------------------------------------
; Start, Power On, Reset
main:
