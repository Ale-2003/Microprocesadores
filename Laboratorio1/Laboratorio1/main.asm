;*******************************************************************************
;Universidad del Valle de Guatemala
;IE2023: Programacion de microcontroladores
;Autor: Alejandra Marcos
; Laboratorio1.asm
;
; Created: 31/01/2024 11:19:08
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
	LDI		R16, (1 << CLKPCE)
	STS		CLKPR, R16
	LDI		R16, 0b0000_0100
	STS		CLKPR, R16
	
	LDI		R16, 0b0000_0000	;
	OUT		DDRB, R16			;COLOCO EL PUERTO B COMO ENTRADA
	LDI		R16, 0b1111_1111	;
	OUT		DDRC, R16			;COLOCO EL PUERTO C COMO SALIDA
	LDI		R16, 0b1111_1111	;
	OUT		DDRD, R16			;COLOCO EL PUERTO D COMO SALIDA
	LDI		R18, 0				;R18 NUMERO 1
	LDI		R19, 0				;R19 NUMERO 2
	LDI		R20, 0				;R18 NUMERO 1
	LDI		R22, 0				;R18 NUMERO 1

LOOP:
	CALL	AUMENTAR_1
	CALL	DECREMENTAR_1

	CALL	AUMENTAR_2
	CALL	DECREMENTAR_2

	CALL	RESULTADO
	RJMP	LOOP 

;*******************************************************************************
;Subrutinas
;*******************************************************************************
;INCREMENTAR NUMERO 1
AUMENTAR_1:
	SBIS	PINB, PB0			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 1 (PIN DEL ARUINO D8)
	RET							;SI EL BIT 0 ES IGUAL A 0 
	CALL	RETARDO				;SI EL BIT 0 ES IGUAL A 1
CONFIRMAR_A:
	SBIC	PINB, PB0			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 0 (PIN DEL ARUINO D8)
	RJMP	CONFIRMAR_A			;SI EL BIT 0 ES IGUAL A 1
	INC		R18					;SUMA
	MOVW	R20, R18
	SWAP	R20
	ADD		R20, R19
	OUT		PORTD,R20			;MUESTRA EN EL PUERTO D
	RET

;*******************************************************************************
;DECREMENTAR NUMERO 1
DECREMENTAR_1:
	SBIS	PINB, PB1			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 1 (PIN DEL ARUINO D9)
	RET							;SI EL BIT 0 ES IGUAL A 0 
	CALL	RETARDO				;SI EL BIT 0 ES IGUAL A 1
CONFIRMAR_B:
	SBIC	PINB, PB1			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 0 (PIN DEL ARUINO D9)
	RJMP	CONFIRMAR_B			;SI EL BIT 0 ES IGUAL A 1
	DEC		R18					;RESTA
	MOVW	R20, R18 
	SWAP	R20
	ADD		R20, R19
	OUT		PORTD,R20			;MUESTRA EN EL PUERTO D
	RET

;*******************************************************************************
;INCREMENTAR NUMERO 2
AUMENTAR_2:
	SBIS	PINB, PB2			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 1 (PIN DEL ARUINO D8)
	RET							;SI EL BIT 0 ES IGUAL A 0 
	CALL	RETARDO				;SI EL BIT 0 ES IGUAL A 1
CONFIRMAR_C:
	SBIC	PINB, PB2			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 0 (PIN DEL ARUINO D8)
	RJMP	CONFIRMAR_C			;SI EL BIT 0 ES IGUAL A 1
	INC		R19					;SUMA
	MOVW	R20, R18 
	SWAP	R20
	ADD		R20, R19
	OUT		PORTD,R20			;MUESTRA EN EL PUERTO D
	RET

;*******************************************************************************
;DECREMENTAR NUMERO 2
DECREMENTAR_2:
	SBIS	PINB, PB3			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 1 (PIN DEL ARUINO D9)
	RET							;SI EL BIT 0 ES IGUAL A 0 
	CALL	RETARDO				;SI EL BIT 0 ES IGUAL A 1
CONFIRMAR_D:
	SBIC	PINB, PB3			;VERIFICA SI EL BIT 1 DEL PUERTO B ES IGUAL A 0 (PIN DEL ARUINO D9)
	RJMP	CONFIRMAR_D			;SI EL BIT 0 ES IGUAL A 1
	DEC		R19					;RESTA
	MOVW	R20, R18 
	SWAP	R20
	ADD		R20, R19
	OUT		PORTD,R20			;MUESTRA EN EL PUERTO D
	RET


;*******************************************************************************
;RESULTADO
RESULTADO:
	SBIS	PINB, PB4			;VERIFICA SI EL BIT 0 DEL PUERTO B ES IGUAL A 1 (PIN DEL ARUINO D8)
	RET	
	MOVW	R22, R18
	ADD		R22, R19			
	OUT		PORTC, R22
	RET


;*******************************************************************************
;RETARDOS
RETARDO:
	LDI		R17,0
	LDI		R16,0
INCR17:
	INC		R17
	CPI		R17, 0				;SI R18 = 0, SALTA UNA LINEA
	BRNE	INCR17
INCR16:
	INC		R16
	CPI		R16, 1				;SI R18 = 0, SALTA UNA LINEA
	BRNE	INCR16
	RET