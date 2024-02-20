;*******************************************************************************
;Universidad del Valle de Guatemala
;IE2023: Programacion de microcontroladores
;Autor: Alejandra Marcos
;PostLab3.asm
;
; Created: 15/02/2024 10:59:04
; Author : jaidy
;
;***************************
;Encabezado
;***************************
.include "M328PDEF.INC"
.cseg 
.org 0x00
	JMP		MAIN

.org 0x0002
	JMP		ISR_PCINT0

.org 0x0004	
	JMP		ISR_PCINT1

.org 0x0020
	JMP		ISR_TIMER0


;***************************
;Tabla de valores
;***************************
TABLA7SEG: .DB	 0x3F, 0x06, 0x5B, 0x4F, 0x66,	0x6D, 0x7D, 0x07, 0x7F, 0x6F


MAIN:
;***************************
;Stack
;***************************
	LDI		R16, LOW(RAMEND)
	OUT		SPL, R16 
	LDI		R17, HIGH(RAMEND)
	OUT		SPL, R17

;***************************
;Configuracion
;***************************
SETUP:
	LDI		ZL, LOW(TABLA7SEG << 1)
	LDI		ZH, HIGH(TABLA7SEG << 1)

	//OSCILADOR
	LDI		R16, (1 << CLKPCE)	;HABILITA EL PRESCALER
	STS		CLKPR, R16 
	LDI		R16, 0				;OSCILADOR DE 16MHz
	STS		CLKPR, R16
	
	//SALIDAS Y ENTRADAS
	LDI		R16, 0b0000_0000	;
	STS		UCSR0B, R16			;DESABILITO TX Y RX
	LDI		R16, 0b0000_1100	;
	OUT		PORTD, R16			;COLOCO EL PUERTO D COMO PULL-UP
	LDI		R16, 0b0000_0011	;
	OUT		DDRD, R16			;COLOCO EL PUERTO C COMO SALIDA
	LDI		R16, 0b1111_1111	;
	OUT		DDRC, R16			;COLOCO EL PUERTO B COMO SALIDA
	LDI		R16, 0b1111_1111	;
	OUT		DDRB, R16			;COLOCO EL PUERTO B COMO SALIDA

	//INTERRUPCIONES
	LDI		R16, 0
	OUT		TCCR0A, R16			;CONTADOR NORMAL
	LDI		R16, 5
	OUT		TCCR0B, R16			;PRESCALER 1024
	LDI		R16, 1				;
	STS		TIMSK0, R16			;HABILITA TOIE0
	LDI		R16, 99				;
	OUT		TCNT0, R16			;VALOR INICIAL

	LDI		R18, 3				;
	OUT		EIMSK, R18			;
	LDI		R16, 15				;
	STS		EICRA, R16			;


	LDI		R16, 0
	LDI		R17, 0
	LDI		R18, 0
	LDI		R19, 0
	LDI		R20, 1
	LDI		R21, 0
	LDI		R22, 0
	LDI		R23, 0
	LDI		R24, 0

	LPM		R18, Z
	OUT		PORTD, R18

	LPM		R19, Z
	OUT		PORTD, R19
	SEI

LOOP:
	CPI		R21, 100				; VERIFICASMO SI R20 = 100 PARA QUE HAGA 1S
	BRNE	LOOP					; SI NO SON IGUALES
	LDI		R21,0					; SI SON IGUALES REINICIA R20
	
	INC		R22
	ADD		ZL, R22
	LPM		R18, Z					; CARGA A R20 EL VALOR DE ESA POSICION
	//OUT		PORTB, R18				; MUESTRA EN EL PUERTO B EL VALOR
	LDI		ZL, LOW(TABLA7SEG << 1)
	LDI		ZH, HIGH(TABLA7SEG << 1)

	
	CPI		R22, 10					; VERIFICA SI ES EL VALOR MAXIMO 
	BRNE	LOOP					; SI NO SON IGUALES
	LDI		R22, 0
	
	LPM		R18, Z					; CARGA A R18 EL VALOR DE Z
	//OUT		PORTB, R18				; MUESTRA EN EL PUERTO B EL VALOR
	

	INC		R23
	ADD		ZL, R23
	LPM		R19, Z
	//OUT		PORTB, R19				; MUESTRA EN EL PUERTO B EL VALOR
	LDI		ZL, LOW(TABLA7SEG << 1)
	LDI		ZH, HIGH(TABLA7SEG << 1)

	CPI		R23, 6					; VERIFICA SI ES EL VALOR MAXIMO 
	BRNE	LOOP					; SI NO SON IGUALES
	LDI		R23, 0

	LDI		ZL, LOW(TABLA7SEG << 1)	; 
	LDI		ZH, HIGH(TABLA7SEG << 1); REINCIA EL LOS VALORES DE LA TABLA
	

	LPM		R18, Z					; CARGA A R18 EL VALOR DE Z
	//OUT		PORTB, R18				; MUESTRA EN EL PUERTO B EL VALOR
	
	LPM		R19, Z
	//OUT		PORTB, R19				; MUESTRA EN EL PUERTO B EL VALOR	
	
	RJMP	LOOP					;

;***************************
;Subrutinas
;***************************

;***************************
;VECTOR INTERRUPCION 1
ISR_TIMER0:
	PUSH	R16					;GUARDAMOS EN LA PILA
	IN		R16, SREG			;
	PUSH	R16					;
		
	INC		R21					;INCREMENTAMOS R20 
	COM		R20
	
	SBRS	R20, 0
	RJMP	ZERO
	SBI		PORTD, 0
	CBI		PORTD, 1
	OUT		PORTB, R19
	RJMP	UNO
ZERO:
	SBI		PORTD, 1
	CBI		PORTD, 0
	OUT		PORTB, R18

UNO: 
	//OUT		PORTC, R20 

	LDI		R17, 99				;
	OUT		TCNT0, R17			;VALOR INICIAL 

	POP		R16					;SACAMOS DE LA PILA
	OUT		SREG, R16			;
	POP		R16					;
	RETI 

;***************************
;VECTOR INTERRUPCION 1
ISR_PCINT0:
	PUSH	R16					;
	IN		R16, SREG			;
	PUSH	R16					;
	INC		R24					;
	OUT		PORTC, R24			;
	POP		R16					;
	OUT		SREG, R16			;
	POP		R16					;
	RETI

;***************************
;VECTOR INTERRUPCION 2
ISR_PCINT1:
	PUSH	R16
	IN		R16, SREG 
	PUSH	R16
	DEC		R24
	OUT		PORTC, R24
	POP		R16
	OUT		SREG, R16
	POP		R16
	RETI



