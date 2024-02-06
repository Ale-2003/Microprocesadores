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
	//OSCILADOR
	LDI		R16, (1 << CLKPCE)	;CONFIGURACION DEL PRESCALER
	STS		CLKPR, R16			;HABILITA EL PRESCALER
	LDI		R16, 0b0000_0100	
	STS		CLKPR, R16			;SELECCIONAL EL PRESCALER DE 16MHz
	//SALIDAS Y ENTRADAS
	LDI		R16, 0b0000_0000	;
	OUT		DDRB, R16			;COLOCO EL PUERTO B COMO ENTRADA
	LDI		R16, 0b1111_1111	;
	OUT		DDRC, R16			;COLOCO EL PUERTO C COMO SALIDA
	LDI		R16, 0b1111_1111	;
	OUT		DDRD, R16			;COLOCO EL PUERTO D COMO SALIDA
	//TIMER0
	LDI		R16, (1 << CS02)|(1 << CS00)	;
	OUT		TCCR0B, R16			;PRESCALER 1024
	;LDI		R16, 0b0000_0000	;
	;STS		TIMSK0, R16			;DESACTIVA LAS INTERRUPCIONES
	LDI		R16, 99;
	OUT		TCNT0, R16			;VALOR INICIAL 

	LDI		R18, 0				;R18 NUMERO 1
	LDI		R19, 0				;R19 NUMERO 2
	LDI		R20, 0				;REGISTRO AUXILIAR PARA EL NUMERO 1
	LDI		R22, 0				;REGISTRO AUXILIAR PARA EL NUMERO 2

	SBI		PIND, PD0
LOOP:
	SBI		PIND, PD0
	
	IN		R16, TIFR0
	CPI		R16, (1<<TOV0)		;¿SON IGUALES?	
	BRNE	LOOP				;TOV0 NO ESTA SETADO

	LDI		R16, 99	;TOV0 SI ESTA SETEADO, DESBORDAMIENTO
	OUT		TCNT0, R16			;VALOR INICIAL 

	SBI		TIFR0, TOV0			;APAGAR LA BANDERA TOV0

	CBI		PIND, PD0

	RJMP	LOOP 


;*******************************************************************************
;Subrutinas
;*******************************************************************************
;INCREMENTAR NUMERO 1
AUMENTAR:
	SBIS	PINB, PB0			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 1
	RET							;SI EL BIT 0 ES IGUAL A 0 
	CALL	RETARDO				;SI EL BIT 0 ES IGUAL A 1
CONFIRMAR_A:
	SBIC	PINB, PB0			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 0
	RJMP	CONFIRMAR_A			;SI EL BIT 0 ES IGUAL A 1
	INC		R18					;INCREMENTA EL NUMERO 1
	MOVW	R20, R18			;COPIA EL NUMERO 1 PARA CAMBIAR LOS NIBLES
	SWAP	R20					;CAMBIA LOS NIBLES (MASCARA)
	ADD		R20, R19			;SUMA EL NUMERO 1 Y NUMERO 2 PARA MOSTRARLO EN UN SOLO PUERTO
	OUT		PORTD,R20			;MUESTRA EN EL PUERTO D
	RET

;*******************************************************************************
;DECREMENTAR NUMERO 1
DECREMENTAR:
	SBIS	PINB, PB1			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 1
	RET							;SI EL BIT 1 ES IGUAL A 0 
	CALL	RETARDO				;SI EL BIT 1 ES IGUAL A 1
CONFIRMAR_B:
	SBIC	PINB, PB1			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 0
	RJMP	CONFIRMAR_B			;SI EL BIT 1 ES IGUAL A 1
	DEC		R18					;DECREMENTA EL NUMERO 1
	MOVW	R20, R18			;COPIA EL NUMERO 1 PARA CAMBIAR LOS NIBLES
	SWAP	R20					;CAMBIA LOS NIBLES (MASCARA)
	ADD		R20, R19			;SUMA EL NUMERO 1 Y NUMERO 2 PARA MOSTRARLO EN UN SOLO PUERTO
	OUT		PORTD,R20			;MUESTRA EN EL PUERTO D
	RET


;*******************************************************************************
;RESULTADO
RESULTADO:
	SBIS	PINB, PB4			;VERIFICA SI EL BIT 4 DEL PUERTO B ES IGUAL A 1
	RET							;SI EL BIT 4 ES IGUAL A 0
	MOVW	R22, R18			;COPIA EL VALOR DEL NUMERO 1
	ADD		R22, R19			;SUMA EL VALOR DEL NUMERO 1 CON EL NUMERO 2
	OUT		PORTC, R22			;MUESTRA EL RESULTADO EN EL PUERTO C (EL BIT 4 ES EL DESBORDAMIENTO CARRY)
	RET



RETARDO:
	
	RET