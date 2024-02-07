;*******************************************************************************
;Universidad del Valle de Guatemala
;IE2023: Programacion de microcontroladores
;Autor: Alejandra Marcos
;Laboratorio2.asm
;
; Created: 6/02/2024 13:20:18
; Author : jaidy
;

;*******************************************************************************
;Encabezado
;*******************************************************************************
.include "M328PDEF.inc"
.cseg
.org 0x00

;*******************************************************************************
;Stack
;*******************************************************************************
	LDI		R16, LOW(RAMEND)
	OUT		SPL, R16 
	LDI		R17, HIGH(RAMEND)
	OUT		SPL, R17

;*******************************************************************************
;Configuracion
;*******************************************************************************
SETUP:
	//TIMER0
	LDI		R16, 0
	OUT		TCNT0, R16
	LDI		R16, 156			;
	OUT		OCF0A, R16			;VALOR INCIAL
	LDI		R16, 2				;
	OUT		TCCR0A, R16			;CONFIGURACION CTC
	LDI		R16, 5				;
	OUT		TCCR0B, R16			;PRESCALER 1024
	
	//SALIDAS Y ENTRADAS
	LDI		R16, 0b0000_0000	;
	OUT		DDRB, R16			;COLOCO EL PUERTO B COMO ENTRADA
	LDI		R16, 0b1111_1111	;
	OUT		DDRC, R16			;COLOCO EL PUERTO C COMO SALIDA
	LDI		R16, 0b1111_1111	;
	OUT		DDRD, R16			;COLOCO EL PUERTO D COMO SALIDA

	LDI		R16, 0
	LDI		R17, 0
	LDI		R18, 1
	LDI		R19, 0
	OUT		PORTD, R18

LOOP:
	OUT		PORTD, R18
	CALL	RETARDO
	INC		R18
	CPI		R18, 16
	BRNE	LOOP
	LDI		R18, 0
	RJMP	LOOP 

;*******************************************************************************
;Subrutinas
;*******************************************************************************
;RETARDO

RETARDO:
	IN		R16, TIFR0			;
	SBRS	R16, OCF0A			;VERIFICA SI OCF0A = 1
	RJMP	RETARDO				;SI OCF0A = 0
	SBI		TIFR0, OCF0A		;SI OCF0A = 1, COLOCA A OCF0A = 0
	INC		R17
	CPI		R17, 10			
	BRNE	RETARDO
	CLR		R17
	RET