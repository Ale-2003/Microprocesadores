;*******************************************************************************
;Universidad del Valle de Guatemala
;IE2023: Programacion de microcontroladores
;Autor: Alejandra Marcos
;Laboratorio2.asm
;
; Created: 6/02/2024 15:49:22
; Author : jaidy

;*******************************************************************************
;Encabezado
;*******************************************************************************
.include "M328PDEF.inc"
.cseg
.org 0x00

;*******************************************************************************
;Tabla de Valores
;*******************************************************************************
TABLA7SEG: .DB	 0x3F, 0x06, 0x5B, 0x4F, 0x66,	0x6D, 0x7D, 0x07, 0x7F, 0x6F, 0x77, 0x7C, 0X39, 0x5E, 0x79, 0x71

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
	LDI		R16, (1 << CLKPCE) ;	 ;HABILITA EL PRESCALER
	STS		CLKPR, R16 
	LDI		R16, 3					 ;OSCILADOR DE 2MHz
	STS		CLKPR, R16

	//TIMER0
	LDI		R16, 0
	OUT		TCCR0A, R16			;TMR0 NORMAL, OC0A DESCONECTADO
	LDI		R16, 5				
	OUT		TCCR0B, R16			;CS02 y CS00 PRESCALER 1024
	LDI		R16, 158			
	OUT		TCNT0, R16			;VALOR INICIAL
	
	//SALIDAS Y ENTRADAS
	LDI		R16, 0b0000_0000	;
	STS		UCSR0B, R16
	LDI		R16, 0b0000_0000	;
	OUT		DDRB, R16			;COLOCO EL PUERTO B COMO ENTRADA
	LDI		R16, 0b1111_1111	;
	OUT		DDRC, R16			;COLOCO EL PUERTO C COMO SALIDA
	LDI		R16, 0b1111_1111	;
	OUT		DDRD, R16			;COLOCO EL PUERTO D COMO SALIDA

	LDI		R16, 0
	LDI		R17, 0
	LDI		R18, 0
	LDI		R20, 0

	LDI		ZL, LOW(TABLA7SEG << 1)
	LDI		ZH, HIGH(TABLA7SEG << 1)

LOOP:
	CALL	AUMENTAR
	CALL	DECREMENTAR
	RJMP	LOOP 

;*******************************************************************************
;Subrutinas
;*******************************************************************************
;INCREMENTAR NUMERO 1
AUMENTAR:
	SBIS	PINB, PB0			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 1
	RET							;SI EL BIT 0 ES IGUAL A 0 
	CALL	DELAY_100MS			;SI EL BIT 0 ES IGUAL A 1
CONFIRMAR_A:
	SBIC	PINB, PB0			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 0
	RJMP	CONFIRMAR_A			;SI EL BIT 0 ES IGUAL A 1	
	LPM		R18, Z
	INC		ZL					;INCREMENTA EL NUMERO 1
	OUT		PORTC,R18			;MUESTRA EN EL PUERTO D
	RET

;*******************************************************************************
;DECREMENTAR NUMERO 1
DECREMENTAR:
	SBIS	PINB, PB1			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 1
	RET							;SI EL BIT 1 ES IGUAL A 0 
	CALL	DELAY_100MS			;SI EL BIT 1 ES IGUAL A 1
CONFIRMAR_B:
	SBIC	PINB, PB1			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 0
	RJMP	CONFIRMAR_B			;SI EL BIT 1 ES IGUAL A 1
	LPM		R18, Z
	DEC		ZL					;INCREMENTA EL NUMERO 1
	OUT		PORTC,R18			;MUESTRA EN EL PUERTO D
	RET

;*******************************************************************************
;RETARDOS
DELAY_100MS:
	IN		R16, TIFR0 ; LEEMOS EL REGISTRO DE LAS BANDERAS
	SBRS	R16, TOV0 ; VERIFICAMOS SI ESA BANDERA (TOV0) SE ENCENDIO
	RJMP	DELAY_100MS
	LDI		R16, 158 ; VOLVEMOS A CARGAR EL CONTADOR
	OUT		TCNT0, R16
	SBI		TIFR0, TOV0 ;APAGAMOS LA BANDERA
	RET
