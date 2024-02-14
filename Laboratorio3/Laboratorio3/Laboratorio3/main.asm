;*******************************************************************************
;Universidad del Valle de Guatemala
;IE2023: Programacion de microcontroladores
;Autor: Alejandra Marcos
;Laboratorio3.asm
;
; Created: 14/02/2024 00:27:31
; Author : jaidy
;
;***************************
;Encabezado
;***************************
.include "M328PDEF.INC"
.cseg 
.org 0x00
	JMP		MAIN

.org 0x0006
	JMP		ISR_PCINT0

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
	//OSCILADOR
	LDI		R16, (1 << CLKPCE)	;HABILITA EL PRESCALER
	STS		CLKPR, R16 
	LDI		R16, 0				;OSCILADOR DE 16MHz
	STS		CLKPR, R16
	
	//SALIDAS Y ENTRADAS
	LDI		R16, 0b0000_0000	;
	STS		UCSR0B, R16			;DESABILITO TX Y RX
	LDI		R16, 0b1111_1111	;
	OUT		PORTB, R16			;COLOCO EL PUERTO B COMO PULL-UP
	LDI		R16, 0b0000_0000	;
	OUT		DDRB, R16			;COLOCO EL PUERTO B COMO ENTRADA
	LDI		R16, 0b1111_1111	;
	OUT		DDRC, R16			;COLOCO EL PUERTO C COMO SALIDA
	LDI		R16, 0b1111_1111	;
	OUT		DDRD, R16			;COLOCO EL PUERTO D COMO SALIDA

	//INTERRUPCIONES
	LDI		R16, 3
	STS		PCMSK0, R16			;HABILITA PCINT0 y PCINT1
	LDI		R16, 1				;
	STS		PCICR, R16			;HABILITA PCIE0

	LDI		R16, 0
	LDI		R17, 0
	LDI		R18, 0
	LDI		R19, 0
	LDI		R20, 0

	SEI

LOOP:
	RJMP	LOOP

;***************************
;Subrutinas
;***************************

;***************************
;VECTOR INTERRUPCION 1
ISR_PCINT0:
	PUSH	R16					;GUARDAMOS EN LA PILA
	IN		R16, SREG			;
	PUSH	R16					;

BOTON1:
	IN		R18, PINB			;
	SBRC	R18, PB0			;VERIFICASMOS SI PINB0 ES IGUAL A 0
	RJMP	BOTON2				;SI NO ES IGUAL A 0
	INC		R20					;SI ES IGUAL A 0, INCREMENTAMOS
	OUT		PORTD, R20			;
	RJMP	SALIR				
		
BOTON2:
	IN		R18, PINB			;
	SBRC	R18, PB1			;VERIFICASMOS SI PINB1 ES IGUAL A 0
	RJMP	SALIR				;SI NO ES IGUAL A 0
	DEC		R20					;SI ES IGUAL A 0, DECREMENTAMOS
	OUT		PORTD, R20			;

SALIR:
	POP		R16					;SACAMOS DE LA PILA
	OUT		SREG, R16			;
	POP		R16					;
	RETI