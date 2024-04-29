/* Universidad del Valle de Guatemala
 * IE2023: Programacion de microcontroladores
 * Autor: Alejandra Marcos
 * PreLab5.c
 *
 * Created: 18/04/2024 16:59:24
 * Author : jaidy
 */ 
#define F_CPU 16000000
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include <stdio.h>
#include "ADC/ADC.h"

void init_UART(void);
void write_UART(char caracter);
void txt_write_UART(char* cadena);

int adcValue1 = 0;
uint8_t StateAscii = 0;
uint8_t StatePot = 0;
char buffLast = '0';
char buffer[10];

volatile char bufferRX;


int main(void)
{
	init_UART();
	initADC();
	sei();
	DDRD = 0xFF;
	DDRB = 0xFF;
	txt_write_UART(" 1. Leer potenciometro\n");
	txt_write_UART(" 2. Enviar Ascii\n");
	PORTD = 0;
	PORTB = 0;
	while (1){

		PORTD = buffLast<<2;
		PORTB = buffLast>>6;
		
		if (StatePot == 1){
			adcValue1 = ADC_CONVERT(0);
			
			sprintf(buffer, "%d", adcValue1);
			txt_write_UART("\nVoltaje: ");
			txt_write_UART(buffer);
			txt_write_UART("\n");
			txt_write_UART("\n 1. Leer potenciometro\n");
			txt_write_UART(" 2. Enviar Ascii\n");
			StatePot = 0;
		}
	}
}

void init_UART(void){
	//CONFIGUTAR RX Y TX
	DDRD &=~(1 << DDD0);
	DDRD |= (1 << DDD1);
	//CONFIGUTAR EL REGISTRO A (MODO FAST U2X0 = 1)
	UCSR0A = 0;
	UCSR0A |= (1 << U2X0);
	//CONFIGURAR EL REGISTRO B (HABILITAR ISR RX, HABILITAR RX Y TX)
	UCSR0B = 0;
	UCSR0B |= (1 << RXCIE0)|(1 << RXEN0)|(1 << TXEN0);
	//CONFIGURAR FRAME (8 BITS DE DATO, NO PARIDAD, 1 BIT STOP)
	UCSR0C = 0;
	UCSR0C |= (1 << UCSZ01)|(1 << UCSZ00);
	//CONFIGURAR BAUDRATE 9600
	UBRR0 = 207;
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

ISR(USART_RX_vect){
	bufferRX = UDR0;
	if(StateAscii >=1){
		//PORTB |= (1<<PB5);
		buffLast = bufferRX;
	}
	while(!(UCSR0A&(1<<UDRE0)));
	//UDR0 = bufferRX;
	if (StateAscii >= 1){
		StateAscii++;
		if (StateAscii >= 2){
			StateAscii = 0;
			txt_write_UART("\n");
			txt_write_UART("\n 1. Leer potenciometro\n");
			txt_write_UART(" 2. Enviar Ascii\n");
		}
	}
	if (StatePot == 1){
		if (bufferRX == '0'){
			StatePot = 0;
			txt_write_UART("\n");
			txt_write_UART("\n 1. Leer potenciometro\n");
			txt_write_UART(" 2. Enviar Ascii\n");
		}
	}
	if (bufferRX == '1'){
		if (StateAscii == 0){
			
			StatePot = 1;
		}
		} else if (bufferRX == '2'){
		if (StateAscii == 0){
			txt_write_UART("\nAscii: ");
			StateAscii = 1;
			PORTD = 0;
			PORTB = 0;
		}
	}
	
}
