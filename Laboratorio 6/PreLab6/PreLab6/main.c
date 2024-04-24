/* Universidad del Valle de Guatemala
 * IE2023: Programacion de microcontroladores
 * Autor: Alejandra Marcos
 * PreLab5.c
 *
 * Created: 18/04/2024 16:59:24
 * Author : jaidy
 */ 
#define  F_CPU 16000000UL
#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

void init_UART(void);
void write_UART(char caracter);
void txt_write_UART(char* cadena);
unsigned char read_UART();

volatile char bufferRX;
uint8_t dato = 0;


int main(void){
    cli();
	init_UART();
	sei();
	write_UART('H');
	write_UART('O');
	write_UART('L');
	write_UART('A');
	write_UART(' ');
	write_UART('M');
	write_UART('U');
	write_UART('N');
	write_UART('D');
	write_UART('O');
	DDRB = 255;
	DDRD = 255;
	PORTD = 0;
	PORTB = 0;
    while (1) {

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

unsigned char read_UART(){
	if ((UCSR0A & (1 << UDRE0))){
		return UDR0;
	}else{
		return 0;
	}
}

ISR (USART_RX_vect){	
	dato = read_UART();
	if (dato != 0){
		PORTD = dato<<2;
		PORTB = dato>>6;
	}
}
