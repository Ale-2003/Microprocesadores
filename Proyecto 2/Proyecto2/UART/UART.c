/*
 * UART.c
 *
 * Created: 5/05/2024 18:38:38
 *  Author: jaidy
 */ 
#include "UART.h"

void initUART(uint8_t Fast, uint16_t BaudRate){
	//CONFIGUTAR RX Y TX
	DDRD &=~(1 << DDD0);
	DDRD |= (1 << DDD1);
	UCSR0A = 0;
	
	if (Fast){
		//CONFIGUTAR EL REGISTRO A (MODO FAST U2X0 = 1)
		UCSR0A |= (1 << U2X0);	
		if (BaudRate == 9600){
			//CONFIGURAR BAUDRATE 9600
			UBRR0 = 207;
		}
	} else {
		UCSR0A = 0;
		if (BaudRate == 9600){
			//CONFIGURAR BAUDRATE 9600
			UBRR0 = 103;
		}
	}
	
	//CONFIGURAR EL REGISTRO B (HABILITAR ISR RX, HABILITAR RX Y TX)
	UCSR0B = 0;
	UCSR0B |= (1 << RXCIE0)|(1 << RXEN0)|(1 << TXEN0);
	
	//CONFIGURAR FRAME (8 BITS DE DATO, NO PARIDAD, 1 BIT STOP)
	UCSR0C = 0;
	UCSR0C |= (1 << UCSZ01)|(1 << UCSZ00);
}


void write_UART(char caracter){
	while (!(UCSR0A & (1 << UDRE0)));
	UDR0 = caracter;
}

void txt_write_UART(char* cadena){			//cadena de caracteres de tipo char
	while(*cadena !=0x00){
		write_UART(*cadena);				//transmite los caracteres de cadena
		cadena++;							//incrementa la ubicación de los caracteres en cadena
	}										//para enviar el siguiente caracter de cadena
}

unsigned char read_UART(void){
	if ((UCSR0A & (1 << UDRE0))){
		return UDR0;
		}else{
		return 0;
	}
}
