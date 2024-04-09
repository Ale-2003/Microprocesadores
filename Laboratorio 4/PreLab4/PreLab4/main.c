/* Universidad del Valle de Guatemala
 * IE2023: Programacion de microcontroladores
 * Autor: Alejandra Marcos
 * PreLab4.c
 *
 * Created: 8/04/2024 14:55:06
 * Author : jaidy
 */ 
#define F_CPU 16000000UL
#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

int CONT = 0;

void setup(void);
void buton(void);

int main(void){
	setup();	
     while (1) {
		//FUNCION DE BOTON
		buton();
    }
}


void setup(void){
	UCSR0B = 0;		// DESABILITA TX Y RX
	DDRB = 255;		// PUERTO B COMO SALIDA
	DDRD = 255;		// PUERTO D COMO SALIDA
	PORTC = 6;		// PIN PC0 Y PC1 PULL-UP
	DDRC = 248;		// PIN PC0, PC1 Y PC2 COMO ENTRADA
	
	// VALORES INICIALES
	PORTB = 0;
	PORTD = 0;
	PORTC |= (1 << PORTC3);
	PORTC &=~(1 << PORTC4);
}

void buton(void){
	if ((PINC & (1 << PINC1)) == 0){
		_delay_ms(200);					//VALIDA LA PULSACION
		if ((PINC & (1 << PINC1)) == 2){
			CONT++;						//INCREMENTA
		}else{CONT = CONT;}
	}
	if ((PINC & (1 << PINC2)) == 0)	{
		_delay_ms(200);					//VALIDA LA PULSACION
		if ((PINC & (1 << PINC2)) == 4){
			CONT--;						//DECREMENTA
		}else{CONT = CONT;}
	}
	PORTB = CONT;	
}
